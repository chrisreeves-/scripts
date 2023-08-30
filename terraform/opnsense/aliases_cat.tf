# Use the following link to get HEX color codes: https://www.color-hex.com/

resource "opnsense_firewall_category" "trusted" {
  name  = "trusted"
  color = "8fce00"
}

resource "opnsense_firewall_category" "not_trusted" {
  name  = "not_trusted"
  color = "f44336"
}