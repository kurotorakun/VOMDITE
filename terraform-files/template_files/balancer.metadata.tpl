#cloud-config

instance-id: ${HOSTNAME}
local-hostname: ${HOSTNAME}

public-keys: 
  - ${ANSIBLEPUBKEY}

network:
  version: 2
  ethernets:
    ens32:
      addresses: [${DCUPLINKCIDR}.${IPADDRESS}/24]

    ens33:
      addresses: [${APPSERVICEAZ0CIDR}.${IPADDRESS}/24]

    ens34:
      addresses: [${APPSERVICEAZ1CIDR}.${IPADDRESS}/24]

    ens35:
      dhcp4: yes
      dhcp4-overrides:
        route-metric: 1
