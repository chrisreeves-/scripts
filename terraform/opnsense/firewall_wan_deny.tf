resource "opnsense_firewall_filter" "firewall_deny_spamhaus_drop" {
  enabled  = true
  action   = "block"
  sequence = 1
  quick    = true

  interface = [
    "wan",
  ]

  direction = "in"
  protocol  = "TCP"

  source = {
    net = opnsense_firewall_alias.spamhaus_drop.name
  }

  destination = {
    net = "wanip"
  }

  description = "Deny Spamhaus DROP on external interface"
}

resource "opnsense_firewall_filter" "firewall_deny_spamhaus_edrop" {
  enabled  = true
  action   = "block"
  sequence = 2
  quick    = true

  interface = [
    "wan",
  ]

  direction = "in"
  protocol  = "TCP"

  source = {
    net = opnsense_firewall_alias.spamhaus_edrop.name
  }

  destination = {
    net = "wanip"
  }

  description = "Deny Extended Spamhaus DROP on external interface"
}

resource "opnsense_firewall_filter" "firewall_deny_emergingthreats" {
  enabled  = true
  action   = "block"
  sequence = 3
  quick    = true

  interface = [
    "wan",
  ]

  direction = "in"
  protocol  = "TCP"

  source = {
    net = opnsense_firewall_alias.emergingthreats_drop.name
  }

  destination = {
    net = "wanip"
  }

  description = "Deny emergingthreats.net on external interface"
}

resource "opnsense_firewall_filter" "firewall_deny_dsheilds" {
  enabled  = true
  action   = "block"
  sequence = 4
  quick    = true

  interface = [
    "wan",
  ]

  direction = "in"
  protocol  = "TCP"

  source = {
    net = opnsense_firewall_alias.dshields_drop.name
  }

  destination = {
    net = "wanip"
  }

  description = "Deny dsheilds top 20 cidr on external interface"
}

resource "opnsense_firewall_filter" "firewall_blocklist_de_block" {
  enabled  = true
  action   = "block"
  sequence = 6
  quick    = true

  interface = [
    "wan",
  ]

  direction = "in"
  protocol  = "TCP"

  source = {
    net = opnsense_firewall_alias.blocklist_de__drop.name
  }

  destination = {
    net = "wanip"
  }

  description = "Deny blocklist.de on external interface"
}

resource "opnsense_firewall_filter" "firewall_geoip_block" {
  enabled  = true
  action   = "block"
  sequence = 7
  quick    = true

  interface = [
    "wan",
  ]

  direction = "in"
  protocol  = "TCP"

  source = {
    net = opnsense_firewall_alias.geoip_drop.name
  }

  destination = {
    net = "wanip"
  }

  description = "Deny blocked GeoIP on external interface"
}