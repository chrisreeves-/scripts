import requests
import os

'''
Created on 27-05-2023 by Chris Reeves
Description: This script will download all pages from a Confluence space and save them as HTML files in a directory.

Requirements:
    1.  Create an API key for your Confluence account from the following URL: https://id.atlassian.com/manage-profile/security/api-tokens
    2.  Go to "Space Settings" -> "Manage pages" and look at the end of the URL path for "?Key=XYZ" (No admin rights required)
    3.  API key needs to be base64 encoded with email address and a colon (:) prepended to it
        example: joe.blogs@example.com:YOURAPIKEY
'''

# Set your Confluence Space URL, API key, and output directory
CONFLUENCE_URL = 'https://example.atlassian.net'
SPACE_KEY = 'REDACTED'
API_KEY = 'REDACTED'
OUTPUT_DIR = f"/Users/name/Desktop/{SPACE_KEY}"

# Create the output directory if it doesn't exist
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

# Set the request headers
headers = {
    'Accept': 'application/json',
    'Authorization': f'Basic {API_KEY}'
}

# Get the list of all pages including pagination in the space
url = f'{CONFLUENCE_URL}/wiki/rest/api/space/{SPACE_KEY}/content/page?limit=10000'
response = requests.get(url, headers=headers)
pages = response.json().get('results', [])

# Download each page
for page in pages:
    page_id = page['id']
    page_title = page['title']
    page_url = f'{CONFLUENCE_URL}/wiki/pages/viewpage.action?pageId={page_id}'

    # Request the page content
    url = f'{CONFLUENCE_URL}/wiki/rest/api/content/{page_id}?expand=body.storage'
    response = requests.get(url, headers=headers)
    page_data = response.json()
    page_content = page_data['body']['storage']['value']

    # if page_title has a "/" in it, replace it with a "-"
    page_title_fixed = page_title.replace("/", "-")

    # Save the page content as HTML
    html_filename = f'{OUTPUT_DIR}/{page_title_fixed}.html'
    with open(html_filename, 'w', encoding='utf-8') as file:
        file.write(page_content)

    print(f'Downloaded page: {page_title} ({page_url})')

print('All pages downloaded successfully!')
