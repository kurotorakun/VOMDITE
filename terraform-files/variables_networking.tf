#############################################################
#  Networking vars
#    Do not edit if you are not sure of what are you doing.
#############################################################

# [ NETWORK LIST]
variable "network_list" {
  description = "List of object that contains the network names. Used on vSwitch and PortGroups"
  type        = list(object({ 
                  name = string
                }))
  default     = [                               # Adding more objects will increase amount of networks.
                  { name = "LAN-Network" },     # LAN-Network    - client-officerouter uplink 
                  { name = "WAN1-Uplink" },     # WAN1-Uplink    - officerouter-internet uplink - primary
                  { name = "WAN2-Uplink" },     # WAN2-Uplink    - officerouter-internet uplink - secondary
                  { name = "DC-WAN1-Uplink" },  # DC-WAN1-Uplink - DCrouter-internet uplink - primary
                  { name = "DC-WAN2-Uplink" },  # DC-WAN2-Uplink - DCrouter-internet uplink - secondary
                  { name = "DC-Uplink" },       # DC-Uplink      - LoadBalancer-DCrouter uplink
                  { name = "AZ0-Uplink" },      # AZ0-Uplink     - FrontEnd Region 0 Uplink
                  { name = "AZ1-Uplink" }       # AZ1-Uplink     - FrontEnd Region 1 Uplink
                ]
}

# [ NETWORKING ADDRESSING ]
variable "VMNetwork_CIDR" {       # Set this CIDR to the network of your VM Ware workstation 'NAT' network
  description = "VM Network CIDR"
  type        = string
  default     = "192.168.27"
  sensitive   = true
}

variable "appservice_AZ0_CIDR" {
  description = "Service Apps Network Segment (AZ0)"
  type        = string
  default     = "172.16.0" 
  sensitive   = true
}

variable "appservice_AZ1_CIDR" {
  description = "Service Apps Network Segment (AZ1)"
  type        = string
  default     = "172.16.1"
  sensitive   = true
}

# [ HOST ADDRESSING ]
variable "ansible_address" {
  description = "Ansible Host Address"
  type        = string
  default     = "250"
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