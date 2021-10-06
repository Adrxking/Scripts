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
#####-----Configuracion Global DHCPd.conf-----#####
###################################################
echo 'COMIENDO DE LA CONFIGURACION EN /etc/dhcp/dhcpd.conf'

echo ddns-update-style none; > /etc/dhcp/dhcpd.conf 

echo default-lease-time 6000; >> /etc/dhcp/dhcpd.conf 
echo max-lease-time 7200; >> /etc/dhcp/dhcpd.conf 

#####--------------LAN 10.33.6.0--------------#####
echo subnet 10.33.6.0 netmask 255.255.255.0{ >> /etc/dhcp/dhcpd.conf 
echo ' ' range 10.33.6.101 10.33.6.150; >> /etc/dhcp/dhcpd.conf 
echo ' ' option routers 10.33.6.1; >> /etc/dhcp/dhcpd.conf 
echo ' ' option domain-name-servers 8.8.8.8; >> /etc/dhcp/dhcpd.conf 
echo }

#####--------------LAN 191.16.6.0---------------#####
echo subnet 191.16.6.0 netmask 255.255.255.0{ >> /etc/dhcp/dhcpd.conf 
echo ' ' range 191.16.6.101 191.16.6.150; >> /etc/dhcp/dhcpd.conf 
echo ' ' option routers 191.16.6.1; >> /etc/dhcp/dhcpd.conf 
echo ' ' option domain-name-servers 8.8.4.4; >> /etc/dhcp/dhcpd.conf 
echo }

echo 'FIN DE LA CONFIGURACION EN /etc/dhcp/dhcpd.conf'

###################################################
##--Configuracion /etc/default/isc-dhcp-server--###
###################################################
echo 'COMIENZO DE LA CONFIGURACION EN /etc/default/isc-dhcp-server.conf'

echo INTERFACESv4="ens33 ens38" > /etc/default/isc-dhcp-server
echo INTERFACESv6="" >> /etc/default/isc-dhcp-server

echo 'FIN DE LA CONFIGURACION EN /etc/default/isc-dhcp-server.conf'

###################################################
#########------IPTABLES PARA NAT-----##############
###################################################
echo 'COMIENZO DE LA CONFIGURACION IPTABLES /etc/default/isc-dhcp-server.conf'
sudo iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
echo 'FIN DE LA CONFIGURACION IPTABLES /etc/default/isc-dhcp-server.conf'

echo 'REINICIA EL PC Y LO TENDRÁS TODO LISTO, DISFRUTA!'