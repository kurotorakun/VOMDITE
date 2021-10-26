# Data files 

### [ SSH KEYS ]

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

### [ CONFIGURATION FILES ]

# file 10-disable-ipv6.conf to disable IPv6 on hosts.
#   must be included using write_files of cloud-init userdata
data "local_file" "no_IPv6" {
    filename   = "./template_files/disable-ipv6.conf"
}

### [ ANSIBLE PLAYBOOKS AND VARS]

# 1.- Ansible Application(s) service deployment.
data "local_file" "application_playbook_yml" {
    filename   = "../ansible-files/ansible-application-deploy/application_playbook.yml"
}

data "local_file" "application_vars_yml" {
    filename   = "../ansible-files/ansible-application-deploy/application_vars.yml"
}

# 2.- Ansible Balancer service deployment
data "local_file" "balancer_playbook_yml" {
    filename   = "../ansible-files/ansible-balancer-deploy/balancer_playbook.yml"
}

### [ SERVICE FILES - BACKUP]
# Does not work.
# data "local_file" "kuma_db" { 
#     filename   = "../ansible-files/ansible-uptime-deploy/kuma.db"
# }
