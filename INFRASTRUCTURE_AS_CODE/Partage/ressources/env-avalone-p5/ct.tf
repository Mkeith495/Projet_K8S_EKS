resource "proxmox_virtual_environment_container" "debian_container" {
  description = "Managed by Terraform"

  node_name = var.proxmox_node_name

  pool_id = "Dev"

  unprivileged = true
  features {
    nesting = true
  }

  initialization {
    hostname = "alma1"

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
    bridge = "vmbr0"
  }

  disk {
    datastore_id = var.vm_datastore
    size         = 6
  }

  operating_system {
    template_file_id = "local:vztmpl/almalinux-10-default_20250930_amd64.tar.xz"
    type             = "centos"
  }
}