#cloud-config

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
  - path: /ansible_data/balancer_deploy/balancer_playbook.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${BALANCERPB}
  - path: /ansible_data/application_deploy/application_playbook.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${APPPB}
  - path: /ansible_data/application_deploy/application_vars.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${APPVARS}
  - path: /ansible_data/application_deploy/application_inventory.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${APPINVENTORY}
  - path: /ansible_data/chr_deploy/chr_vars.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${CHRVARS}
  - path: /ansible_data/chr_deploy/chr_FWL7_deployment.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${CHRLANFWL7DEPLOY}
  - path: /ansible_data/chr_deploy/chr_disable_FWL7.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${CHRLANDISFWL7}
  - path: /ansible_data/chr_deploy/chr_enable_FWL7.yml
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${CHRLANENAFWL7}
