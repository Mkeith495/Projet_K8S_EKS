proxmox_endpoint  = "https://pve.avalone-fr.com/"
proxmox_node_name = "proxmox5"

proxmox_username  = "epsi-m1dev@pve"
proxmox_password  = "P@ssw0rd"

proxmox_api_token = "epsi-m1dev@pve!terrafom=9cbc67ec-2d97-435f-8673-2f26b031d88f"

enable_vm = true

ssh_keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDhdFBXrHZXrKbaP7fBBX6rwWGDIEJ+Wl1NiuViA2QzchkTtucZi625p9Aj8EEv5OLuVWixY7dIEu8QhGUWRsgF9ajRQjqiOO+GcomtlgkqG9Yb8C6t/dBLTDWimmiZkw7nXsM6TfX1+dHFQkSYy64ttBFgyDxNCxwvCTkDkTXMuBuOkwwDhUnBpyMYld6gOf0y3oczsgoaFrA0KU24Mc9xjL/w0m3zIG1CJhFPtExd4ZB0nIj774wsJR7sgnIGCBVgAv+gojEq3D3HSC+TA+nPX2zFP0XdTzjqbDQ9Juqp1xIAqHR56lql0cAWSD/TG6U010/GdL2LcrBVq7SFU8Zr anthony@totoport" ]
vm_user_password = "P@ssw0rd"
vm_username = "Keith"

dns_servers = [
    "8.8.8.8",
    "1.1.1.1"
]

id_unique = "Mkeith495"

debian_vm_ip = {
    address = "dhcp"
    gateway = ""
}

debian_ct_ip = {
  address = "dhcp"
  gateway = ""
}

vm_datastore = "local_lvm5"