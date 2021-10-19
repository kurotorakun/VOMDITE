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
  default     = [                                 # Adding more objects will increase amount of networks.
                  { name = "LAN-Network" },       # LAN-Network      - client-officerouter uplink 
                  { name = "WAN1-Uplink" },       # WAN1-Uplink      - officerouter-internet uplink - primary
                  { name = "WAN2-Uplink" },       # WAN2-Uplink      - officerouter-internet uplink - secondary
                  { name = "DC-WAN1-Uplink" },    # DC-WAN1-Uplink   - DCrouter-internet uplink - primary
                  { name = "DC-WAN2-Uplink" },    # DC-WAN2-Uplink   - DCrouter-internet uplink - secondary
                  { name = "Internet-Network" },  # Internet-Network - Link between ISP CHR
                  { name = "DC-Uplink" },         # DC-Uplink        - LoadBalancer-DCrouter uplink
                  { name = "AZ0-Uplink" },        # AZ0-Uplink       - FrontEnd Region 0 Uplink
                  { name = "AZ1-Uplink" }         # AZ1-Uplink       - FrontEnd Region 1 Uplink
                ]
}

# [ NETWORKING ADDRESSING ]
variable "VMNetwork_CIDR" {       # Set this CIDR to the network of your VM Ware workstation 'NAT' network
  description = "VM Network CIDR"
  type        = string
  default     = "192.168.27"
}

variable "LAN_CIDR" {
  description = "LAN Network Segment"
  type        = string
  default     = "192.168.100" 
}

variable "WAN1_uplink_CIDR" {
  description = "WAN1 Uplink Network Segment (AZ0)"
  type        = string
  default     = "10.0.1" 
}

variable "WAN2_uplink_CIDR" {
  description = "WAN1 Uplink Network Segment (AZ0)"
  type        = string
  default     = "10.0.2" 
}

variable "DCWAN1_uplink_CIDR" {
  description = "DC-WAN1 Uplink Network Segment (AZ0)"
  type        = string
  default     = "10.1.1" 
}

variable "DCWAN2_uplink_CIDR" {
  description = "DC-WAN2 Uplink Network Segment (AZ0)"
  type        = string
  default     = "10.1.2" 
}

variable "DC_uplink_CIDR" {
  description = "Service Apps Network Segment (AZ0)"
  type        = string
  default     = "172.31.0" 
}

variable "appservice_AZ0_CIDR" {
  description = "Service Apps Network Segment (AZ0)"
  type        = string
  default     = "172.16.0" 
}

variable "appservice_AZ1_CIDR" {
  description = "Service Apps Network Segment (AZ1)"
  type        = string
  default     = "172.16.1"
}

# [ HOST ADDRESSING ]
variable "balancer_address" {
  description = "Load Balancer Host Address"
  type        = string
  default     = "10"
}

variable "uptime_address" {
  description = "Uptime Monitoring Host Address"
  type        = string
  default     = "249"
}

variable "ansible_address" {
  description = "Ansible Host Address"
  type        = string
  default     = "250"
}

variable "monitoring_address" {
  description = "Ansible Host Address"
  type        = string
  default     = "251"
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