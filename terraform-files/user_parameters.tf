###########################################################################################
# PROJECT:
# Virtualization and Orchestration as a mean to deploy an Infrastructure Test Environment
#   (aka VOMDITE)
#  
# [ USER PARAMETERS ] 
#    Set this parameters according to your environment
#
###########################################################################################

# [ESXi PARAMETERS ]

variable "esxi_hostname" {                   # Set to your ESXi host IP/hostname
  description = "ESXi host address"          #  NOTE: if you need to modify ESXi ports (ssh and/or HTTPS)
  default     = "192.168.27.141"             #        please refer to variables_esxi.tf file  
}

variable "esxi_password" {                   # Password will be prompted if default value is removed.
  description = "ESXi root pass"             #  NOTE: if you wan to access your ESXi using other user
  type        = string                       #        please, refer to variables_esxi.tf file
  default     = "!V0MD1T3"
  sensitive   = true
}

variable "esxi_datastore" {                  # Set your default ESXi datastore, at least one is needed.
  description = "ESXi datastore"             #   NOTE: Please, review documentation for datastore
  type        = string                       #         recommended size 
  default     = "DS001"
}

# [ SSH KEYS PARAMETERS ]

variable "host_pubkey_path" {                # WORKSPACE host Public Key
  description = "Host public key path"       #   Default location set to abc .ssh folder
  type        = string                       #   Mind that these key pair must be created
  default     = "/home/abc/.ssh/id_rsa.pub"  #   first. 
}
