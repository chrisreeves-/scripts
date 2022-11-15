# Terraform for Unraid

## Requirements

1. mkisofs # This is required on the device you are running Terraform and is used to create the image and located in the PATH
2. Libvirt needs to be listening on 0.0.0.0 on the Unraid server

## Tested Using

Unraid version 6.11.3
Libvirt Terraform provider version 0.7.0

## Libvirt Provider
https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs

## mkisofs
https://sourceforge.net/projects/cdrtools/

## Helpful Examples
Example init: https://cloudinit.readthedocs.io/en/latest/topics/examples.html
Example tf: https://github.com/dmacvicar/terraform-provider-libvirt/blob/main/examples/v0.12/ubuntu/ubuntu-example.tf
Add user https://github.com/vmware/photon/issues/659 (How to set password)
