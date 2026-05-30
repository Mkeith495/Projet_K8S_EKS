variable "proxmox_endpoint" {
  description = "URL d'accès à Proxmox"
  type        = string
  default     = "https://127.0.0.1:8006/"
}

variable "proxmox_username" {
  description = "Nom d'utilisateur pour l'accès à Proxmox"
  type        = string
  default     = ""
}

variable "proxmox_password" {
  description = "Mot de passe pour l'accès à Proxmox"
  type        = string
  default     = ""
}

variable "ssh_keys" {
  description = "Clés SSH"
  type        = list(string)
  default     = [""]
}

variable "user_password" {
  description = "Mot de passe pour l'utilisateur"
  type        = string
  default     = ""
}

variable "cp_server_ip" {
  description = "IP du serveur CP"
  type        = string
  default     = ""
}

variable "cp_server_gateway" {
  description = "IP de la passerelle du serveur CP"
  type        = string
  default     = ""
}

variable "cp_server_dns" {
  description = "IP du serveur DNS du serveur CP"
  type        = list(string)
  default     = [""]
}