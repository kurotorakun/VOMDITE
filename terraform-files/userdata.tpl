#cloud-config

users: 
  - default

system_info:
  default_user:
    name: ubuntu
    passwd: $6$rounds=4096$k7bgNUOE7$.AFvhZg2MU/HtnsD4fe13xlnrckQWXdgOhDgaYLUIGyTWqkAs62WaIxqgCMbV5yU3ETR13/MuwN9oOKHudFqZ1
    home: /home/ubuntu
    shell: /bin/bash
    lock_passwd: false
    gecos: "Ubuntu User Admin"
    groups: [adm, audio, cdrom, dialout, floppy, video, plugdev, dip, netdev, sudo]
    ssh_authorized_keys:
      - ${PUBKEY}

write_files:
  - path: /home/ubuntu/test.txt
    encoding: b64
    content: ${FILE}
    permissions: 0644
    owner: root:root

runcmd: 
  - id > user_info.txt

