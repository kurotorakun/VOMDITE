#############################################################
#  ESXI Connection vars
#    Do not edit if you are not sure of what are you doing.
#############################################################

variable "esxi_hostport" {        # ESXi ssh service is default configure to 22/TCP
  default     = "22"
}

variable "esxi_hostssl" {         # ESXi webgui is default configure to 22/TCP
  default     = "443"
}

variable "esxi_username" {        # ESXi default user is 'root'
  description = "ESXi username"
  type        = string
  default     = "root"
}
