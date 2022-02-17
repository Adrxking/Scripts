###################################################
##########----- SCRIPT PARA DHCP -----#############
###################################################
#!/bin/bash
###################################################
#####-----Actualizar sistema-----##################
###################################################
apt update -y && apt upgrade -y

###################################################
###-----Instalar isc-dhcp-server e iptables-----###
###################################################
checkPackage () {
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $1|grep "install ok installed")
    echo Checking for $1: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
        echo "No $1. Setting up $1."
        sudo apt-get --yes install $1
    fi
}

REQUIRED_PKG="isc-dhcp-server"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="iptables"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="iptables-persistent"
checkPackage $REQUIRED_PKG

echo 'INSTALACIONES COMPLETAS'

###################################################
#########----- Copia de DHCPd.conf --------########
###################################################
cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.original

###################################################
#####---- Configuracion Global DHCPd.conf ----#####
###################################################
echo 'COMIENZO DE LA CONFIGURACION EN /etc/dhcp/dhcpd.conf'

echo 'ddns-update-style none;'                      >  /etc/dhcp/dhcpd.conf 

echo ''                                             >> /etc/dhcp/dhcpd.conf 

echo 'default-lease-time 6000;'                     >> /etc/dhcp/dhcpd.conf 
echo 'max-lease-time 7200;'                         >> /etc/dhcp/dhcpd.conf 

echo ''                                             >> /etc/dhcp/dhcpd.conf 

#####-------------- LAN 40.12.1.0 --------------#####
echo 'subnet 40.12.1.0 netmask 255.255.255.0 {'     >> /etc/dhcp/dhcpd.conf 
echo '  range 40.12.1.2 40.12.1.254;'               >> /etc/dhcp/dhcpd.conf 
echo '  option routers 40.12.1.1;'                  >> /etc/dhcp/dhcpd.conf 
echo '  option domain-name-servers 192.168.1.2;'    >> /etc/dhcp/dhcpd.conf 
echo '  default-lease-time 172800;'                 >> /etc/dhcp/dhcpd.conf 
echo '  max-lease-time 259200;'                     >> /etc/dhcp/dhcpd.conf 
echo '}'                                            >> /etc/dhcp/dhcpd.conf

echo ''                                             >> /etc/dhcp/dhcpd.conf 

#####--------------LAN 192.168.1.0--------------#####
echo 'subnet 192.168.1.0 netmask 255.255.255.0 {'   >> /etc/dhcp/dhcpd.conf 
echo '  range 192.168.1.2 192.168.1.254;'           >> /etc/dhcp/dhcpd.conf 
echo '  option routers 192.168.1.1;'                >> /etc/dhcp/dhcpd.conf 
echo '  option domain-name-servers 192.168.1.2;'    >> /etc/dhcp/dhcpd.conf 
echo '}'                                            >> /etc/dhcp/dhcpd.conf

echo ''                                             >> /etc/dhcp/dhcpd.conf 

#####--------------LAN 192.168.2.0--------------#####
echo 'subnet 192.168.2.0 netmask 255.255.255.0 {'   >> /etc/dhcp/dhcpd.conf 
echo '  range 192.168.2.2 192.168.2.254;'           >> /etc/dhcp/dhcpd.conf 
echo '  option routers 192.168.2.1;'                >> /etc/dhcp/dhcpd.conf 
echo '  option domain-name-servers 192.168.1.2;'    >> /etc/dhcp/dhcpd.conf 
echo '}'                                            >> /etc/dhcp/dhcpd.conf

echo ''                                             >> /etc/dhcp/dhcpd.conf 

echo 'FIN DE LA CONFIGURACION EN /etc/dhcp/dhcpd.conf'

###################################################
##--Configuracion /etc/default/isc-dhcp-server--###
###################################################
# * IMPORTANTE COMPROBAR CUALES SON LAS INTERFACES * #
echo 'COMIENZO DE LA CONFIGURACION EN /etc/default/isc-dhcp-server'

echo INTERFACESv4="ens33 ens36 ens38"               >  /etc/default/isc-dhcp-server
echo INTERFACESv6=""                                >> /etc/default/isc-dhcp-server

echo 'FIN DE LA CONFIGURACION EN /etc/default/isc-dhcp-server'

###################################################
####----Configuracion /etc/dhcp/sysctl.conf----####
###################################################
echo 'net.ipv4.ip_forward=1'                        > /etc/sysctl.conf

###################################################
#########------IPTABLES PARA NAT-----##############
###################################################
echo 'COMIENZO DE LA CONFIGURACION IPTABLES /etc/default/isc-dhcp-server.conf'
sleep 2
iptables --flush 

iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE

iptables -P INPUT DROP # Dropear todos los paquetes de la tabla input
iptables -P FORWARD DROP # Dropear todos los paquetes de la tabla forward
iptables -P OUTPUT DROP # Dropear todos los paquetes de la tabla output

iptables -A INPUT -i lo -j ACCEPT  # Permitir todos los paquetes a la red local
iptables -A OUTPUT -o lo -j ACCEPT  # Permitir todos los paquetes desde la red local

iptables -A FORWARD -p udp -s 192.168.1.0/24 -o ens33 --dport 53 --sport 1024:65535 -j ACCEPT  # Habilitar DNS
iptables -A FORWARD -p tcp -s 192.168.1.0/24 -o ens33 -m multiport --dport 80,443 -j ACCEPT  # Habilitar HTTP, HTTPS

# Make persistent rule of iptables
iptables-save                                       > /etc/iptables/rules.v4
echo 'FIN DE LA CONFIGURACION IPTABLES /etc/default/isc-dhcp-server.conf'
sleep 2

###################################################
#########--------RELEER SYSCTL-------##############
###################################################
sysctl -p /etc/sysctl.conf

service isc-dhcp-server restart

sleep 2

service isc-dhcp-server status

echo 'TODO LISTO!'

###################################################
########----- FIN SCRIPT PARA DHCP -----###########
###################################################