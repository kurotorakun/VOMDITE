#cloud-config

instance-id: ${HOSTNAME}
local-hostname: ${HOSTNAME}

public-keys: 
  - ${ANSIBLEPUBKEY}
  - ${HOSTPUBKEY}

network:
  version: 2
  ethernets:
    ens32:
      dhcp4: yes
    ens33:
      dhcp4: no
      dhcp6: no
      addresses: [${CIDRBLOCK}.${IPADDRESS}/24]
      gateway4: ${CIDRBLOCK}.2
      nameservers:
        addresses: [${CIDRBLOCK}.2, 8.8.8.8, 8.8.4.4]