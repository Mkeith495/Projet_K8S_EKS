output "ct" {
  value = proxmox_virtual_environment_container.cp-server.ipv4[0].address
}