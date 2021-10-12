# Balancer service host deployment

resource "esxi_guest" "lb001" {
  guest_name = "lb001"
  disk_store = "DS001"
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "20"

  memsize            = "2048"
  numvcpus           = "2"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_balancerhost}"
    
  guestinfo = {
    "metadata.encoding" = "base64"
    "metadata"          = base64encode(data.template_file.balancer_metaDefault.rendered)
  }
  
  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DC-Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["AZ0-Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["AZ1-Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces { ## Created with name ens32 
    virtual_network = "VM Network" 
    nic_type        = "e1000"
  }
  
  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    # TODO: implement configuration write_files and set proper ownership for kuma docker image).
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
    EOT
  }

  depends_on = [esxi_guest.srv0xx, esxi_guest.srv1xx, null_resource.deploy_applications]

}
