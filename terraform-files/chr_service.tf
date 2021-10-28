# CHR services deployment

# [ CHR-ISP1 ]
resource "esxi_guest" "chr-isp1" {
  guest_name = var.chrisp1_hostname
  disk_store = var.esxi_datastore
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "1"

  memsize            = "128"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_chr_isp1_service}"
  
  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces {
    virtual_network = var.esxi_default_network
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

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["Internet-Network"].name
    nic_type        = "vmxnet3"
  }

  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
    EOT
  }

  depends_on = [ esxi_guest.up001, null_resource.deploy_uptime ]

}

# [ CHR-ISP2 ]
resource "esxi_guest" "chr-isp2" {
  guest_name = var.chrisp2_hostname
  disk_store = var.esxi_datastore
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "1"

  memsize            = "128"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_chr_isp2_service}"

  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces {
    virtual_network = var.esxi_default_network
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

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["Internet-Network"].name
    nic_type        = "vmxnet3"
  }

  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
    EOT
  }

  depends_on = [ esxi_guest.up001, null_resource.deploy_uptime ]

}

# [ CHR-LAN ]
resource "esxi_guest" "chr-lan" {
  guest_name = var.chrlan_hostname
  disk_store = var.esxi_datastore
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "1"

  memsize            = "128"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_chr_lan_service}"

  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces {
    virtual_network = var.esxi_default_network
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
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
    EOT
  }

  depends_on = [ esxi_guest.up001, null_resource.deploy_uptime, esxi_guest.chr-isp1, esxi_guest.chr-isp2 ]

}

# [ CHR-DC ]
resource "esxi_guest" "chr-dc" {
  guest_name = var.chrdc_hostname
  disk_store = var.esxi_datastore
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "1"

  memsize            = "128"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_chr_dc_service}"

  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces {
    virtual_network = var.esxi_default_network
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
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
    EOT
  }

  depends_on = [ esxi_guest.up001, null_resource.deploy_uptime, esxi_guest.chr-isp1, esxi_guest.chr-isp2 ]

}
