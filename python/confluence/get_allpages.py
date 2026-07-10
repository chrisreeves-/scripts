#!/usr/bin/env python3
"""
get_allpages.py — Export one or more Confluence Cloud spaces to local HTML,
with embedded images and all attachments downloaded for offline viewing.

Created  27-05-2023 by Chris Reeves.
Rewritten 10-07-2026:
  1. Full cursor-based pagination (no more silent 250/10000-page truncation).
  2. Confluence Cloud REST API **v2** (/wiki/api/v2/...) instead of the
     deprecated v1 (/wiki/rest/api/...).
  3. Downloads every attachment and rewrites embedded images to local files,
     so exported pages render offline.
  4. Robust error handling: ret/backoff on 429 & 5xx, per-page isolation
     (one bad page no longer aborts the whole export), config validation.
  5. Correct modern page URLs via _links.base + _links.webui (no legacy
     viewpage.action?pageId= form).

Requirements:
    pip install requests
    Create an API token: https://id.atlassian.com/manage-profile/security/api-tokens
    Auth is HTTP Basic with your email + token (requests handles the base64).

Configure via environment variables or CLI flags (CLI overrides env):
    CONFLUENCE_URL        e.g. https://nearmap.atlassian.net   (--url)
    CONFLUENCE_EMAIL      your Atlassian account email          (--email)
    CONFLUENCE_API_TOKEN  the API token                         (--token)
    CONFLUENCE_SPACES     comma-separated space keys, e.g. SM,Trust  (--spaces)
    OUTPUT_DIR            output root (default ~/Desktop/confluence-export)  (--out)

Example:
    export CONFLUENCE_URL=https://nearmap.atlassian.net
    export CONFLUENCE_EMAIL=chris.reeves@nearmap.com
    export CONFLUENCE_API_TOKEN=xxxxxxxx
    python3 get_allpages.py --spaces SM,Trust --out ~/Desktop/confluence
"""

import argparse
import html
import os
import re
import sys
import time
from urllib.parse import urljoin, urlparse

try:
    import requests
except ImportError:
    sys.exit("This script needs 'requests'. Install it with: pip install requests")


# --------------------------------------------------------------------------- #
# Configuration (CLI flag > env var > default)
# --------------------------------------------------------------------------- #
def parse_args():
    p = argparse.ArgumentParser(description="Export Confluence Cloud space(s) to local HTML + attachments.")
    p.add_argument("--url", default=os.environ.get("CONFLUENCE_URL", "https://example.atlassian.net"),
                   help="Confluence base URL, e.g. https://your.atlassian.net")
    p.add_argument("--email", default=os.environ.get("CONFLUENCE_EMAIL", ""),
                   help="Atlassian account email (Basic-auth username).")
    p.add_argument("--token", default=os.environ.get("CONFLUENCE_API_TOKEN", ""),
                   help="Atlassian API token.")
    p.add_argument("--spaces", default=os.environ.get("CONFLUENCE_SPACES", ""),
                   help="Comma-separated space keys, e.g. SM,Trust")
    p.add_argument("--out", default=os.environ.get("OUTPUT_DIR", os.path.expanduser("~/Desktop/confluence-export")),
                   help="Output directory root.")
    p.add_argument("--page-limit", type=int, default=250, help="Page size for list requests (max 250).")
    p.add_argument("--timeout", type=int, default=30, help="Per-request timeout (seconds).")
    p.add_argument("--max-retries", type=int, default=5, help="Retries on 429/5xx/network errors.")
    return p.parse_args()


ARGS = parse_args()
BASE_URL = ARGS.url.rstrip("/")               # e.g. https://nearmap.atlassian.net
ORIGIN = "{u.scheme}://{u.netloc}".format(u=urlparse(BASE_URL))
WIKI = BASE_URL + "/wiki"                      # e.g. https://nearmap.atlassian.net/wiki
API = WIKI + "/api/v2"

SESSION = requests.Session()
SESSION.auth = (ARGS.email, ARGS.token)        # HTTP Basic; requests base64-encodes
SESSION.headers.update({"Accept": "application/json", "User-Agent": "confluence-export/2.0"})

_ILLEGAL = re.compile(r'[<>:"/\\|?*\x00-\x1f]')


# --------------------------------------------------------------------------- #
# Helpers
# --------------------------------------------------------------------------- #
def sanitize_filename(name, fallback="untitled"):
    """Make a string safe as a cross-platform filename."""
    name = _ILLEGAL.sub("-", (name or "").strip())
    name = name.rstrip(". ")                    # Windows dislikes trailing dot/space
    name = name[:180]                           # keep well under filesystem limits
    return name or fallback


def to_absolute(link, prefer_wiki=True):
    """Turn a Confluence relative _links value into an absolute URL."""
    if not link:
        return None
    if link.startswith("http://") or link.startswith("https://"):
        return link
    if link.startswith("/wiki"):
        return urljoin(ORIGIN, link)
    # Links like /spaces/... or /download/... are relative to the /wiki base.
    return urljoin(WIKI + "/", link.lstrip("/")) if prefer_wiki else urljoin(ORIGIN, link)


def api_get(url, params=None, stream=False):
    """GET with retry/backoff on 429, 5xx and transient network errors."""
    last_exc = None
    for attempt in range(1, ARGS.max_retries + 1):
        try:
            r = SESSION.get(url, params=params, timeout=ARGS.timeout, stream=stream)
        except requests.RequestException as e:
            last_exc = e
            if attempt == ARGS.max_retries:
                raise
            time.sleep(min(2 ** attempt, 30))
            continue

        if r.status_code == 429:
            wait = int(r.headers.get("Retry-After", min(2 ** attempt, 30)))
            time.sleep(wait)
            continue
        if 500 <= r.status_code < 600 and attempt < ARGS.max_retries:
            time.sleep(min(2 ** attempt, 30))
            continue
        r.raise_for_status()
        return r
    if last_exc:
        raise last_exc
    raise RuntimeError("Exhausted retries for %s" % url)


def paginate(url, params=None):
    """Yield every result across all pages, following body _links.next (cursor)."""
    params = dict(params or {})
    first = True
    while url:
        data = api_get(url, params=params if first else None).json()
        for item in data.get("results", []):
            yield item
        nxt = data.get("_links", {}).get("next")
        url = to_absolute(nxt, prefer_wiki=False) if nxt else None  # next already starts with /wiki
        first = False


def get_space_id(space_key):
    """Resolve a numeric space id from its key (v2 requires the id)."""
    data = api_get(API + "/spaces", params={"keys": space_key, "limit": 1}).json()
    results = data.get("results", [])
    if not results:
        raise LookupError("Space '%s' not found or you lack 'View' permission." % space_key)
    return results[0]["id"]


# --------------------------------------------------------------------------- #
# Storage-format image rewriting
# --------------------------------------------------------------------------- #
_AC_IMAGE = re.compile(r"<ac:image\b([^>]*)>(.*?)</ac:image>", re.DOTALL)
_RI_ATTACH = re.compile(r'<ri:attachment\b[^>]*\bri:filename="([^"]+)"')
_RI_URL = re.compile(r'<ri:url\b[^>]*\bri:value="([^"]+)"')
_AC_WIDTH = re.compile(r'ac:width="(\d+)"')


def rewrite_images(storage_html, attachment_rel_by_name):
    """Replace <ac:image> macros with plain <img>, pointing attachment images
    at their downloaded local copies and external images at their URL."""
    def repl(m):
        attrs, inner = m.group(1), m.group(2)
        width = _AC_WIDTH.search(attrs)
        width_attr = ' width="%s"' % width.group(1) if width else ""

        am = _RI_ATTACH.search(inner)
        if am:
            fname = html.unescape(am.group(1))
            rel = attachment_rel_by_name.get(fname)
            src = rel if rel else ("attachments/" + fname)  # best-effort if not found
            return '<img src="%s" alt="%s"%s />' % (html.escape(src), html.escape(fname), width_attr)

        um = _RI_URL.search(inner)
        if um:
            src = html.unescape(um.group(1))
            return '<img src="%s"%s />' % (html.escape(src), width_attr)

        return m.group(0)  # leave anything we don't understand untouched

    return _AC_IMAGE.sub(repl, storage_html)


def wrap_html(title, page_url, page_id, version, body):
    parts = [
        "<!DOCTYPE html>",
        '<html lang="en"><head><meta charset="utf-8">',
        "<title>%s</title>" % html.escape(title),
        '<style>body{font-family:-apple-system,Segoe UI,Arial,sans-serif;max-width:900px;'
        "margin:2rem auto;padding:0 1rem;line-height:1.5}img{max-width:100%;height:auto}"
        ".meta{color:#666;font-size:.85rem;border-bottom:1px solid #eee;padding-bottom:.5rem;"
        "margin-bottom:1rem}</style></head><body>",
        "<h1>%s</h1>" % html.escape(title),
        '<div class="meta">Page ID %s &middot; version %s &middot; '
        '<a href="%s">View live in Confluence</a></div>' % (
            html.escape(str(page_id)), html.escape(str(version)), html.escape(page_url or "#")),
        body or "<p><em>(empty page body)</em></p>",
        "</body></html>",
    ]
    return "\n".join(parts)


# --------------------------------------------------------------------------- #
# Export
# --------------------------------------------------------------------------- #
def download_attachments(page_id, dest_dir, pages_dir):
    """Download all attachments for a page. Returns {filename: path_relative_to_pages_dir}
    so image src values resolve from the exported HTML in pages/."""
    rel_by_name = {}
    used = set()
    for att in paginate(API + "/pages/%s/attachments" % page_id, params={"limit": ARGS.page_limit}):
        fname = sanitize_filename(att.get("title") or att.get("fileId") or att["id"])
        if fname in used:  # disambiguate duplicate titles
            stem, dot, ext = fname.rpartition(".")
            fname = ("%s-%s.%s" % (stem, att["id"], ext)) if dot else ("%s-%s" % (fname, att["id"]))
        used.add(fname)

        dl = to_absolute((att.get("_links") or {}).get("download") or att.get("downloadLink"))
        if not dl:
            print("      ! attachment '%s' has no download link — skipped" % fname)
            continue
        os.makedirs(dest_dir, exist_ok=True)
        out_path = os.path.join(dest_dir, fname)
        try:
            r = api_get(dl, stream=True)
            with open(out_path, "wb") as fh:
                for chunk in r.iter_content(chunk_size=65536):
                    if chunk:
                        fh.write(chunk)
            # record under both the sanitized name and the original title so
            # the storage-format ri:filename lookup resolves either way.
            # Path is relative to pages/ (e.g. ../attachments/{id}/file.png).
            page_rel = os.path.relpath(out_path, pages_dir)
            rel_by_name[att.get("title") or fname] = page_rel
            rel_by_name[fname] = page_rel
        except requests.RequestException as e:
            print("      ! failed to download '%s': %s" % (fname, e))
    return rel_by_name


def export_space(space_key, out_root):
    print("\n=== Exporting space '%s' ===" % space_key)
    space_id = get_space_id(space_key)
    space_dir = os.path.join(out_root, sanitize_filename(space_key))
    pages_dir = os.path.join(space_dir, "pages")
    att_root = os.path.join(space_dir, "attachments")
    os.makedirs(pages_dir, exist_ok=True)

    index_rows = []
    used_names = set()
    ok = 0
    failed = []

    pages = paginate(API + "/spaces/%s/pages" % space_id,
                     params={"body-format": "storage", "status": "current", "limit": ARGS.page_limit})

    for page in pages:
        pid = page.get("id")
        title = page.get("title") or ("untitled-%s" % pid)
        try:
            links = page.get("_links") or {}
            base = links.get("base") or WIKI
            page_url = urljoin(base + "/", (links.get("webui") or "").lstrip("/")) if links.get("webui") else None
            version = (page.get("version") or {}).get("number", "")
            storage = ((page.get("body") or {}).get("storage") or {}).get("value", "") or ""

            # attachments (into attachments/{pageId}/) then rewrite image refs
            att_dir = os.path.join(att_root, str(pid))
            rel_by_name = download_attachments(pid, att_dir, pages_dir)
            body = rewrite_images(storage, rel_by_name)

            # unique, safe filename for the page
            base_name = sanitize_filename(title, fallback="untitled-%s" % pid)
            name = base_name
            if name.lower() in used_names:
                name = "%s (%s)" % (base_name, pid)
            used_names.add(name.lower())
            out_path = os.path.join(pages_dir, name + ".html")

            with open(out_path, "w", encoding="utf-8") as fh:
                fh.write(wrap_html(title, page_url, pid, version, body))

            index_rows.append((title, os.path.relpath(out_path, space_dir), page_url))
            ok += 1
            print("  [OK] %s (%s attachments)" % (title, len(set(rel_by_name.values()))))
        except Exception as e:  # isolate per-page failures
            failed.append((pid, title, str(e)))
            print("  [FAIL] %s (id %s): %s" % (title, pid, e))

    # index.html
    with open(os.path.join(space_dir, "index.html"), "w", encoding="utf-8") as fh:
        fh.write("<!DOCTYPE html><html><head><meta charset='utf-8'><title>%s export</title></head><body>"
                 % html.escape(space_key))
        fh.write("<h1>%s — %d pages</h1><ul>" % (html.escape(space_key), len(index_rows)))
        for title, rel, url in sorted(index_rows, key=lambda r: r[0].lower()):
            live = " (<a href='%s'>live</a>)" % html.escape(url) if url else ""
            fh.write("<li><a href='%s'>%s</a>%s</li>" % (html.escape(rel), html.escape(title), live))
        fh.write("</ul></body></html>")

    if failed:
        with open(os.path.join(space_dir, "_errors.log"), "w", encoding="utf-8") as fh:
            for pid, title, err in failed:
                fh.write("%s\t%s\t%s\n" % (pid, title, err))
    print("  Space '%s': %d exported, %d failed -> %s" % (space_key, ok, len(failed), space_dir))
    return ok, len(failed)


def main():
    # config validation
    problems = []
    if not ARGS.spaces.strip():
        problems.append("No space keys given (--spaces SM,Trust or CONFLUENCE_SPACES).")
    if BASE_URL.startswith("https://example."):
        problems.append("CONFLUENCE_URL is still the placeholder (--url / CONFLUENCE_URL).")
    if not ARGS.email or not ARGS.token or ARGS.token == "REDACTED":
        problems.append("Missing email/token (--email/--token or CONFLUENCE_EMAIL/CONFLUENCE_API_TOKEN).")
    if problems:
        sys.exit("Configuration error:\n  - " + "\n  - ".join(problems))

    # fail fast on bad credentials
    try:
        api_get(API + "/spaces", params={"limit": 1})
    except requests.HTTPError as e:
        code = e.response.status_code if e.response is not None else "?"
        sys.exit("Authentication/authorization check failed (HTTP %s). "
                 "Verify URL, email and API token." % code)

    os.makedirs(ARGS.out, exist_ok=True)
    total_ok = total_fail = 0
    for key in [s.strip() for s in ARGS.spaces.split(",") if s.strip()]:
        try:
            o, f = export_space(key, ARGS.out)
            total_ok += o
            total_fail += f
        except LookupError as e:
            print("  [SKIP] %s" % e)
        except requests.HTTPError as e:
            code = e.response.status_code if e.response is not None else "?"
            print("  [SKIP] space '%s' failed (HTTP %s)" % (key, code))

    print("\nDone. %d pages exported, %d failed. Output: %s" % (total_ok, total_fail, ARGS.out))
    sys.exit(1 if total_fail else 0)


if __name__ == "__main__":
    main()
