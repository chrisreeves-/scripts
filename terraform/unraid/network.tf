resource "libvirt_network" "network" {
  name      = "network"
  mode      = "nat"
  addresses = ["10.64.10.48/27"]
}