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

# 2.- Ansible Balancer service deployment and update
data "local_file" "balancer_deploy_playbook_yml" {
    filename   = "../ansible-files/ansible-balancer-deploy/balancer_deploy_playbook.yml"
}

data "local_file" "balancer_update_playbook_yml" {
    filename   = "../ansible-files/ansible-balancer-update/balancer_update_playbook.yml"
}

# 3.- Ansible Mikrotik CHR service "upgrade" deployment
data "local_file" "chr_vars_yml"{
    filename   = "../ansible-files/ansible-chr-deployment/chr_vars.yml"
}

data "local_file" "chr_lan_FWL7_deployment_yml"{
    filename   = "../ansible-files/ansible-chr-deployment/chr-lan_FWL7_deployment.yml"
}

data "local_file" "chr_lan_disable_FWL7_yml"{
    filename   = "../ansible-files/ansible-chr-deployment/chr-lan_disable_FWL7.yml"
}

data "local_file" "chr_lan_enable_FWL7_yml"{
    filename   = "../ansible-files/ansible-chr-deployment/chr-lan_enable_FWL7.yml"
}
