resource "proxmox_virtual_environment_container" "cp-server" {
  description = "Managed by Terraform"
  node_name   = "proxmox"

  unprivileged = true
  features {
    nesting = true
  }

  initialization {
    hostname = "cp-server"

    ip_config {
      ipv4 {
        address = var.cp_server_ip
        gateway = var.cp_server_gateway
      }
    }

    dns {
      servers = var.cp_server_dns
    }

    user_account {
      password = var.user_password
      keys     = var.ssh_keys
    }
  }

  network_interface {
    name = "veth0"
  }

  disk {
    datastore_id = "local-lvm"
    size         = 6
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
    type             = "debian"
  }

  provisioner "file" {
    connection {
      host  = split("/", var.cp_server_ip)[0]
      agent = true
      user = "root"
    }

    source      = "deploy-cp.sh"
    destination = "/tmp/deploy-cp.sh"
  }

  provisioner "remote-exec" {
    connection {
      host  = split("/", var.cp_server_ip)[0]
      agent = true
      user = "root"
    }

    inline = [
      "bash /tmp/deploy-cp.sh"
    ]
  }
}