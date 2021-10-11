#cloud-config

users: 
  - default

system_info:
  default_user:
    name: ubuntu
    home: /home/ubuntu
    shell: /bin/bash
    lock_passwd: False
    gecos: "Ubuntu User Admin"
    groups: [adm, audio, cdrom, dialout, floppy, video, plugdev, dip, netdev, sudo]
