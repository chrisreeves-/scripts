# Types can be `host`, `network`, `port`, `url`, `urltable`, `geoip`, `networkgroup`, `mac`, `asn`, `dynipv6host`, `internal`, or `external`.
# https://github.com/firehol/blocklist-ipsets
# https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
# types = 1.00 = 24h, 0.50 = 12h, 0.25 = 6h, 0.04 = 1h, 0.010 = 15m, 0.001 = 1m

# Spamhaus DROP List = spamhaus_drop
resource "opnsense_firewall_alias" "spamhaus_drop" {
  name        = "spamhaus_drop"
  enabled     = true
  stats       = true
  update_freq = "0.50"

  type = "urltable"

  content = [
    "http://www.spamhaus.org/drop/drop.txt"
  ]

  categories = [
    opnsense_firewall_category.not_trusted.id
  ]

  description = "Spamhaus.org DROP list (according to their site this list should be dropped at tier-1 ISPs globally)"
}

# Spamhaus Extended DROP List = spamhaus_edrop
resource "opnsense_firewall_alias" "spamhaus_edrop" {
  name        = "spamhaus_edrop"
  enabled     = true
  stats       = true
  update_freq = "0.50"

  type = "urltable"

  content = [
    "http://www.spamhaus.org/drop/edrop.txt"
  ]

  categories = [
    opnsense_firewall_category.not_trusted.id
  ]

  description = "Spamhaus.org EDROP (extended matches that should be used with DROP)"
}

# emergingthreats.net default blacklist = et_block
resource "opnsense_firewall_alias" "emergingthreats_drop" {
  name        = "emergingthreats_drop"
  enabled     = true
  stats       = true
  update_freq = "0.50"

  type = "urltable"

  content = [
    "https://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt"
  ]

  categories = [
    opnsense_firewall_category.not_trusted.id
  ]

  description = "EmergingThreats.net default blacklist (at the time of writing includes spamhaus DROP, dshield and abuse.ch trackers, which are available separately too - prefer to use the direct ipsets instead of this, they seem to lag a bit in updates)"
}

# dshields (part of SANS)
resource "opnsense_firewall_alias" "dshields_drop" {
  name        = "dshields_drop"
  enabled     = true
  stats       = true
  update_freq = "0.50"

  type = "urltable"

  content = [
    "https://feeds.dshield.org/block.txt"
  ]

  categories = [
    opnsense_firewall_category.not_trusted.id
  ]

  description = "dshields top 20 cidr"
}

# blocklist.de fail2ban = blocklist_de
resource "opnsense_firewall_alias" "blocklist_de__drop" {
  name        = "blocklist_de_drop"
  enabled     = true
  stats       = true
  update_freq = "0.010"

  type = "urltable"

  content = [
    "https://lists.blocklist.de/lists/all.txt"
  ]

  categories = [
    opnsense_firewall_category.not_trusted.id
  ]

  description = "Blocklist.de IPs that have been detected by fail2ban in the last 48 hours"
}

# GeoIP Block
resource "opnsense_firewall_alias" "geoip_drop" {
  name    = "geoip_drop"
  enabled = true
  stats   = true

  type = "geoip"

  content = [
    "AF", "AX", "AL", "DZ", "AS", "AD", "AO", "AI", "AQ", "AG", "AR", "AM", "AW", "AT", "AZ",
    "BS", "BH", "BD", "BB", "BY", "BE", "BZ", "BJ", "BM", "BT", "BO", "BQ", "BA", "BW", "BR",
    "IO", "VG", "BN", "BG", "BF", "BI", "KH", "CM", "CA", "CV", "KY", "CF", "TD", "CL", "CN",
    "CX", "CC", "CO", "KM", "CG", "CD", "CK", "CR", "CI", "HR", "CU", "CW", "CY", "CZ", "DK",
    "DJ", "DM", "DO", "EC", "EG", "SV", "GQ", "ER", "EE", "ET", "FK", "FO", "FM", "FJ", "FI",
    "FR", "GF", "PF", "TF", "GA", "GM", "GE", "DE", "GH", "GI", "GR", "GL", "GD", "GP", "GU", "GS",
    "GT", "GG", "GN", "GW", "GY", "HT", "HN", "HK", "HU", "IS", "IN", "ID", "IR", "IQ", "IE",
    "IM", "IL", "IT", "JM", "JP", "JE", "JO", "KZ", "KE", "KI", "KW", "KG", "LA", "LV",
    "LB", "LS", "LR", "LY", "LI", "LT", "LU", "MO", "MK", "MG", "MW", "MY", "MV", "ML", "MT",
    "MH", "MQ", "MR", "MU", "YT", "MX", "FM", "MD", "MC", "MN", "ME", "MS", "MA", "MZ", "MM",
    "NA", "NR", "NP", "NL", "NC", "NZ", "NI", "NE", "NG", "NU", "NF", "KP", "MP", "NO", "OM",
    "PK", "PW", "PS", "PA", "PG", "PY", "PE", "PH", "PN", "PL", "PT", "PR", "QA", "RE", "RO",
    "RU", "RW", "BL", "SH", "KN", "LC", "MF", "PM", "VC", "WS", "SM", "ST", "SA", "SN", "RS",
    "SC", "SL", "SG", "SX", "SK", "SI", "SB", "SO", "ZA", "KR", "SS", "ES", "LK", "SD", "SR",
    "SJ", "SZ", "SE", "CH", "SY", "TW", "TJ", "TZ", "TH", "TL", "TG", "TK", "TO", "TT", "TN",
    "TR", "TM", "TC", "TV", "VI", "UG", "UA", "AE", "GB", "US", "UY", "UZ", "VU", "VA", "VE",
    "VN", "WF", "EH", "YE", "ZM", "ZW"
  ]

  categories = [
    opnsense_firewall_category.not_trusted.id
  ]

  description = "Blocking all countries from the Maxmind IP"
}