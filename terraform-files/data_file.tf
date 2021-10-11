# Data files 

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

# cloud-init meta data file
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

# cloud-init meta data file
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

# cloud-init user data file
data "template_file" "ans_userDefault" { 
  template     = file("./template_files/ansible.userdata.tpl")
  vars         = {
    ANSIBLEKEY        = base64encode(data.local_file.ansible_id_rsa.content)       # BEST PRACTICE for files to be written in the host
    ANSIBLEPUBKEY     = base64encode(data.local_file.ansible_id_rsa_pub.content)   # Use this only for simple files
  }
}

# cloud-init meta data file
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

# cloud-init meta data file
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
