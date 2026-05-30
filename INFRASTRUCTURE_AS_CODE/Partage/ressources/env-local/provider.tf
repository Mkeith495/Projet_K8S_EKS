terraform {
  required_providers {
    proxmox = {
        source = "bpg/proxmox"
        version = "0.100.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_api_token != "" ? null : var.proxmox_username
  password          = var.proxmox_api_token != "" ? null : var.proxmox_password
  api_token         = var.proxmox_api_token != "" ? var.proxmox_api_token : null
  insecure = true
}