#cloud-config

users: 
  - default
#     ssh_import_id:
#       - gh: kurotorakun

system_info:
  default_user:
    name: ubuntu
    passwd: $6$rounds=4096$k7bgNUOE7$.AFvhZg2MU/HtnsD4fe13xlnrckQWXdgOhDgaYLUIGyTWqkAs62WaIxqgCMbV5yU3ETR13/MuwN9oOKHudFqZ1
    home: /home/ubuntu
    shell: /bin/bash
    lock_passwd: False
    gecos: "Ubuntu User Admin"
    groups: [adm, audio, cdrom, dialout, floppy, video, plugdev, dip, netdev, sudo]
    ssh_authorized_keys:
      - ${HOSTPUBKEY}
      - ${ANSIBLEPUBKEY}

write_files:
  - path: /home/ubuntu/CLOUD_INIT_WAS_HERE
    content: This is a test
    permissions: 0777
    owner: ubuntu:ubuntu
  - path: /home/ubuntu/.ssh/authorized_keys 
    content: |
      ${HOSTPUBKEY}
      ${ANSIBLEPUBKEY}
    permissions: 0600
    owner: ubuntu:ubuntu
    append: true

# runcmd: 
#   - id > ~/user_info.txt
