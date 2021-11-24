# Post Installation Scripts

# [ DEPLOYMENT STAGE 0 ]
# Only up001 instance has been created.

resource "null_resource" "deploy_uptime" {
  provisioner "local-exec" {
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.uptime_address}
      echo "Waiting uptime service to be up..."
      sleep 30
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.uptime_address} 'echo $HOSTNAME is alive'
      ansible-playbook ${var.local_ansible_files_path}/ansible-uptime-deploy/uptime_playbook.yml -i ${var.VMNetwork_CIDR}.${var.uptime_address}, -u ${var.linux_username}
    EOT
  }

  depends_on = [ esxi_guest.up001 ]

}

# [ DEPLOYMENT STAGE 1 ]
# All VMs have been created

# 1.- Deploy ansible service
resource "null_resource" "deploy_ansible" {
  provisioner "local-exec" {
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.ansible_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'sudo mv /home/tmp/ssh/* ./.ssh/'
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'sudo chown ubuntu:ubuntu ./.ssh/*id_rsa*'
      ansible-playbook ${var.local_ansible_files_path}/ansible-host-deploy/ansible_playbook.yml -i ${var.VMNetwork_CIDR}.${var.ansible_address}, -u ${var.linux_username}
    EOT
  }

  depends_on = [ esxi_guest.ans001 ]

}

# 2.- Deploy monitoring service
resource "null_resource" "deploy_monitoring" {
  
  provisioner "local-exec" {
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.monitoring_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.monitoring_address} 'echo $HOSTNAME is alive'
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'ansible-playbook /ansible_data/ansible-monitoring-deploy/monitoring_playbook.yml -i ${var.VMNetwork_CIDR}.${var.monitoring_address}, -u ${var.linux_username}'
    EOT
  }

  depends_on = [ null_resource.deploy_ansible, esxi_guest.mon001 ]

}

# 3.- Deploy application services 
resource "null_resource" "deploy_applications" {

  provisioner "local-exec" {
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.ansible_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'echo $HOSTNAME is alive'
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'ansible-playbook /ansible_data/application_deploy/application_playbook.yml -i /ansible_data/application_deploy/application_inventory.yml'
    EOT
  }

  depends_on = [ null_resource.deploy_monitoring, esxi_guest.srv0xx, esxi_guest.srv1xx, esxi_guest.ans001 ]

}

# 4.- Deploy balancer
resource "null_resource" "deploy_balancer" {

  provisioner "local-exec" {
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.ansible_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'echo $HOSTNAME is alive'
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'ansible-playbook /ansible_data/balancer_deploy/balancer_playbook.yml -i ${var.DC_uplink_CIDR}.${var.balancer_address}, -u ${var.linux_username}'
    EOT
  }

  depends_on = [ null_resource.deploy_applications, esxi_guest.lb001, esxi_guest.ans001 ]
  
}

# [ LIVE STAGE ]
# All VMs have been created, but the lab has been powered off
#  and its activity is resumed.

# 1.- Adjust balancer network interfaces
resource "null_resource" "adjust_balancer" {
  triggers = {  # This trigger forces the execution of the script on each terraform run.
    always_run = timestamp() 
  }
  provisioner "local-exec" {
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.ansible_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'echo $HOSTNAME is alive'
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'ansible-playbook /ansible_data/balancer_update/balancer_playbook.yml -i ${var.DC_uplink_CIDR}.${var.balancer_address}, -u ${var.linux_username}'
    EOT
  }

  depends_on = [ esxi_guest.ans001, esxi_guest.lb001 ]
  
}
