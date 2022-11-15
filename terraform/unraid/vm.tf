resource "libvirt_domain" "domain" {
  name   = "servernamehere"
  memory = "4096"

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {
    network_id = libvirt_network.network.id
  }

  disk {
    volume_id = libvirt_volume.vtiger-qcow2.id
    scsi      = true
  }
}
