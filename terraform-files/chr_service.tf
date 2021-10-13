# CHR services deployment

# [ CHR-LAN ]
resource "esxi_guest" "chr-lan" {
  guest_name = "chr-lan"
  disk_store = "DS001"
  guestos    = "other3xlinux64guest"

  boot_disk_type = "thin"
  boot_disk_size = "1"

  memsize            = "128"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_routerservice}"

  # Pending to export config to include as userdata  
  # guestinfo = {
  #   "userdata.encoding" = "base64"
  #   "userdata"          = base64encode(data.template_file.chrlan_userDefault.rendered)
  # }
  
  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces {
    virtual_network = "VM Network"
    nic_type        = "vmxnet3"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["WAN1-Uplink"].name
    nic_type        = "vmxnet3"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["WAN2-Uplink"].name
    nic_type        = "vmxnet3"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["LAN-Network"].name
    nic_type        = "vmxnet3"
  }
  
  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    # TODO: implement configuration write_files and set proper ownership for kuma docker image).
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
    EOT
  }

  # depends_on = [ esxi_guest.srv0xx, esxi_guest.srv1xx ]

}

# [ CHR-DC ]
resource "esxi_guest" "chr-dc" {
  guest_name = "chr-dc"
  disk_store = "DS001"
  guestos    = "other3xlinux64guest"

  boot_disk_type = "thin"
  boot_disk_size = "1"

  memsize            = "128"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_routerservice}"

  # Pending to export config to include as userdata  
  # guestinfo = {
  #   "userdata.encoding" = "base64"
  #   "userdata"          = base64encode(data.template_file.chrlan_userDefault.rendered)
  # }
  
  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces {
    virtual_network = "VM Network"
    nic_type        = "vmxnet3"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DC-WAN1-Uplink"].name
    nic_type        = "vmxnet3"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DC-WAN2-Uplink"].name
    nic_type        = "vmxnet3"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DC-Uplink"].name
    nic_type        = "vmxnet3"
  }
  
  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    # TODO: implement configuration write_files and set proper ownership for kuma docker image).
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
    EOT
  }

  # depends_on = [ esxi_guest.srv0xx, esxi_guest.srv1xx ]

}

# [ CHR-ISP1 ]
resource "esxi_guest" "chr-isp1" {
  guest_name = "chr-isp1"
  disk_store = "DS001"
  guestos    = "other3xlinux64guest"

  boot_disk_type = "thin"
  boot_disk_size = "1"

  memsize            = "128"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_routerservice}"

  # Pending to export config to include as userdata  
  # guestinfo = {
  #   "userdata.encoding" = "base64"
  #   "userdata"          = base64encode(data.template_file.chrlan_userDefault.rendered)
  # }
  
  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces {
    virtual_network = "VM Network"
    nic_type        = "vmxnet3"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["WAN1-Uplink"].name
    nic_type        = "vmxnet3"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DC-WAN1-Uplink"].name
    nic_type        = "vmxnet3"
  }

  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    # TODO: implement configuration write_files and set proper ownership for kuma docker image).
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
    EOT
  }

  # depends_on = [ esxi_guest.srv0xx, esxi_guest.srv1xx ]

}

# [ CHR-ISP2 ]
resource "esxi_guest" "chr-isp2" {
  guest_name = "chr-isp2"
  disk_store = "DS001"
  guestos    = "other3xlinux64guest"

  boot_disk_type = "thin"
  boot_disk_size = "1"

  memsize            = "128"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_routerservice}"

  # Pending to export config to include as userdata  
  # guestinfo = {
  #   "userdata.encoding" = "base64"
  #   "userdata"          = base64encode(data.template_file.chrlan_userDefault.rendered)
  # }
  
  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces {
    virtual_network = "VM Network"
    nic_type        = "vmxnet3"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["WAN2-Uplink"].name
    nic_type        = "vmxnet3"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DC-WAN2-Uplink"].name
    nic_type        = "vmxnet3"
  }

  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    # TODO: implement configuration write_files and set proper ownership for kuma docker image).
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
    EOT
  }

  # depends_on = [ esxi_guest.srv0xx, esxi_guest.srv1xx ]

}
