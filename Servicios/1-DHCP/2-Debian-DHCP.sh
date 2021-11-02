#!/bin/bash
###################################################
#####-----Actualizar sistema-----##################
###################################################
apt update -y && apt upgrade -y

###################################################
###-----Instalar isc-dhcp-server e iptables-----###
###################################################
apt install isc-dhcp-server iptables -y

echo 'INSTALACIONES COMPLETAS'

###################################################
#####-----Copia de DHCPd.conf.original--------#####
###################################################
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.original

###################################################
#####-----Configuracion Global DHCPd.conf-----#####
###################################################
echo 'COMIENDO DE LA CONFIGURACION EN /etc/dhcp/dhcpd.conf'

echo 'ddns-update-style none;' > /etc/dhcp/dhcpd.conf 

echo '' >> /etc/dhcp/dhcpd.conf 

echo 'default-lease-time 6000;' >> /etc/dhcp/dhcpd.conf 
echo 'max-lease-time 7200;' >> /etc/dhcp/dhcpd.conf 

echo '' >> /etc/dhcp/dhcpd.conf 

#####--------------LAN 192.168.2.0--------------#####
echo 'subnet 192.168.2.0 netmask 255.255.255.0 {' >> /etc/dhcp/dhcpd.conf 
echo '  range 192.168.2.101 192.168.2.254;' >> /etc/dhcp/dhcpd.conf 
echo '  option routers 192.168.2.1;' >> /etc/dhcp/dhcpd.conf 
echo '  option domain-name-servers 8.8.8.8;' >> /etc/dhcp/dhcpd.conf 
echo '}' >> /etc/dhcp/dhcpd.conf

echo '' >> /etc/dhcp/dhcpd.conf 

#####--------------LAN 192.168.3.0--------------#####
echo 'subnet 192.168.3.0 netmask 255.255.255.0 {' >> /etc/dhcp/dhcpd.conf 
echo '  range 192.168.3.101 192.168.3.254;' >> /etc/dhcp/dhcpd.conf 
echo '  option routers 192.168.3.2;' >> /etc/dhcp/dhcpd.conf 
echo '  option domain-name-servers 8.8.8.8;' >> /etc/dhcp/dhcpd.conf 
echo '}' >> /etc/dhcp/dhcpd.conf

echo '' >> /etc/dhcp/dhcpd.conf 

#####--------------Reserva de IPs---------------#####
echo 'host adrian {' >> /etc/dhcp/dhcpd.conf 
echo '  hardware ethernet 00:00:00:00:00:a5;' >> /etc/dhcp/dhcpd.conf 
echo '  fixed-address 192.168.2.60;' >> /etc/dhcp/dhcpd.conf 
echo '}' >> /etc/dhcp/dhcpd.conf

echo 'FIN DE LA CONFIGURACION EN /etc/dhcp/dhcpd.conf'

###################################################
##--Configuracion /etc/default/isc-dhcp-server--###
###################################################
# * IMPORTANTE COMPROBAR CUALES SON LAS INTERFACES * #
echo 'COMIENZO DE LA CONFIGURACION EN /etc/default/isc-dhcp-server'

echo INTERFACESv4="ens33 ens38" > /etc/default/isc-dhcp-server
echo INTERFACESv6="" >> /etc/default/isc-dhcp-server

echo 'FIN DE LA CONFIGURACION EN /etc/default/isc-dhcp-server'

###################################################
####----Configuracion /etc/dhcp/sysctl.conf----####
###################################################
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.conf

###################################################
#########------IPTABLES PARA NAT-----##############
###################################################
echo 'COMIENZO DE LA CONFIGURACION IPTABLES /etc/default/isc-dhcp-server.conf'
sudo iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
echo 'FIN DE LA CONFIGURACION IPTABLES /etc/default/isc-dhcp-server.conf'

###################################################
#########--------RELEER SYSCTL-------##############
###################################################
sysctl -p /etc/sysctl.conf

echo 'TODO LISTO, DISFRUTA!'