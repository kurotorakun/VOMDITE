# oct/14/2021 16:02:40 by RouterOS 6.48.5
# software id = 
#
#
#
/interface ethernet
set [ find default-name=ether1 ] comment="VM Network" disable-running-check=\
    no disabled=yes
set [ find default-name=ether2 ] comment=DC-WAN1-Uplink \
    disable-running-check=no
set [ find default-name=ether3 ] comment=DC-WAN2-Uplink \
    disable-running-check=no
set [ find default-name=ether4 ] comment=DC-Uplink disable-running-check=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip ipsec profile
set [ find default=yes ] dh-group=modp2048 enc-algorithm=aes-256 \
    hash-algorithm=sha256
/ip ipsec proposal
set [ find default=yes ] auth-algorithms=sha256 enc-algorithms=aes-256-cbc \
    pfs-group=modp2048
/routing ospf area
set [ find default=yes ] disabled=yes
/routing ospf instance
set [ find default=yes ] disabled=yes
add name=ISP1-OSPF router-id=10.1.1.1
add name=Corporate-OSPF redistribute-connected=as-type-1 router-id=10.250.0.1
/routing ospf area
add instance=ISP1-OSPF name=ISP1-OSPF-Area
add area-id=0.0.0.1 instance=Corporate-OSPF name=Corporate-OSPF-Area
/interface pptp-server server
set enabled=yes
/ip address
add address=10.1.1.1/24 interface=ether2 network=10.1.1.0
add address=10.1.2.1/24 interface=ether3 network=10.1.2.0
add address=172.31.0.254/24 interface=ether4 network=172.31.0.0
/ip dhcp-client
add disabled=no interface=ether1
/ip firewall filter
add action=accept chain=input dst-address=10.1.1.1 dst-port=1723 \
    in-interface=ether2 protocol=tcp
add action=accept chain=input protocol=gre
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether2 src-address=\
    172.31.0.0/24
add action=masquerade chain=srcnat out-interface=ether3 src-address=\
    172.31.0.0/24
add action=dst-nat chain=dstnat dst-port=80 protocol=tcp to-addresses=\
    172.31.0.10 to-ports=80
/ip service
set www disabled=yes
/ppp secret
add local-address=10.250.0.1 name=CorporateTunnel password=VOMDITE \
    remote-address=10.250.0.2 service=pptp
/routing filter
add action=discard chain=ospf-out prefix=10.1.1.0/24
add action=discard chain=ospf-out prefix=10.1.2.0/24
add action=discard chain=ospf-out prefix=10.250.0.0/24
/routing ospf network
add area=ISP1-OSPF-Area network=10.1.1.0/24
add area=Corporate-OSPF-Area network=10.250.0.0/24
/system identity
set name=CHR-DC
/tool romon
set enabled=yes
