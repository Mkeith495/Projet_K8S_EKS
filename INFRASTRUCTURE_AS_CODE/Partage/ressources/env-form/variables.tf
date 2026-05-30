variable "proxmox_endpoint" {
    description = "URL d'accès à Proxmox"
    type = string
    default = "https://127.0.0.1:8006/"
}

variable "proxmox_username" {
    description = "Utilisateur Proxmox"
    type = string
    default = "root@pam"
}

variable "proxmox_password" {
    description = "Mot de passe Proxmox"
    type = string
    default = "motdepasse"
}

variable "proxmox_api_token" {
    description = "API Token Proxmox (format: user@realm!tokenid=secret). Si défini, il est utilisé à la place du mot de passe."
    type        = string
    default     = ""
}

variable "proxmox_node_name" {
    type = string
    description = "Nom du node proxmox"
  
}

variable "id_unique" {
    type = string
}

variable "ssh_keys" {
    description = "Clés SSH pour l'authentification"
    type = list(string)
}

variable "vm_user_password" {
    description = "Mot de passe affecté à la création des VMs / CTs"
    type = string
}

variable "vm_username" {
    description = "Utilisateur affecté à la création des VMs / CTs"
    type = string
}

variable "dns_servers" {
    description = "Serveurs DNS"
    type = list(string)
}

variable "debian_vm_ip" {
    description = "Adressage IP VM Debian"
    type = object({
      address = string
      gateway = string
    })
}

variable "debian_ct_ip" {
    description = "Adressage IP CT Debian"
    type = object({
      address = string
      gateway = string
    })
}

variable "vm_datastore" {
    description = "Stockage des CT / VM"
    type = string
}