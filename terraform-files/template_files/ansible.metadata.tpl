#cloud-config

instance-id: ${HOSTNAME}
local-hostname: ${HOSTNAME}

hostname: ${HOSTNAME}
fqdn: ${HOSTNAME}

public-keys: 
  - ${HOSTPUBKEY}

network:
  version: 2
  ethernets:
    ens32:
      dhcp4: no
      dhcp6: no
      addresses: [${VMNETWORKCIDR}.${IPADDRESS}/24]
      gateway4: ${VMNETWORKCIDR}.2
      nameservers:
        addresses: [${VMNETWORKCIDR}.2, 8.8.8.8, 8.8.4.4]

    ens33:
      addresses: [${LANCIDR}.${IPADDRESS}/24]

    ens34:
      addresses: [${WAN1UPLINKCIDR}.${IPADDRESS}/24]

    ens35:
      addresses: [${WAN2UPLINKCIDR}.${IPADDRESS}/24]

    ens36:
      addresses: [${DCWAN1UPLINKCIDR}.${IPADDRESS}/24]

    ens37:
      addresses: [${DCWAN2UPLINKCIDR}.${IPADDRESS}/24]

    ens38:
      addresses: [${DCUPLINKCIDR}.${IPADDRESS}/24]

    ens39:
      addresses: [${APPSERVICEAZ0CIDR}.${IPADDRESS}/24]

    ens40:
      addresses: [${APPSERVICEAZ1CIDR}.${IPADDRESS}/24]
