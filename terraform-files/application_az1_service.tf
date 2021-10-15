# Servers deployment

resource "esxi_guest" "srv1xx" {
  for_each = toset([ for app_srv in var.application_servers : app_srv.name ]) # List of IPs Addresses and Server IDs
  guest_name = "srv1${each.key}"
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
    "userdata.encoding" = "base64"
    "userdata"          = base64encode(data.template_file.noipv6_userDefault.rendered)
    "metadata.encoding" = "base64"
    "metadata"          = base64encode(data.template_file.srv_az1_metaDefault[each.key].rendered)
  }
  
  network_interfaces {
    virtual_network = esxi_portgroup.PGx["AZ1-Uplink"].name  # Connecting to the portgroup defined on network.tf
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = "VM Network"
    nic_type        = "e1000"
  }

  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    command = <<EOT
      echo '${self.guest_name}: ${self.ip_address}' >> ./logs/infrastructure_deployment_report.txt
      [ ! -f "${var.local_ansible_files_path}/ansible-application-deploy/application_inventory.yml" ] && cat '${var.local_ansible_files_path}/ansible-application-deploy/application_inventory.tpl' > '${var.local_ansible_files_path}/ansible-application-deploy/application_inventory.yml'
      echo '    docker_host1${each.key}:' >> /home/project/VOMDITE/ansible-files/ansible-application-deploy/application_inventory.yml
      echo '      ansible_host: ${var.appservice_AZ1_CIDR}.${each.key}' >> /home/project/VOMDITE/ansible-files/ansible-application-deploy/application_inventory.yml
      echo '      ansible_user: ${var.linux_username}' >> /home/project/VOMDITE/ansible-files/ansible-application-deploy/application_inventory.yml
      echo 'server ${var.appservice_AZ1_CIDR}.${each.key}:80;' > ${var.local_ansible_files_path}/ansible-balancer-deploy/${self.guest_name}_80.upstream.conf
      echo 'server ${var.appservice_AZ1_CIDR}.${each.key}:81;' > ${var.local_ansible_files_path}/ansible-balancer-deploy/${self.guest_name}_81.upstream.conf
    EOT
  }

  depends_on = [ esxi_guest.up001, null_resource.deploy_uptime ]

}
