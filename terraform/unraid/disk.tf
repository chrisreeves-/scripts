resource "libvirt_pool" "pool" {
  name = "pool"
  type = "dir"
  path = "/mnt/user/images/pool"
}

resource "libvirt_volume" "qcow2" {
  name   = "ubuntu2204.qcow2"
  pool   = libvirt_pool.pool.name
  source = "https://cloud-images.ubuntu.com/releases/22.04/release/ubuntu-22.04-server-cloudimg-amd64.img"
  format = "qcow2"
}