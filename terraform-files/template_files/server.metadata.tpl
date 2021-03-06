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
      dhcp4: no
      dhcp6: no
      addresses: [${CIDRBLOCK}.${IPADDRESS}/24]

    ens33:
      dhcp4: yes
      dhcp4-overrides:
        route-metric: 1
