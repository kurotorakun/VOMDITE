# Guest client host deployment 

resource "esxi_guest" "guest001" {
  guest_name = "guest001"
  disk_store = "DS001"
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "20"

  memsize            = "1024"
  numvcpus           = "1"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_guesthost}"
    
  guestinfo = {
    "userdata.encoding" = "base64"
    "userdata"          = base64encode(data.template_file.noipv6_userDefault.rendered)
    "metadata.encoding" = "base64"
    "metadata"          = base64encode(data.template_file.guest_metaDefault.rendered)
  }
  
  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces { ## Created with name ens32 
    virtual_network = esxi_portgroup.PGx["LAN-Network"].name
    nic_type        = "e1000"
  }
  
  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
    EOT
  }

  depends_on = [ esxi_guest.chr-lan ]

}
