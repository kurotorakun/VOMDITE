#cloud-config

write_files:
  - path: /etc/sysctl.d/20-disable-ipv6.conf
    encoding: b64
    permissions: "0644"
    owner: root:root
    content: ${NOIPV6}