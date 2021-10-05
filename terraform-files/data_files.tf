# Data files

# DELETE ME!
# IP Addresses
data "local_file" "ip_list" {
    filename = "./test_file.txt"
}

# Terraform host public key
data "local_file" "host_pubkey" {
    filename = var.host_pubkey_path
}

# cloud-init user data file
data "template_file" "userDefault" { 
  template = file("userdata.tpl")
  vars = {
    FILE       = base64encode(data.local_file.ip_list.content)  # Best practice for file export
    PUBKEY     = data.local_file.host_pubkey.content            # Use this only for simple files
  }
}

# cloud-init meta data file
data "template_file" "srv_metaDefault" {
  for_each = toset([ for app_srv in var.application_servers : app_srv.name ]) # List of IPs Addresses and Server IDs
  template = file("metadata.tpl")
  vars = {
    APPS_CIDR_BLOCK = var.apps_CIDR_block
    IP_ADDRESS = each.key
    HOSTNAME   = "srv0${each.key}"
  }
}