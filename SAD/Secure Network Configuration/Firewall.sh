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

#########------ LIMPIAR IPTABLES -----##############
iptables --flush 

#########------ ENMASCARAR HACIA INTERNET -----##############
iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE

#########------ POLITICA DE DROP EVERYTHING POR DEFECTO -----##############
iptables -P INPUT DROP   # Dropear todos los paquetes de la tabla input
iptables -P FORWARD DROP # Dropear todos los paquetes de la tabla forward
iptables -P OUTPUT DROP  # Dropear todos los paquetes de la tabla output

#########------ PERMITIR TODO ENTRE LA RED LOCALHOST -----##############
iptables -A INPUT -i lo -j ACCEPT  # RED LOCAL -> RED LOCAL 
iptables -A OUTPUT -o lo -j ACCEPT # RED LOCAL -> RED LOCAL

#########------ HABILITAR DHCP -----##############
iptables -A INPUT -i ens38 -p udp --sport 67 -s 192.168.1.0/24 -j ACCEPT  # RED DMZ   -> FIREWALL
iptables -A INPUT -i ens36 -p udp --sport 67 -s 192.168.1.0/24 -j ACCEPT  # RED LOCAL -> FIREWALL
iptables -A OUTPUT -o ens36 -p udp --dport 68 -d 192.168.1.0/24 -j ACCEPT # FIREWALL  -> RED LOCAL
iptables -A OUTPUT -o ens38 -p udp --dport 68 -d 192.168.1.0/24 -j ACCEPT # FIREWALL  -> RED DMZ

#########------ HABILITAR ICMP -----##############
iptables -A INPUT -i ens33 -p icmp -j ACCEPT    # EXTERIOR     -> RED FIREWALL
iptables -A OUTPUT -o ens33 -p icmp -j ACCEPT   # RED FIREWALL -> EXTERIOR

iptables -A INPUT -i ens38 -p icmp -s 192.168.2.0/24 -j ACCEPT  # RED DMZ   -> FIREWALL
iptables -A INPUT -i ens36 -p icmp -s 192.168.1.0/24 -j ACCEPT  # RED LOCAL -> FIREWALL
iptables -A OUTPUT -o ens36 -p icmp -d 192.168.1.0/24 -j ACCEPT # FIREWALL  -> RED LOCAL
iptables -A OUTPUT -o ens38 -p icmp -d 192.168.2.0/24 -j ACCEPT # FIREWALL  -> RED DMZ

iptables -A FORWARD -i ens36 -o ens38 -p icmp -j ACCEPT # RED LOCAL -> RED DMZ
iptables -A FORWARD -i ens38 -o ens36 -p icmp -j ACCEPT # RED DMZ   -> RED LOCAL

iptables -A FORWARD -i ens38 -o ens33 -s 192.168.2.2/32 -p icmp -j ACCEPT # EQUIPO DMZ -> EXTERIOR
iptables -A FORWARD -i ens33 -o ens38 -d 192.168.2.2/32 -p icmp -j ACCEPT # EXTERIOR -> EQUIPO DMZ

#########------ HABILITAR DNS -----##############
iptables -A FORWARD -i ens36 -o ens33 -s 192.168.1.2/32 -p udp --dport 53 -j ACCEPT # RED LOCAL -> EXTERIOR
iptables -A FORWARD -i ens36 -o ens33 -s 0.0.0.0 -p tcp --dport 53 -j ACCEPT        # RED LOCAL -> EXTERIOR
iptables -A FORWARD -i ens33 -o ens36 -d 192.168.1.2/32 -p udp --sport 53 -j ACCEPT # EXTERIOR  -> RED LOCAL
iptables -A FORWARD -i ens33 -o ens36 -d 0.0.0.0 -p tcp --sport 53 -j ACCEPT        # EXTERIOR  -> RED LOCAL

iptables -A FORWARD -i ens38 -s 192.168.2.2/32 -o ens36 -d 192.168.1.2/32 -p udp --dport 53 -j ACCEPT # RED DMZ   -> RED LOCAL
iptables -A FORWARD -i ens36 -s 192.168.1.2/32 -o ens38 -d 192.168.2.2/32 -p udp --sport 53 -j ACCEPT # RED LOCAL -> RED DMZ

#########------ HABILITAR HTTP/HTTPS -----##############
iptables -A FORWARD -i eth1 -o eth0 -s 192.168.1.0/24 -p tcp -m multiport --dport 80,443 -j ACCEPT    # RED LOCAL -> EXTERIOR
iptables -A FORWARD -i eth0 -o eth1 -d 192.168.1.0/24 -p tcp -m multiport --sport 80,443 -j ACCEPT    # EXTERIOR  -> RED LOCAL

iptables -A FORWARD -i ens36 -o ens38 -s 192.168.1.0/24 -p tcp -m multiport --dport 80,443 -j ACCEPT  # RED LOCAL -> RED DMZ
iptables -A FORWARD -i ens38 -o ens36 -d 192.168.1.0/24 -p tcp -m multiport --sport 80,443 -j ACCEPT  # RED DMZ   -> RED LOCAL

iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to 192.168.2.2:80   # EXTERIOR -> EQUIPO DMZ
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 443 -j DNAT --to 192.168.2.2:443 # EXTERIOR -> EQUIPO DMZ
iptables -A FORWARD -i eth2 -o eth0 -s 192.168.2.2/32 -p tcp -m multiport --sport 80, 443 -j ACCEPT # EQUIPO DMZ -> EXTERIOR
iptables -A FORWARD -i eth0 -o eth2 -d 192.168.2.2/32 -p tcp -m multiport --dport 80, 443 -j ACCEPT # EXTERIOR   -> EQUIPO DMZ


###################################################
#########---- REINICIAR EL SERVICIO ----###########
###################################################

#########------ REGLAS IPV4 PERSISTENTES -----##############
iptables-save                                       > /etc/iptables/rules.v4
echo 'FIN DE LA CONFIGURACION IPTABLES /etc/default/isc-dhcp-server.conf'
sleep 2

sysctl -p /etc/sysctl.conf

service isc-dhcp-server restart

sleep 2

service isc-dhcp-server status

echo 'TODO LISTO!'

###################################################
########----- FIN SCRIPT PARA DHCP -----###########
###################################################