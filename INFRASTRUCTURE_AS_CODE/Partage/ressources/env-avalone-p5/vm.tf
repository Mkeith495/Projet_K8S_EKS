resource "proxmox_virtual_environment_vm" "debian_vm" {
  count       = var.enable_vm ? 1 : 0
  name        = "debian-vm-01-${var.id_unique}"
  description = "Managed by Terraform"

  node_name = var.proxmox_node_name

  pool_id = "Dev"

  agent {
    enabled = false
  }
  
  stop_on_destroy = true

  cpu {
    cores        = 2
    type         = "host"
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = var.vm_datastore
    interface    = "scsi0"
    import_from = "local:import/debian-13-generic-amd64.qcow2"
    size = 10
  }

  initialization {

    datastore_id = var.vm_datastore

    ip_config {
      ipv4 {
        address = var.debian_vm_ip.address
        gateway = var.debian_vm_ip.gateway
      }
    }

    dns {
      servers = var.dns_servers
    }

    user_account {
      password = var.vm_user_password
      username = var.vm_username
      keys = var.ssh_keys
    }
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }

}