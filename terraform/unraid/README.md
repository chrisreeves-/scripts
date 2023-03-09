# Terraform for Unraid 

## Description

Deploy an Unraid virtual machine using Terraform and some hackery

## Requirements

1. mkisofs # This is required on the device you are running Terraform and is used to create the image and located in the PATH
2. Libvirt needs to be listening on 0.0.0.0 on the Unraid server

## Tested Using

Unraid version 6.11.3
Libvirt Terraform provider version 0.7.1

## Libvirt Provider
https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs

## mkisofs
https://sourceforge.net/projects/cdrtools/

### mkisofs PATH
```shell
path="/usr/local/bin/mkisofs"

if [ ! -f $path ]; then
  cp /source/path/mkisofs /usr/local/bin
  echo "Copied mkisofs to PATH"
  else
  echo "mkisofs already in PATH"
fi
```

## Change Libvirt Listen Address
1. Use your favorite command line editor to open `/etc/libvirt/libvirtd.conf` on the Unraid host
2. Search for `listen_addr = "127.0.0.1"`
3. Change to `listen_addr = "0.0.0.0"`

![img.png](images/img.png)

## Expanding Cloud Init Disk
To expand the server disk you need to run `qemu-img` on the Unraid host.

_Example:_
```shell
vm_name="nameofserver"
vm_disk_size="desired size in GB"
version_ubuntu="Ubuntu version")
state=$(virsh domstate $vm_name)
file_qcow="/mnt/user/images/$vm_name-pool/$vm_name-ubuntu-$version_ubuntu.qcow2"

if [ $state == "running" ]
then
	echo "Stopping VM to get lock on disk"
  virsh destroy $vm_name
else
	echo "VM already in stopped state"
fi

if [ -f $file_qcow ]; 
then 
	echo "Image already exists, skipping resizing"
else
	qemu-img resize $file_qcow +$vm_disk_size
fi

virsh start $vm_name
```

_Note: You cannot resize the size when it is in use and locked therefore the vitual machine needs to be in a powered off state hence the `virsh` command to start the virtual machine once the disk size has changed. I've also set the virtual machine to be in a powered off state once created so this step can be run straight afterwards._

## Helpful Examples

Example Cloud Init: https://cloudinit.readthedocs.io/en/latest/topics/examples.html

Example Terraform: https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.12/ubuntu/ubuntu-example.tf

Create Secret Hash: https://github.com/vmware/photon/issues/659

Libvirt Listen Address: https://wiki.libvirt.org/page/Libvirt_daemon_is_not_listening_on_tcp_ports_although_configured_to
