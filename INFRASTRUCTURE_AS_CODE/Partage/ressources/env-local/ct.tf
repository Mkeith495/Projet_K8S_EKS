resource "proxmox_virtual_environment_container" "debian_container" {
  description = "Managed by Terraform"

  node_name = var.proxmox_node_name

  unprivileged = true
  features {
    nesting = true
  }

  initialization {
    hostname = "debian-ct-01-${var.id_unique}"

    ip_config {
      ipv4 {
        address = var.debian_ct_ip.address
        gateway = var.debian_ct_ip.gateway
      }
    }

    dns {
      servers = var.dns_servers
    }

    user_account {
      password = var.vm_user_password
      keys = var.ssh_keys
    }
  }

  network_interface {
    name = "veth0"
  }

  disk {
    datastore_id = var.vm_datastore
    size         = 6
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
    type             = "debian"
  }
}