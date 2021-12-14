#!/bin/bash 

# Workspace name: Virtualization and Orchestration as a Mean to Deploy an Infrastructure Test Environment
# Acronym: VOMDITE

# [ Variables ]
YELLOW='\033[1;33m'
NC='\033[0m'

# ~ DEBUG ~
# printf "${YELLOW}[ $(date -Iseconds) ] [VOMDITE Workspace] Planning Terraform process... ${NC}\n"
# terraform -chdir=/home/project/terraform-files plan

printf "${YELLOW}[ $(date -Iseconds) ] [VOMDITE Workspace] Starting terraforming... ${NC}\n"
terraform -chdir=/home/project/terraform-files apply

printf "${YELLOW}[ $(date -Iseconds) ] [VOMDITE Workspace] Terraforming process completed. Review any error output. ${NC}\n"
printf "                              Access workspace through http://localhost:8025/ to review any error.\n"