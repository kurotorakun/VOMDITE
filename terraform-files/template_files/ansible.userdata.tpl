#cloud-config

manage_etc_hosts:
  default: true

write_files:
  - path: /home/tmp/ssh/id_rsa
    encoding: b64
    content: ${ANSIBLEKEY}
    permissions: "0600"
  - path: /home/tmp/ssh/id_rsa.pub
    content: ${ANSIBLEPUBKEY}
    permissions: "0644"
  - path: /etc/sysctl.d/10-disable-ipv6.conf
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${NOIPV6}
  - path: ${ANSIBLEPATH}/balancer_deploy/balancer_playbook.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${BALANCERPB}
  - path: ${ANSIBLEPATH}/balancer_update/balancer_playbook.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${BALANCERUP}    
  - path: ${ANSIBLEPATH}/application_deploy/application_playbook.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${APPPB}
  - path: ${ANSIBLEPATH}/application_deploy/application_vars.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${APPVARS}
  - path: ${ANSIBLEPATH}/application_deploy/application_inventory.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${APPINVENTORY}
  - path: ${ANSIBLEPATH}/chr_deploy/chr_vars.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${CHRVARS}
  - path: ${ANSIBLEPATH}/chr_deploy/chr-lan_FWL7_deployment.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${CHRLANFWL7DEPLOY}
  - path: ${ANSIBLEPATH}/chr_deploy/chr-dc_FWL7_deployment.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${CHRDCFWL7DEPLOY}    
  - path: ${ANSIBLEPATH}/chr_deploy/chr-lan_disable_FWL7.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${CHRLANDISFWL7}
  - path: ${ANSIBLEPATH}/chr_deploy/chr-lan_enable_FWL7.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${CHRLANENAFWL7}
  - path: ${ANSIBLEPATH}/monitoring_deploy/monitoring_playbook.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${MONITORINGPB}
