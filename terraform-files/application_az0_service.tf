# Servers deployment

resource "esxi_guest" "srv0xx" {
  for_each = toset([ for app_srv in var.application_servers : app_srv.name ]) # List of IPs Addresses and Server IDs
  guest_name = "srv0${each.key}"
  disk_store = "DS001"
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "20"

  memsize            = "2048"
  numvcpus           = "2"
  resource_pool_name = "/"
  power              = "on"

  # clone_from_vm = "template_ubuntu2004" # Use it if your are clonning an existing VM
  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_appservice}"
  
  guestinfo = {
    # "userdata.encoding" = "base64"
    # "userdata"          = base64encode(data.template_file.ans_userDefault.rendered)
    "metadata.encoding" = "base64"
    "metadata"          = base64encode(data.template_file.srv_az0_metaDefault[each.key].rendered)
  }

  network_interfaces {
    virtual_network = "VM Network"  # Connecting to the portgroup defined on network.tf
    nic_type        = "e1000"
  }
    
  network_interfaces {
    virtual_network = esxi_portgroup.PGx["AZ0-Uplink"].name  # Connecting to the portgroup defined on network.tf
    nic_type        = "e1000"
  }

  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    # [ COMMANDS ]
      # echo '    docker_host${each.key}:' >> /home/project/VOMDITE/ansible-files/ansible-application-deploy/application_inventory.yml
      # echo '      ansible_host: ${var.appservice_AZ0_CIDR}.${each.key}' >> /home/project/VOMDITE/ansible-files/ansible-application-deploy/application_inventory.yml
      # echo '      ansible_user: ${var.linux_username}' >> /home/project/VOMDITE/ansible-files/ansible-application-deploy/application_inventory.yml
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
      [ ! -f "${var.local_ansible_files_path}/ansible-application-deploy/application_inventory.yml" ] && cat '${var.local_ansible_files_path}/ansible-application-deploy/application_inventory.tpl' > '${var.local_ansible_files_path}/ansible-application-deploy/application_inventory.yml'
      echo '    docker_host${each.key}:' >> /home/project/VOMDITE/ansible-files/ansible-application-deploy/application_inventory.yml
      echo '      ansible_host: ${var.appservice_AZ0_CIDR}.${each.key}' >> /home/project/VOMDITE/ansible-files/ansible-application-deploy/application_inventory.yml
      echo '      ansible_user: ${var.linux_username}' >> /home/project/VOMDITE/ansible-files/ansible-application-deploy/application_inventory.yml
    EOT
  }

depends_on = [esxi_guest.up001]

}
