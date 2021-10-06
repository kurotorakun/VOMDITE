# Ansible host deployment

resource "esxi_guest" "ans001" {
  guest_name = "ans001"
  disk_store = "DS001"
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "20"

  memsize            = "2048"
  numvcpus           = "2"
  resource_pool_name = "/"
  power              = "on"

  # ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_ansiblehost}"
  ovf_source         = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova"
  
  guestinfo = {
    "userdata.encoding" = "base64"
    "userdata"          = base64encode(data.template_file.ans_userDefault.rendered)
    "metadata.encoding" = "base64"
    "metadata"          = base64encode(data.template_file.ans_metaDefault.rendered)
  }
  
  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces { ## Created with name ens32 
    virtual_network = "VM Network" 
    nic_type        = "e1000"
  }

  network_interfaces { ## Created with name ens33
    virtual_network = esxi_portgroup.PGx["LANUplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["LANWAN1Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["LANWAN2Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DCWAN1Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DCWAN2Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DCUplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["FER1Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["FER2Uplink"].name
    nic_type        = "e1000"
  }
  
  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    command = "echo '${self.guest_name}: ${self.ip_address}' >> infrastructure_deployment_report.txt"
  }
  
  # depends_on = [esxi_guest.template_ubuntu2004, esxi_guest.chr001]
}
