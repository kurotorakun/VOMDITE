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

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_ansiblehost}"
    
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
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.ansible_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'sudo mv /home/tmp/ssh/* ./.ssh/'
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'sudo chown ubuntu:ubuntu ./.ssh/*id_rsa*'
      ansible-playbook ${var.local_ansible_files_path}/ansible-host-deploy/ansible_playbook.yml -i ${var.VMNetwork_CIDR}.${var.ansible_address}, -u ${var.linux_username}
    EOT
  }
  
  depends_on = [esxi_guest.srv0xx, esxi_guest.srv1xx, esxi_guest.lb001] # srv0xx and srv1xx are an arrays of app server, but are 'dependable'
}
