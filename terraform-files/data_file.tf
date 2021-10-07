# Data files 

# Ansible service private key
data "local_file" "ansible_id_rsa" {
    filename   = "./ansible_id_rsa"
}

# Ansible service public key
data "local_file" "ansible_id_rsa_pub" {
    filename   = "./ansible_id_rsa.pub"
}

# Terraform host public key
data "local_file" "host_pubkey" {
    filename   = var.host_pubkey_path
}

# cloud-init user data file
data "template_file" "srv_userDefault" { 
  template     = file("server.userdata.tpl")
  vars         = {
    HOSTPUBKEY      = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY   = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
  }
}

# cloud-init meta data file
data "template_file" "srv_metaDefault" {
  for_each     = toset([ for app_srv in var.application_servers : app_srv.name ]) # List of IPs Addresses and Server IDs
  template     = file("server.metadata.tpl")
  vars         = {
    APPS_CIDR_BLOCK = var.apps_CIDR_block
    IP_ADDRESS      = each.key
    HOSTNAME        = "srv0${each.key}"
    HOSTPUBKEY      = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY   = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
  }
}

# cloud-init user data file
data "template_file" "ans_userDefault" { 
  template     = file("ansible.userdata.tpl")
  vars         = {
    ANSIBLEKEY      = base64encode(data.local_file.ansible_id_rsa.content)       # BEST PRACTICE for files to be written in the host
    ANSIBLEPUBKEY   = base64encode(data.local_file.ansible_id_rsa_pub.content)   # Use this only for simple files
  }
}

# cloud-init meta data file
data "template_file" "ans_metaDefault" {
  template     = file("ansible.metadata.tpl")
  vars         = {
    HOSTPUBKEY       = data.local_file.host_pubkey.content                    # Use this only for simple files
    HOSTNAME         = "ans001"
  }
}
