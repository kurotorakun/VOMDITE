# Uptime service host deployment

resource "esxi_guest" "up001" {
  guest_name = "up001"
  disk_store = "DS001"
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "20"

  memsize            = "2048"
  numvcpus           = "2"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_uptimehost}"
    
  guestinfo = {
    "metadata.encoding" = "base64"
    "metadata"          = base64encode(data.template_file.uptime_metaDefault.rendered)
  }
  
  # Current Terraform version only allows iterative structures on resources. network_interface is not allowed.
  network_interfaces { ## Created with name ens32 
    virtual_network = "VM Network" 
    nic_type        = "e1000"
  }

  network_interfaces { ## Created with name ens33
    virtual_network = esxi_portgroup.PGx["LAN-Network"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["WAN1-Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["WAN2-Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DC-WAN1-Uplink"].name
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["DC-WAN2-Uplink"].name
    nic_type        = "e1000"
  }

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
  
  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    # TODO: implement configuration write_files and set proper ownership for kuma docker image).
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' > ./logs/infrastructure_deployment_report.txt
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.uptime_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.uptime_address} 'echo $HOSTNAME is alive'
      ansible-playbook /home/project/VOMDITE/ansible-files/ansible-uptime-deploy/uptime_playbook.yml -i ${var.VMNetwork_CIDR}.${var.uptime_address}, -u ${var.linux_username}
    EOT
  }
  
}
