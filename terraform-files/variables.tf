
#########################################
#  ESXI Connection vars
#########################################
variable "esxi_hostname" {
  default     = "192.168.27.141" # esxi IP/hostname
  sensitive   = true
}

variable "esxi_hostport" {
  default     = "22"
}

variable "esxi_hostssl" {
  default     = "443"
}

variable "esxi_username" {
  description = "ESXi username"
  type        = string
  default     = "root"
}

variable "esxi_password" { # set this by environment var with 'export TF_VAR_esxi_password='abc1223' '
  description = "ESXi pass"
  type        = string
  sensitive   = true
}

#########################################
#  VMs Procurement vars
#########################################
variable "ovf_repository_path" {
  description = "Path that contains Server OVF Image"
  type        = string
  default     = "/home/sshfs/OVF" # To be used on TFG workspace
}
variable "ovf_path_server" {
  description = "Path that contains Server OVF Image"
  type        = string
  default     = "ubuntu-cloudimg/ubuntu-cloudimg.ovf" # To be used on TFG workspace
}

#########################################
#  App VMs Procurement vars
#########################################
variable "apps_CIDR_block" {
  description = "Service Apps Network Segment"
  type        = string
  default     = "172.16.0" # Set this to the initial application network segment. Example: 192.168.27[.xxx/24]
  sensitive   = true
}

variable "application_servers" {
  description = "Application server IDs and IP Address"
  # Created as a list of object due that for_each cannot access primitive types (i.e string)
  type        = list(object({ 
                  name = string
                }))
  default     = [ # Adding more object will increase the amount of application servers created
                  { name = "20" },
                  { name = "21" }
                ]
}

#########################################
#  Linux VMs vars
#########################################

variable "linux_client_username" {
  description = "Linux client host username"
  type        = string
  default     = "user"
}

variable "linux_client_userpassword" { # Unspecified will prompt
  description = "Linux pass"
  type        = string
  sensitive   = true
}

variable "linux_server_username" {
  description = "Linux server host username"
  type        = string
  default     = "ubuntu"
}

variable "linux_server_userpassword" { # Unspecified will prompt
  description = "Linux pass"
  type        = string
  sensitive   = true
}

variable "host_pubkey_path" { # Unspecified will prompt
  description = "Host public key. Used to authenticate without password"
  type        = string
  default     = "/home/user/.ssh/id_rsa.pub"
}
