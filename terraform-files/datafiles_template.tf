# Dynamic (tempalte) Datafiles 

locals {
  ### [ CONFIGURATION FILES ]

  application_inventory_yml = templatefile("../ansible-files/ansible-application-deploy/application_inventory.tpl",{
    APPSERVERS        = var.application_servers
    APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
    APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
    LINUXUSER         = var.linux_username

  })
  
  balancer_nginx_conf = templatefile("../ansible-files/ansible-balancer-deploy/nginx.tpl",{
    APPSERVERS        = var.application_servers
    APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
    APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
  })

  prometheus_yml_config = templatefile("../ansible-files/ansible-monitoring-deploy/prometheus.yml.tpl", {
    APPSERVERS        = var.application_servers
    VMNETWORKCIDR     = var.VMNetwork_CIDR
    WAN1UPLINKCIDR    = var.WAN1_uplink_CIDR
    DCUPLINKCIDR      = var.DC_uplink_CIDR
    APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
    APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
    MONADDRESS        = var.monitoring_address
    BALADDRESS        = var.balancer_address
    ANSADDRESS        = var.ansible_address
    UPADDRESS         = var.uptime_address
  })

  ### [ SERVICES METADATA ]

  # ANS001 - METADATA
  ansible_metaDefault = templatefile("./template_files/ansible.metadata.tpl", {
    HOSTPUBKEY        = data.local_file.host_pubkey.content          # Use this only for simple files
    HOSTNAME          = "ans001"
    IPADDRESS         = var.ansible_address
    VMNETWORKCIDR     = var.VMNetwork_CIDR
    LANCIDR           = var.LAN_CIDR
    WAN1UPLINKCIDR    = var.WAN1_uplink_CIDR
    WAN2UPLINKCIDR    = var.WAN2_uplink_CIDR
    DCWAN1UPLINKCIDR  = var.DCWAN1_uplink_CIDR
    DCWAN2UPLINKCIDR  = var.DCWAN2_uplink_CIDR
    DCUPLINKCIDR      = var.DC_uplink_CIDR
    APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
    APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
  })

  # UP001 - METADATA - service prowered by uptime-kuma
  uptime_metaDefault = templatefile("./template_files/uptime.metadata.tpl",{
    HOSTNAME          = "up001"
    HOSTPUBKEY        = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
    IPADDRESS         = var.uptime_address
    VMNETWORKCIDR     = var.VMNetwork_CIDR
    LANCIDR           = var.LAN_CIDR
    WAN1UPLINKCIDR    = var.WAN1_uplink_CIDR
    WAN2UPLINKCIDR    = var.WAN2_uplink_CIDR
    DCWAN1UPLINKCIDR  = var.DCWAN1_uplink_CIDR
    DCWAN2UPLINKCIDR  = var.DCWAN2_uplink_CIDR
    DCUPLINKCIDR      = var.DC_uplink_CIDR
    APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
    APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
  })

  # LB001 - METADATA
  balancer_metaDefault = templatefile("./template_files/balancer.metadata.tpl",{
    HOSTNAME          = "lb001"
    ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
    IPADDRESS         = var.balancer_address
    DCUPLINKCIDR      = var.DC_uplink_CIDR
    APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
    APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
  })

  # MON001 - METADATA
  monitoring_metaDefault = templatefile("./template_files/monitoring.metadata.tpl", {
    HOSTNAME          = "mon001"
    HOSTPUBKEY        = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
    IPADDRESS         = var.monitoring_address
    VMNETWORKCIDR     = var.VMNetwork_CIDR
    LANCIDR           = var.LAN_CIDR
    WAN1UPLINKCIDR    = var.WAN1_uplink_CIDR
    WAN2UPLINKCIDR    = var.WAN2_uplink_CIDR
    DCWAN1UPLINKCIDR  = var.DCWAN1_uplink_CIDR
    DCWAN2UPLINKCIDR  = var.DCWAN2_uplink_CIDR
    DCUPLINKCIDR      = var.DC_uplink_CIDR
    APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
    APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
  })

  # GUEST001 - METADATA
  guest_metaDefault = templatefile("./template_files/guest.metadata.tpl",{
    HOSTNAME          = "guest001"
    HOSTPUBKEY        = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
  })

  ### [ SERVICES USERDATA ]

  # ANS001 - USERDATA
  ansible_userDefault = templatefile("./template_files/ansible.userdata.tpl",{
    ANSIBLEKEY        = base64encode(data.local_file.ansible_id_rsa.content)       # BEST PRACTICE for files to be written in the host
    ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content                 # Use this only for simple files
    NOIPV6            = base64encode(data.local_file.no_IPv6.content)
    BALANCERPB        = base64encode(data.local_file.balancer_playbook_yml.content)
    APPPB             = base64encode(data.local_file.application_playbook_yml.content)
    APPVARS           = base64encode(data.local_file.application_vars_yml.content)
    APPINVENTORY      = base64encode(local.application_inventory_yml)
  })

  # MON001 - USERDATA
  monitoring_userDefault = templatefile("./template_files/monitoring.userdata.tpl",{
    PROMETHEUSYML     = base64encode(local.prometheus_yml_config)
  })
  
  # UP001 - USERDATA
  uptime_userDefault = templatefile("./template_files/uptime.userdata.tpl",{
    # KUMADB            = base64encode(data.local_file.kuma_db.content)
    KUMADB            = filebase64("../ansible-files/ansible-uptime-deploy/kuma.db")
  })
  
  # LB001 - USERDATA
  balancer_userDefault = templatefile("./template_files/balancer.userdata.tpl",{
    NGINXCONF         = base64encode(local.balancer_nginx_conf)
  })

  # SRV0xx - SRV1xx - USERDATA
  noipv6_userDefault = templatefile("./template_files/noipv6.userdata.tpl",{
    NOIPV6            = base64encode(data.local_file.no_IPv6.content)
  })

}


### [ SERVICES METADATA ]

# SRV0xx - METADATA
data "template_file" "srv_az0_metaDefault" {
  for_each     = toset([ for app_srv in var.application_servers : app_srv.name ]) # List of IPs Addresses and Server IDs
  template     = file("./template_files/server.metadata.tpl")
  vars         = {
    CIDRBLOCK       = var.appservice_AZ0_CIDR
    IPADDRESS       = each.key
    HOSTNAME        = "srv0${each.key}"
    HOSTPUBKEY      = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY   = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
  }
}

# SRV1xx - METADATA
data "template_file" "srv_az1_metaDefault" {
  for_each     = toset([ for app_srv in var.application_servers : app_srv.name ]) # List of IPs Addresses and Server IDs
  template     = file("./template_files/server.metadata.tpl")
  vars         = {
    CIDRBLOCK       = var.appservice_AZ1_CIDR
    IPADDRESS       = each.key
    HOSTNAME        = "srv0${each.key}"
    HOSTPUBKEY      = data.local_file.host_pubkey.content            # Use this only for simple files
    ANSIBLEPUBKEY   = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
  }
}

# ANS001 - METADATA
# data "template_file" "ans_metaDefault" {
#   template     = file("./template_files/ansible.metadata.tpl")
#   vars         = {
#     HOSTPUBKEY        = data.local_file.host_pubkey.content          # Use this only for simple files
#     HOSTNAME          = "ans001"
#     IPADDRESS         = var.ansible_address
#     VMNETWORKCIDR     = var.VMNetwork_CIDR
#     LANCIDR           = var.LAN_CIDR
#     WAN1UPLINKCIDR    = var.WAN1_uplink_CIDR
#     WAN2UPLINKCIDR    = var.WAN2_uplink_CIDR
#     DCWAN1UPLINKCIDR  = var.DCWAN1_uplink_CIDR
#     DCWAN2UPLINKCIDR  = var.DCWAN2_uplink_CIDR
#     DCUPLINKCIDR      = var.DC_uplink_CIDR
#     APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
#     APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
#   }
# }

# UP001 - METADATA
# data "template_file" "uptime_metaDefault" {                            # UPTIME service prowered by uptime-kuma
#   template     = file("./template_files/uptime.metadata.tpl")
#   vars         = {
#     HOSTNAME          = "up001"
#     HOSTPUBKEY        = data.local_file.host_pubkey.content            # Use this only for simple files
#     ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
#     IPADDRESS         = var.uptime_address
#     VMNETWORKCIDR     = var.VMNetwork_CIDR
#     LANCIDR           = var.LAN_CIDR
#     WAN1UPLINKCIDR    = var.WAN1_uplink_CIDR
#     WAN2UPLINKCIDR    = var.WAN2_uplink_CIDR
#     DCWAN1UPLINKCIDR  = var.DCWAN1_uplink_CIDR
#     DCWAN2UPLINKCIDR  = var.DCWAN2_uplink_CIDR
#     DCUPLINKCIDR      = var.DC_uplink_CIDR
#     APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
#     APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
#   }
# }

# LB001 - METADATA
# data "template_file" "balancer_metaDefault" {
#   template     = file("./template_files/balancer.metadata.tpl")
#   vars         = {
#     HOSTNAME          = "lb001"
#     ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
#     IPADDRESS         = var.balancer_address
#     DCUPLINKCIDR      = var.DC_uplink_CIDR
#     APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
#     APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
#   }
# }

# MON001 - METADATA
# data "template_file" "monitoring_metaDefault" {
#   template     = file("./template_files/monitoring.metadata.tpl")
#   vars         = {
#     HOSTNAME          = "mon001"
#     HOSTPUBKEY        = data.local_file.host_pubkey.content            # Use this only for simple files
#     ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
#     IPADDRESS         = var.monitoring_address
#     VMNETWORKCIDR     = var.VMNetwork_CIDR
#     LANCIDR           = var.LAN_CIDR
#     WAN1UPLINKCIDR    = var.WAN1_uplink_CIDR
#     WAN2UPLINKCIDR    = var.WAN2_uplink_CIDR
#     DCWAN1UPLINKCIDR  = var.DCWAN1_uplink_CIDR
#     DCWAN2UPLINKCIDR  = var.DCWAN2_uplink_CIDR
#     DCUPLINKCIDR      = var.DC_uplink_CIDR
#     APPSERVICEAZ0CIDR = var.appservice_AZ0_CIDR
#     APPSERVICEAZ1CIDR = var.appservice_AZ1_CIDR
#   }
# }

# GUEST001 - METADATA
# data "template_file" "guest_metaDefault" {
#   template     = file("./template_files/guest.metadata.tpl")
#   vars         = {
#     HOSTNAME          = "guest001"
#     HOSTPUBKEY        = data.local_file.host_pubkey.content            # Use this only for simple files
#     ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content     # Use this only for simple files
#   }
# }

### [ SERVICES USERDATA ]

# ANS001 - USERDATA
# data "template_file" "ans_userDefault" { 
#   template     = file("./template_files/ansible.userdata.tpl")
#   vars         = {
#     ANSIBLEKEY        = base64encode(data.local_file.ansible_id_rsa.content)       # BEST PRACTICE for files to be written in the host
#     ANSIBLEPUBKEY     = data.local_file.ansible_id_rsa_pub.content                 # Use this only for simple files
#     NOIPV6            = base64encode(data.local_file.no_IPv6.content)
#   }
# }

# data "template_file" "mon_userDefault" { 
#   template     = file("./template_files/monitoring.userdata.tpl")
#   vars         = {
#     PROMETHEUSYML     = base64encode(local.prometheus_yml_config)
#   }
# }

# SRV0xx - SRV1xx - UP001 - LB001 - MON001 - USERDATA
# data "template_file" "noipv6_userDefault" { 
#   template     = file("./template_files/noipv6.userdata.tpl")
#   vars         = {
#     NOIPV6            = base64encode(data.local_file.no_IPv6.content)
#   }
# }