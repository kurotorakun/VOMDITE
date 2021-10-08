#############################################################
#  Connectivity vars
#    Do not edit if you are not sure of what are you doing.
#############################################################

variable "host_pubkey_path" {               # Provision 'abc' profile valid keys
  description = "Host public key path"
  type        = string
  default     = "/home/abc/.ssh/id_rsa.pub"
}