#############################################################
#  VMs Procurement vars
#    Do not edit if you are not sure of what are you doing.
#############################################################

# [ OVF ]
variable "ovf_repository_path" {                                     # Images are mapped to workspace 'static-server' service to ease the loading.
  description = "OVF Images repository"
  type        = string
  default     = "http://localhost:8022/OVF/"                         # LOCAL REPOSITORY (see documentation ____)
  # default     = "https://cloud-images.ubuntu.com/focal/current/"   # REMOTE REPOSITORY
}

variable "ovf_path_appservice" {                                     # Application Service OVF
  description = "App Service OVF Image"
  type        = string
  default     = "focal-server-cloudimg-amd64.ova" 
}

variable "ovf_path_ansiblehost" {                                    # Ansible Service OVF
  description = "Ansible Service OVF Image"
  type        = string
  default     = "focal-server-cloudimg-amd64.ova" 
}

variable "ovf_path_uptimehost" {                                     # Ansible Service OVF
  description = "Uptime Service OVF Image"
  type        = string
  default     = "focal-server-cloudimg-amd64.ova" 
}

# [ ANSIBLE ]
variable "local_ansible_files_path" {
  description = "Local Ansible Path"
  type        = string
  default     = "/home/project/VOMDITE/ansible-files" 
}

variable "ansibleservice_ansible_files_path" {
  description = "Local Ansible Path"
  type        = string
  default     = "/home/ubuntu/ansible-playbooks" 
}