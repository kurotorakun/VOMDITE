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
