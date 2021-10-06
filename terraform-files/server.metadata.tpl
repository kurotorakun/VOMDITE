#cloud-config

instance-id: ${HOSTNAME}02
local-hostname: ${HOSTNAME}

network:
  version: 2
  ethernets:
    ens32:
      dhcp4: no
      dhcp6: no
      addresses: [${APPS_CIDR_BLOCK}.${IP_ADDRESS}/24]
      gateway4: ${APPS_CIDR_BLOCK}.2
      nameservers:
        addresses: [${APPS_CIDR_BLOCK}.2, 8.8.8.8, 8.8.4.4]
