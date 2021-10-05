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
  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_server}"
  
  guestinfo = {
    "userdata.encoding" = "base64"
    "userdata"          = base64encode(data.template_file.userDefault.rendered)
    "metadata.encoding" = "base64"
    "metadata"          = base64encode(data.template_file.srv_metaDefault[each.key].rendered)
  }
  
  network_interfaces {
    virtual_network = esxi_portgroup.PGx["BackendLAN"].name  # Connecting to the portgroup defined on network.tf
    nic_type        = "e1000"
  }

  guest_startup_timeout  = 45
  guest_shutdown_timeout = 30

  provisioner "local-exec" {
    command = "echo '${self.guest_name}: ${self.ip_address}' >> infrastructure_deployment_report.txt"
  }
  
  # depends_on = [esxi_guest.template_ubuntu2004, esxi_guest.chr001]
}
