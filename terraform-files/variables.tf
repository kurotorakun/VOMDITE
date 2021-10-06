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
#  Networking vars
#########################################
variable "network_list" {
  description = "List of object that contains the network names. Used on vSwitch and PortGroups"
  # Created as a list of object due that for_each cannot access primitive types (i.e string)
  type        = list(object({ 
                  name = string
                }))
  default     = [ # Adding more object will increase the amount of networks created
                  { name = "LANUplink" },      # LAN-Uplink     - client-officerouter uplink 
                  { name = "LANWAN1Uplink" },  # WAN1-Uplink    - officerouter-internet uplink - primary
                  { name = "LANWAN2Uplink" },  # WAN2-Uplink    - officerouter-internet uplink - secondary
                  { name = "DCWAN1Uplink" },   # DC-WAN1-Uplink - DCrouter-internet uplink - primary
                  { name = "DCWAN2Uplink" },   # DC-WAN2-Uplink - DCrouter-internet uplink - secondary
                  { name = "DCUplink" },       # DC-Uplink      - LoadBalancer-DCrouter uplink
                  { name = "FER1Uplink" },     # FER1-Uplink    - FrontEnd Region 1 Uplink
                  { name = "FER2Uplink" }      # FER2-Uplink    - FrontEnd Region 2 Uplink
                ]
}

#########################################
#  VMs Procurement vars
#########################################
variable "ovf_repository_path" {
  description = "Path that contains Server OVF Image"
  type        = string
  default     = "http://localhost:8022/OVF/" # Images are mapped to workspace 'static-server' service to ease the loading.
}

variable "ovf_path_server" {
  description = "Path that contains Server OVF Image"
  type        = string
  default     = "ubuntu-cloudimg/ubuntu-cloudimg.ovf" # To be used on TFG workspace
}

variable "ovf_path_ansiblehost" {
  description = "Path that contains Ansible service OVF Image"
  type        = string
  default     = "ubuntu-cloudimg/ubuntu-cloudimg.ovf" # To be used on TFG workspace
  # default     = "xubuntu-cloudimg/xubuntu2004.ovf" # initially deployed as xubuntu (with GUI)
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

# variable "linux_client_username" {
#   description = "Linux client host username"
#   type        = string
#   default     = "user"
# }
# 
# variable "linux_client_userpassword" { # Unspecified will prompt
#   description = "Linux pass"
#   type        = string
#   sensitive   = true
# }

variable "linux_username" {
  description = "Linux server host username"
  type        = string
  default     = "ubuntu"
}

variable "linux_userpassword" { # Unspecified will prompt
  description = "Linux pass"
  type        = string
  sensitive   = true
}

variable "host_pubkey_path" { # Unspecified will prompt
  description = "Host public key. Used to authenticate without password"
  type        = string
  default     = "/home/abc/.ssh/id_rsa.pub" # workspace user is 'abc'
}
