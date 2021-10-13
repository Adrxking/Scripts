#!/bin/bash

###################################################
######-----Crear archivo con las interfaces-----###
###################################################
echo 'COMIENZO DE LA CONFIGURACION DE INTERFACES /etc/network/interfaces'

echo source /etc/network/interfaces.d/* > /etc/network/interfaces

echo '' >> /etc/network/interfaces

echo auto lo >> /etc/network/interfaces
echo iface lo inet loopback >> /etc/network/interfaces

echo '' >> /etc/network/interfaces
 
echo allow-hotplug ens33 >> /etc/network/interfaces
echo iface ens33 inet static >> /etc/network/interfaces
echo '' address 192.168.6.1/24 >> /etc/network/interfaces
echo '' gateway 192.168.6.2/24 >> /etc/network/interfaces

echo '' >> /etc/network/interfaces

echo 'FIN DE LA CONFIGURACION DE INTERFACES /etc/network/interfaces'

###################################################
#####-----Configuracion Global DHCPd.conf-----#####
###################################################
echo 'COMIENDO DE LA CONFIGURACION EN /etc/dhcp/dhcpd.conf'

echo 'ddns-update-style none;' > /etc/dhcp/dhcpd.conf 

echo '' >> /etc/dhcp/dhcpd.conf 

echo 'default-lease-time 6000;' >> /etc/dhcp/dhcpd.conf 
echo 'max-lease-time 7200;' >> /etc/dhcp/dhcpd.conf 

echo '' >> /etc/dhcp/dhcpd.conf 

#####--------------LAN 10.33.6.0--------------#####
echo subnet 10.33.6.0 netmask 255.255.255.0{ >> /etc/dhcp/dhcpd.conf 
echo 'range 10.33.6.101 10.33.6.150;' >> /etc/dhcp/dhcpd.conf 
echo 'option routers 10.33.6.1;' >> /etc/dhcp/dhcpd.conf 
echo 'option domain-name-servers 8.8.8.8;' >> /etc/dhcp/dhcpd.conf 
echo } >> /etc/dhcp/dhcpd.conf

echo '' >> /etc/dhcp/dhcpd.conf 

#####--------------LAN 192.168.6.0---------------#####
echo subnet 192.168.6.0 netmask 255.255.255.0{ >> /etc/dhcp/dhcpd.conf 
echo 'range 192.168.6.101 192.168.6.150;' >> /etc/dhcp/dhcpd.conf 
echo 'option routers 192.168.6.2;' >> /etc/dhcp/dhcpd.conf 
echo 'option domain-name-servers 8.8.4.4;' >> /etc/dhcp/dhcpd.conf 
echo } >> /etc/dhcp/dhcpd.conf

echo 'FIN DE LA CONFIGURACION EN /etc/dhcp/dhcpd.conf'

###################################################
##--Configuracion /etc/default/isc-dhcp-server--###
###################################################
echo 'COMIENZO DE LA CONFIGURACION EN /etc/default/isc-dhcp-server.conf'

echo INTERFACESv4="ens33" > /etc/default/isc-dhcp-server
echo INTERFACESv6="" >> /etc/default/isc-dhcp-server

echo 'FIN DE LA CONFIGURACION EN /etc/default/isc-dhcp-server.conf'