#############################################################
#  Linux VMs variables
#    Do not edit if you are not sure of what are you doing.
#############################################################

variable "linux_username" {            # Ubuntu cloud-images default user is 'ubuntu'
  description = "Linux VM Username"
  type        = string
  default     = "ubuntu"
}
