#############################################################
#  VMs Procurement vars
#    Do not edit if you are not sure of what are you doing.
#############################################################

# [ OVF REPOSITORY ]
variable "ovf_repository_path" {                                     # Images are mapped to workspace 'static-server' service to ease the loading.
  description = "OVF Images repository"
  type        = string
  default     = "http://localhost:8022/OVF/"                         # LOCAL REPOSITORY (see documentation ____)
  # default     = "https://cloud-images.ubuntu.com/focal/current/"   # REMOTE REPOSITORY
}

# [ OVF IMAGES ]
# variable "ovf_path_routerservice" {                                # Router Service OVF
#   description = "CHR - Routing Service OVF Image"
#   type        = string
#   default     = "CHR/chr-6.48.5.ova" 
# }

variable "ovf_path_chr_dc_service" {                                 # Router Service OVF
  description = "CHR-DC - Routing Service OVF Image"
  type        = string
  default     = "CHR/chr-dc/chr-dc.ovf" 
}

variable "ovf_path_chr_lan_service" {                                # Router Service OVF
  description = "CHR-LAN - Routing Service OVF Image"
  type        = string
  default     = "CHR/chr-lan/chr-lan.ovf" 
}

variable "ovf_path_chr_isp1_service" {                               # Router Service OVF
  description = "CHR-ISP1 - Routing Service OVF Image"
  type        = string
  default     = "CHR/chr-isp1/chr-isp1.ovf" 
}

variable "ovf_path_chr_isp2_service" {                               # Router Service OVF
  description = "CHR-ISP2 - Routing Service OVF Image"
  type        = string
  default     = "CHR/chr-isp2/chr-isp2.ovf" 
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

variable "ovf_path_monitoringhost" {                                 # Ansible Service OVF
  description = "Uptime Service OVF Image"
  type        = string
  default     = "focal-server-cloudimg-amd64.ova" 
}

variable "ovf_path_balancerhost" {                                   # Ansible Service OVF
  description = "Load Balancer Service OVF Image"
  type        = string
  default     = "focal-server-cloudimg-amd64.ova" 
}

variable "ovf_path_guesthost" {                                      # Ansible Service OVF
  description = "Guest client OVF Image"
  type        = string
  default     = "xubuntu-cloudimg/xubuntu2004.ovf" 
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