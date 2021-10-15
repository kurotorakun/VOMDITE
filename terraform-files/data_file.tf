# Data files 

# [ SSH KEYS ]
# Ansible service private key
data "local_file" "ansible_id_rsa" {
    filename   = "./ssh_keys/ansible_id_rsa"
}

# Ansible service public key
data "local_file" "ansible_id_rsa_pub" {
    filename   = "./ssh_keys/ansible_id_rsa.pub"
}

# Terraform host public key
data "local_file" "host_pubkey" {
    filename   = var.host_pubkey_path
}

# [ OTHER FILES ]
# file 10-disable-ipv6.conf to disable IPv6 on hosts.
#   must be included using write_files of cloud-init userdata
data "local_file" "no_IPv6" {
    filename   = "./template_files/disable-ipv6.conf"
}

# [ SERVICES METADATA ]
# CHR-LAN - USERDATA
# data "template_file" "chrlan_userDefault" {
#   template     = file("./template_files/chr-lan.rsc")
#   vars         = {
#     HOSTNAME       = "CHR-LAN"
#   }
# }

# SRV0xx - METADATA
data "template_file" "srv_az0_metaDefault" {
  for_each     = toset([ for app_srv in var.application_servers : app_srv.name ]) # List of IPs Addresses and Server IDs
  template     = file("./template_files/server.metadata.tpl")
  vars         = {
    CIDRBLOCK       = var.appservice_AZ0_CIDR
    IPADDRESS       = each.key
    HOSTNAME        = "srv0${each.key}"
    HOSTPUBKEY      = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY   = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
  }
}

# SRV1xx - METADATA
data "template_file" "srv_az1_metaDefault" {
  for_each     = toset([ for app_srv in var.application_servers : app_srv.name ]) # List of IPs Addresses and Server IDs
  template     = file("./template_files/server.metadata.tpl")
  vars         = {
    CIDRBLOCK       = var.appservice_AZ1_CIDR
    IPADDRESS       = each.key
    HOSTNAME        = "srv0${each.key}"
    HOSTPUBKEY      = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY   = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
  }
}

# ANS001 - METADATA
data "template_file" "ans_metaDefault" {
  template     = file("./template_files/ansible.metadata.tpl")
  vars         = {
    HOSTPUBKEY        = data.local_file.host_pubkey.content          # Use this only for simple files
    HOSTNAME          = "ans001"
    IPADDRESS         = var.ansible_address
    VMNETWORKCIDR     = var.VMNetwork_CIDR
    LANCIDR           = var.LAN_CIDR
    WAN1UPLINKCIDR    = var.WAN1_uplink_CIDR
    WAN2UPLINKCIDR    = var.WAN2_uplink_CIDR
    DCWAN1UPLINKCIDR  = var.DCWAN1_uplink_CIDR
    DCWAN2UPLINKCIDR  = var.DCWAN2_uplink_CIDR
    DCUPLINKCIDR      = var.DC_uplink_CIDR
    APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
    APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
  }
}

# UP001 - METADATA
data "template_file" "uptime_metaDefault" {                            # UPTIME service prowered by uptime-kuma
  template     = file("./template_files/uptime.metadata.tpl")
  vars         = {
    HOSTNAME          = "up001"
    HOSTPUBKEY        = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
    IPADDRESS         = var.uptime_address
    VMNETWORKCIDR     = var.VMNetwork_CIDR
    LANCIDR           = var.LAN_CIDR
    WAN1UPLINKCIDR    = var.WAN1_uplink_CIDR
    WAN2UPLINKCIDR    = var.WAN2_uplink_CIDR
    DCWAN1UPLINKCIDR  = var.DCWAN1_uplink_CIDR
    DCWAN2UPLINKCIDR  = var.DCWAN2_uplink_CIDR
    DCUPLINKCIDR      = var.DC_uplink_CIDR
    APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
    APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
  }
}

# LB001 - METADATA
data "template_file" "balancer_metaDefault" {
  template     = file("./template_files/balancer.metadata.tpl")
  vars         = {
    HOSTNAME          = "lb001"
    ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
    IPADDRESS         = var.balancer_address
    DCUPLINKCIDR      = var.DC_uplink_CIDR
    APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
    APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
  }
}

# GUEST001 - METADATA
data "template_file" "guest_metaDefault" {
  template     = file("./template_files/guest.metadata.tpl")
  vars         = {
    HOSTNAME          = "guest001"
    HOSTPUBKEY        = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
  }
}

# [ SERVICES USERDATA ]
# ANS001 - USERDATA
data "template_file" "ans_userDefault" { 
  template     = file("./template_files/ansible.userdata.tpl")
  vars         = {
    ANSIBLEKEY        = base64encode(data.local_file.ansible_id_rsa.content)       # BEST PRACTICE for files to be written in the host
    ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content                 # Use this only for simple files
    NOIPV6            = base64encode(data.local_file.no_IPv6.content)
  }
}

# SRV0xx - SRV1xx - UP001 - LB001 - USERDATA
data "template_file" "noipv6_userDefault" { 
  template     = file("./template_files/noipv6.userdata.tpl")
  vars         = {
    NOIPV6            = base64encode(data.local_file.no_IPv6.content)
  }
}