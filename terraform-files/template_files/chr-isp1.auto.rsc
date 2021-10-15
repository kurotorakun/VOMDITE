# oct/14/2021 16:00:37 by RouterOS 6.48.5
# software id = 
#
#
#
/interface ethernet
set [ find default-name=ether1 ] comment="VM Network" disable-running-check=\
    no
set [ find default-name=ether2 ] comment=WAN1-Uplink disable-running-check=no
set [ find default-name=ether3 ] comment=DC-WAN1-Uplink \
    disable-running-check=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing ospf area
set [ find default=yes ] disabled=yes
/routing ospf instance
set [ find default=yes ] disabled=yes
add distribute-default=if-installed-as-type-1 name=ISP1-OSPF \
    redistribute-connected=as-type-1 router-id=10.0.1.253
/routing ospf area
add instance=ISP1-OSPF name=ISP1-OSPF-Area
/ip address
add address=10.0.1.253/24 interface=ether2 network=10.0.1.0
add address=10.1.1.253/24 interface=ether3 network=10.1.1.0
/ip dhcp-client
add disabled=no interface=ether1
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1 src-address=\
    10.0.0.0/8
/routing filter
add action=discard chain=ospf-out prefix=192.168.27.0/24
/routing ospf network
add area=ISP1-OSPF-Area network=10.0.1.0/24
add area=ISP1-OSPF-Area network=10.1.1.0/24
/system identity
set name=CHR-ISP1
/tool romon
set enabled=yes
