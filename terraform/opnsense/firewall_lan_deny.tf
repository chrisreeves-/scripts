resource "opnsense_firewall_filter" "firewall_deny_spamhaus_drop_internal" {
  enabled  = true
  action   = "block"
  sequence = 1
  quick    = true

  interface = [
    "lan",
  ]

  direction = "out"
  protocol  = "TCP"

  source = {
    net = "any"
  }

  destination = {
    net = opnsense_firewall_alias.spamhaus_drop.name
  }

  description = "Deny Spamhaus DROP on internal interface"
}

resource "opnsense_firewall_filter" "firewall_deny_spamhaus_edrop_internal" {
  enabled  = true
  action   = "block"
  sequence = 2
  quick    = true

  interface = [
    "lan",
  ]

  direction = "out"
  protocol  = "TCP"

  source = {
    net = "any"
  }

  destination = {
    net = opnsense_firewall_alias.spamhaus_edrop.name
  }

  description = "Deny Extended Spamhaus DROP on internal interface"
}

resource "opnsense_firewall_filter" "firewall_deny_emergingthreats_internal" {
  enabled  = true
  action   = "block"
  sequence = 3
  quick    = true

  interface = [
    "lan",
  ]

  direction = "out"
  protocol  = "TCP"

  source = {
    net = "any"
  }

  destination = {
    net = opnsense_firewall_alias.emergingthreats_drop.name
  }

  description = "Deny emergingthreats.net on internal interface"
}

resource "opnsense_firewall_filter" "firewall_deny_dsheilds_internal" {
  enabled  = true
  action   = "block"
  sequence = 4
  quick    = true

  interface = [
    "lan",
  ]

  direction = "out"
  protocol  = "TCP"

  source = {
    net = "any"
  }

  destination = {
    net = opnsense_firewall_alias.dshields_drop.name
  }

  description = "Deny dsheilds top 20 cidr on internal interface"
}

resource "opnsense_firewall_filter" "firewall_blocklist_de_block_internal" {
  enabled  = true
  action   = "block"
  sequence = 6
  quick    = true

  interface = [
    "lan",
  ]

  direction = "out"
  protocol  = "TCP"

  source = {
    net = "any"
  }

  destination = {
    net = opnsense_firewall_alias.blocklist_de__drop.name
  }

  description = "Deny blocklist.de on internal interface"
}