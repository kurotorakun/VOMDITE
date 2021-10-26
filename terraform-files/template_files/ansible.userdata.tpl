#cloud-config

# users:
#   - default
# 
# system_info:
#   default_user:
#     name: ubuntu
#     home: /home/ubuntu
#     shell: /bin/bash
#     lock_passwd: False
#     gecos: "Ubuntu User Admin"
#     groups: [adm, audio, cdrom, dialout, floppy, video, plugdev, dip, netdev, sudo]

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