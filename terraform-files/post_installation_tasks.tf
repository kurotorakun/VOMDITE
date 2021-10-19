# Post Installation Scripts

resource "null_resource" "deploy_uptime" {
  provisioner "local-exec" {
    # TODO: implement configuration write_files and set proper ownership for kuma docker image).
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.uptime_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.uptime_address} 'echo $HOSTNAME is alive'
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.uptime_address} 'mkdir -p /home/ubuntu/uptime/data/'
      rsync '${var.local_ansible_files_path}/ansible-uptime-deploy/kuma.db' ${var.linux_username}@${var.VMNetwork_CIDR}.${var.uptime_address}:/home/ubuntu/uptime/data/
      ansible-playbook ${var.local_ansible_files_path}/ansible-uptime-deploy/uptime_playbook.yml -i ${var.VMNetwork_CIDR}.${var.uptime_address}, -u ${var.linux_username}
    EOT
  }
  depends_on = [esxi_guest.up001]
}

resource "null_resource" "deploy_monitoring" {
  provisioner "local-exec" {
    command = <<EOT
      ssh-keygen -R ${var.VMNetwork_CIDR}.${var.monitoring_address}
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.monitoring_address} 'echo $HOSTNAME is alive'
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.uptime_address} 'mkdir -p /home/ubuntu/zabbix/server/'
      ansible-playbook ${var.local_ansible_files_path}/ansible-monitoring-deploy/monitoring_playbook.yml -i ${var.VMNetwork_CIDR}.${var.monitoring_address}, -u ${var.linux_username}
    EOT
  }
  depends_on = [esxi_guest.mon001]
}

resource "null_resource" "deploy_applications" {
  provisioner "local-exec" {
    command = <<EOT
      rsync -r --exclude '*.tpl' '${var.local_ansible_files_path}/ansible-application-deploy' ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address}:/home/ubuntu/
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'ansible-playbook /home/ubuntu/ansible-application-deploy/application_playbook.yml -i /home/ubuntu/ansible-application-deploy/application_inventory.yml'
      rm ${var.local_ansible_files_path}/ansible-application-deploy/application_inventory.yml
    EOT
  }
  depends_on = [esxi_guest.ans001]
}

resource "null_resource" "deploy_balancer" {
  provisioner "local-exec" {
    command = <<EOT
      rsync -r '${var.local_ansible_files_path}/ansible-balancer-deploy' ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address}:/home/ubuntu/
      ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} "ssh-keygen -R ${var.DC_uplink_CIDR}.${var.balancer_address}"
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} "ssh -o StrictHostKeyChecking=no -t ${var.linux_username}@${var.DC_uplink_CIDR}.${var.balancer_address} 'mkdir -p /home/ubuntu/balancer/'"
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} "rsync -r --rsync-path='sudo rsync' --include '*.conf' --exclude '*.yml' '/home/ubuntu/ansible-balancer-deploy/' ${var.linux_username}@${var.DC_uplink_CIDR}.${var.balancer_address}:/home/ubuntu/balancer/"
      ssh -t ${var.linux_username}@${var.VMNetwork_CIDR}.${var.ansible_address} 'ansible-playbook /home/ubuntu/ansible-balancer-deploy/balancer_playbook.yml -i ${var.DC_uplink_CIDR}.${var.balancer_address}, -u ${var.linux_username}'
      rm ${var.local_ansible_files_path}/ansible-balancer-deploy/*.upstream.conf
    EOT
  }
  depends_on = [esxi_guest.lb001, null_resource.deploy_applications]
}
