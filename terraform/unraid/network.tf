resource "libvirt_network" "network" {
  name      = "network"
  mode      = "bridge"
  bridge    = "br0"
  addresses = ["10.64.10.0/24"]
}