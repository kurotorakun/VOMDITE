# Servers deployment

resource "esxi_guest" "srv0xx" {
  for_each = toset([ for app_srv in var.application_servers : app_srv.name ]) # List of IPs Addresses and Server IDs
  guest_name = "${var.app_az0_hostname}${each.key}"
  disk_store = var.esxi_datastore
  guestos    = "ubuntu-64"

  boot_disk_type = "thin"
  boot_disk_size = "20"

  memsize            = "2048"
  numvcpus           = "2"
  resource_pool_name = "/"
  power              = "on"

  ovf_source        = "${var.ovf_repository_path}/${var.ovf_path_appservice}"
  
  guestinfo = {
    "metadata.encoding" = "base64"
    "metadata"          = base64encode(data.template_file.srv_az0_metaDefault[each.key].rendered)
  }

  network_interfaces {
    virtual_network = esxi_portgroup.PGx["AZ0-Uplink"].name  # Connecting to the portgroup defined on network.tf
    nic_type        = "e1000"
  }

  network_interfaces {
    virtual_network = var.esxi_default_network
    nic_type        = "e1000"
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
