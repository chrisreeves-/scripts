terraform {
  backend "remote" {
    organization = "your terraform cloud org"

    token = "your token here"

    workspaces {
      name = "your terraform workspace name here"
    }
  }

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}
