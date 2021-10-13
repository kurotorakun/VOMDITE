# oct/13/2021 16:00:52 by RouterOS 6.48.5
# software id = 
#
#
#
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/ip address
add address=10.0.1.253/24 interface=ether2 network=10.0.1.0
add address=10.1.1.253/24 interface=ether3 network=10.1.1.0
/ip dhcp-client
add disabled=no interface=ether1
/system identity
set name=RouterOS
