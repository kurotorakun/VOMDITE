# Post Installation Scripts

resource "null_resource" "deploy_uptime" {
  # triggers = {
  #   always_run = timestamp()
  # }
  
  provisioner "local-exec" {
    # TODO: implement configuration write_files and set proper ownership for kuma docker image).
    # ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.uptime_address} 'mkdir -p /docker_data/uptime/data/'
    # rsync '${var.local_ansible_files_path}/ansible-uptime-deploy/kuma.db' ${var.linux_username}@${var.VMNetwork_CIDR}.${var.uptime_address}:/docker_data/uptime/data/
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.uptime_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.uptime_address} 'echo $HOSTNAME is alive'
      ansible-playbook ${var.local_ansible_files_path}/ansible-uptime-deploy/uptime_playbook.yml -i ${var.VMNetwork_CIDR}.${var.uptime_address}, -u ${var.linux_username}
    EOT
  }
  depends_on = [esxi_guest.up001]
}

resource "null_resource" "deploy_monitoring" {
  # triggers = {
  #   always_run = timestamp()
  # }
  
  provisioner "local-exec" {
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.monitoring_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.monitoring_address} 'echo $HOSTNAME is alive'
      ansible-playbook ${var.local_ansible_files_path}/ansible-monitoring-deploy/monitoring_playbook.yml -i ${var.VMNetwork_CIDR}.${var.monitoring_address}, -u ${var.linux_username}
    EOT
  }
  depends_on = [esxi_guest.mon001]
}

resource "null_resource" "deploy_applications" {
  # triggers = {
  #   always_run = timestamp()
  # }

  provisioner "local-exec" {
    # rsync -r --exclude '*.tpl' '${var.local_ansible_files_path}/ansible-application-deploy' ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address}:/home/ubuntu/
    # rm ${var.local_ansible_files_path}/ansible-application-deploy/application_inventory.yml
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.ansible_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'echo $HOSTNAME is alive'
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'ansible-playbook /ansible_data/application_deploy/application_playbook.yml -i /ansible_data/application_deploy/application_inventory.yml'
    EOT
  }
  depends_on = [esxi_guest.ans001]
}

resource "null_resource" "deploy_balancer" {
  # triggers = {
  #   always_run = timestamp()
  # }

  provisioner "local-exec" {
    # rsync -r '${var.local_ansible_files_path}/ansible-balancer-deploy' ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address}:/home/ubuntu/
    # ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} "ssh-keygen -R ${var.DC_uplink_CIDR}.${var.balancer_address}"
    # ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} "ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.DC_uplink_CIDR}.${var.balancer_address} 'mkdir -p /home/ubuntu/balancer/'"
    # ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} "rsync -r --rsync-path='sudo rsync' --include '*.conf' --exclude '*.yml' '/home/ubuntu/ansible-balancer-deploy/' ${var.linux_username}@${var.DC_uplink_CIDR}.${var.balancer_address}:/home/ubuntu/balancer/"
    # rm ${var.local_ansible_files_path}/ansible-balancer-deploy/*.upstream.conf
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.ansible_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'echo $HOSTNAME is alive'
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'ansible-playbook /ansible_data/balancer_deploy/balancer_playbook.yml -i ${var.DC_uplink_CIDR}.${var.balancer_address}, -u ${var.linux_username}'
    EOT
  }
  depends_on = [esxi_guest.lb001, esxi_guest.ans001, null_resource.deploy_applications]
}
