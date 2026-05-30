resource "proxmox_virtual_environment_pool" "pool_utilisateurs" {
  for_each = { for user in var.utilisateurs : user.username => user }
  comment = "Pool de l'utilisateur ${each.value.firstname} ${each.value.lastname}"
  pool_id = each.value.username
}