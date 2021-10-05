#!/bin/bash

function reset_vars(){
  export TF_VAR_esxi_hostname=''
  export TF_VAR_esxi_password=''
  export TF_VAR_apps_CIDR_block=''
  export TF_VAR_linux_client_userpassword=''
  export TF_VAR_linux_server_userpassword=''
  export TF_VAR_host_pubkey_path=''
  return
}

echo "Before start, please validate that you have enabled on host the SSH Filesystem (SSHFS)."
echo "Do you have access to you OVF repository? [y/N]" 
read var_ssh_ok

[[ "$var_ssh_ok" != "y" ]] && { echo "Exiting..." ; return ; }

echo "Please, insert your ESXi Host or IP address: [192.168.27.141]"
read TF_VAR_esxi_hostname
echo "Please, insert your ESXi [root] password:"
read -s TF_VAR_esxi_password
echo "Please, insert your Application Backend CIDR: [172.16.0]"
read TF_VAR_apps_CIDR_block
echo "Please, insert your Linux client host [user] password:"
read -s TF_VAR_linux_client_userpassword
echo "Please, insert your Linux server host [ubuntu] password:"
read -s TF_VAR_linux_server_userpassword
echo "Please, insert your Linux client ssh public key: [/home/user/.ssh/id_rsa.pub]"
read TF_VAR_host_pubkey_path
echo "Please, insert your OVF repository path: [/home/sshfs/OVF]"
read TF_VAR_ovf_path_server

[[ ! -z "$TF_VAR_esxi_hostname" ]] && export TF_VAR_esxi_hostname
[[ ! -z "$TF_VAR_esxi_password" ]] && export TF_VAR_esxi_password || { echo "ERROR: ESXi password CANNOT be blank" ; reset_vars ; }
[[ ! -z "$TF_VAR_apps_CIDR_block" ]] && export TF_VAR_apps_CIDR_block
[[ ! -z "$TF_VAR_linux_client_userpassword" ]] && export TF_VAR_linux_client_userpassword || { echo "ERROR: Linux client password CANNOT be blank" ; reset_vars ; }
[[ ! -z "$TF_VAR_linux_server_userpassword" ]] && export TF_VAR_linux_server_userpassword || { echo "ERROR: Linux server password CANNOT be blank" ; reset_vars ; }
[[ ! -z "$TF_VAR_host_pubkey_path" ]] && export TF_VAR_host_pubkey_path
[[ ! -z "$TF_VAR_ovf_path_server" ]] && export TF_VAR_ovf_path_server