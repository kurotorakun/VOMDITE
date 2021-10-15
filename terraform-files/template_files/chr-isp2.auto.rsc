# oct/14/2021 16:06:06 by RouterOS 6.48.5
# software id = 
#
#
#
/interface ethernet
set [ find default-name=ether1 ] comment="VM Network" disable-running-check=\
    no
set [ find default-name=ether2 ] comment=WAN2-Uplink disable-running-check=no
set [ find default-name=ether3 ] comment=DC-WAN2-Uplink \
    disable-running-check=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip address
add address=10.0.2.253/24 interface=ether2 network=10.0.2.0
add address=10.1.2.253/24 interface=ether3 network=10.1.2.0
/ip dhcp-client
add disabled=no interface=ether1
/system identity
set name=CHR-ISP2
/tool romon
set enabled=yes
