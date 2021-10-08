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
      addresses: [${APPSCIDRBLOCK}.${IPADDRESS}/24]
      gateway4: ${APPSCIDRBLOCK}.2
      nameservers:
        addresses: [${APPSCIDRBLOCK}.2, 8.8.8.8, 8.8.4.4]
