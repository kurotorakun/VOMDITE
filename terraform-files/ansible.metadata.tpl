#cloud-config 

instance-id: ${HOSTNAME}
local-hostname: ${HOSTNAME}

public-keys: 
  - ${HOSTPUBKEY}

network:
  version: 2
  ethernets:
    ens32:
      dhcp4: no
      dhcp6: no
      addresses: [${VMNETWORKCIDR}.${ANSIBLEADDRESS}/24]
      gateway4: ${VMNETWORKCIDR}.2
      nameservers:
        addresses: [${VMNETWORKCIDR}.2, 8.8.8.8, 8.8.4.4]

    ens33:
      addresses: [192.168.100.${ANSIBLEADDRESS}/24]

    ens39:
      addresses: [${APPSERVICEAZ0CIDR}.${ANSIBLEADDRESS}/24]

    ens40:
      addresses: [${APPSERVICEAZ1CIDR}.${ANSIBLEADDRESS}/24]
