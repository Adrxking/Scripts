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
echo '' address 10.33.6.2/24 >> /etc/network/interfaces
echo '' gateway 10.33.6.1 >> /etc/network/interfaces
echo '' dns-nameservers 8.8.8.8 >> /etc/network/interfaces

echo '' >> /etc/network/interfaces

echo allow-hotplug ens38 >> /etc/network/interfaces
echo iface ens38 inet static >> /etc/network/interfaces
echo '' address 191.16.6.1/24 >> /etc/network/interfaces

echo 'FIN DE LA CONFIGURACION DE INTERFACES /etc/network/interfaces'

###################################################
######-----Crear archivo resolv-----###############
###################################################
echo 'COMIENZO DE LA CONFIGURACION DE /etc/resolv.conf'
echo nameserver 8.8.8.8 > /etc/resolv.conf
echo 'FIN DE LA CONFIGURACION DE /etc/resolv.conf'

echo 'REINICIA EL PC, NECESITAS OBTENER LAS IP PARA SEGUIR CON LAS INSTALACIONES'
