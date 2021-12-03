#!/bin/bash 

# Workspace name: Virtualization and Orchestration as a Mean to Deploy an Infrastructure Test Environment
# Acronym: VOMDITE

# [ Variables ]
YELLOW='\033[1;33m'
NC='\033[0m'

# .- Generate ssh keys on VOMDITE container ~/.ssh/
printf "${YELLOW}[ $(date -Iseconds) ] [VOMDITE Workspace] Generating workspace SSH key pair... ${NC}\n"
ssh-keygen

# .- Clone VOMDITE repository
printf "${YELLOW}[ $(date -Iseconds) ] [VOMDITE Workspace] Downloading VOMDITE... ${NC}\n"
git clone https://github.com/kurotorakun/VOMDITE.git /home/project/

# .- Generate ssh keys on ./VOMDITE/terraform-files/ssh_keys/
printf "${YELLOW}[ $(date -Iseconds) ] [VOMDITE Workspace] Generating internal Ansible Service SSH key pair... ${NC}\n"
mkdir /home/project/terraform-files/ssh_keys
ssh-keygen -f /home/project/terraform-files/ssh_keys/ansible_id_rsa

# [ TERRAFORM EXECUTION ]
printf "${YELLOW}[ $(date -Iseconds) ] [VOMDITE Workspace] Initialazing Terraform service... ${NC}\n"
terraform -chdir=/home/project/terraform-files init
