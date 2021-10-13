# oct/13/2021 15:27:20 by RouterOS 6.48.5
# software id = 
#
#
#
/interface ethernet
set [ find default-name=ether1 ] comment="VM Network"
set [ find default-name=ether2 ] comment=WAN1-Uplink
set [ find default-name=ether3 ] comment=WAN2-Uplink
set [ find default-name=ether4 ] comment=LAN-Network
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip pool
add name=dhcp_pool0 ranges=192.168.100.1-192.168.100.100
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=ether4 name=dhcp1 relay=\
    192.168.100.254
/ip address
add address=192.168.100.254/24 interface=ether4 network=192.168.100.0
add address=10.0.1.1/24 interface=ether2 network=10.0.1.0
add address=10.0.2.1/24 interface=ether3 network=10.0.2.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.100.0/24 dns-server=192.168.100.254 gateway=\
    192.168.100.254
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether2 src-address=\
    192.168.100.0/24
add action=masquerade chain=srcnat out-interface=ether3 src-address=\
    192.168.100.0/24
/system identity
set name=CHR-LAN
