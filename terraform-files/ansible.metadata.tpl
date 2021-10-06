#cloud-config

instance-id: ${HOSTNAME}01
local-hostname: ${HOSTNAME}

network:
  version: 2
  ethernets:
    ens32:
      dhcp4: no
      dhcp6: no
      addresses: [192.168.27.250/24]
      gateway4: 192.168.27.2
      nameservers:
        addresses: [192.168.27.2, 8.8.8.8, 8.8.4.4]

    ens33:
      addresses: [192.168.100.250/24] #

    ens39:
      addresses: [172.16.0.250/24]    #
