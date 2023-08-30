terraform {
  backend "remote" {
    organization = ""

    token = ""

    workspaces {
      name = ""
    }
  }

  required_providers {
    opnsense = {
      version = "0.6.0"
      source  = "browningluke/opnsense"
    }
  }
}