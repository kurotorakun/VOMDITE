# oct/15/2021 13:56:56 by RouterOS 6.48.5
# software id = 
#
#
#
/interface ethernet
set [ find default-name=ether1 ] comment="VM Network" disable-running-check=\
    no disabled=yes
set [ find default-name=ether2 ] comment=WAN1-Uplink disable-running-check=no
set [ find default-name=ether3 ] comment=WAN2-Uplink disable-running-check=no
set [ find default-name=ether4 ] comment=LAN-Network disable-running-check=no
/interface pptp-client
add connect-to=10.1.1.1 disabled=no name=CorporateTunnel password=VOMDITE \
    user=CorporateTunnel
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip ipsec profile
set [ find default=yes ] dh-group=modp2048 enc-algorithm=aes-256 \
    hash-algorithm=sha256
/ip ipsec proposal
set [ find default=yes ] auth-algorithms=sha256 enc-algorithms=aes-256-cbc \
    pfs-group=modp2048
/ip pool
add name=dhcp_pool0 ranges=192.168.100.1-192.168.100.100
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=ether4 name=dhcp1
/routing ospf area
set [ find default=yes ] disabled=yes
/routing ospf instance
set [ find default=yes ] disabled=yes
add name=ISP1-OSPF router-id=10.0.1.1
add name=Corporate-OSPF redistribute-connected=as-type-1 router-id=10.250.0.2
/routing ospf area
add instance=ISP1-OSPF name=ISP1-OSPF-Area
add area-id=0.0.0.1 instance=Corporate-OSPF name=Corporate-OSPF-Area
/ip address
add address=192.168.100.254/24 interface=ether4 network=192.168.100.0
add address=10.0.1.1/24 interface=ether2 network=10.0.1.0
add address=10.0.2.1/24 interface=ether3 network=10.0.2.0
/ip dhcp-client
add disabled=no interface=ether1
/ip dhcp-server network
add address=192.168.100.0/24 dns-server=192.168.27.2 gateway=192.168.100.254
/ip firewall nat
add action=masquerade chain=srcnat src-address=192.168.100.0/24
/routing ospf network
add area=ISP1-OSPF-Area network=10.0.1.0/24
add area=Corporate-OSPF-Area network=10.250.0.0/30
/system identity
set name=CHR-LAN
/tool romon
set enabled=yes
