#############################################################
#  Linux VMs vars
#    Do not edit if you are not sure of what are you doing.
#############################################################

variable "linux_username" {            # Ubuntu cloud-images default user is 'ubuntu'
  description = "Linux VM Username"
  type        = string
  default     = "ubuntu"
}

variable "linux_userpassword" {        # Password will be prompted, if it's not set other way (see TF_VAR_*)
  description = "Linux VM password"
  type        = string
  sensitive   = true
}