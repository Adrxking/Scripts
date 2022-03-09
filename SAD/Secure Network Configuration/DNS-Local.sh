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

REQUIRED_PKG="bind9"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="nmap"
checkPackage $REQUIRED_PKG

###################################################
###---Crear nuestras zonas directas e inversas---##
###################################################
echo "zone \"asir6.icv\" {"                                 >> /etc/bind/named.conf.local
echo "  type master;"                                       >> /etc/bind/named.conf.local
echo "  file \"/etc/bind/db.asir6.icv\";"                   >> /etc/bind/named.conf.local
echo "};"                                                   >> /etc/bind/named.conf.local

###################################################
###---Crear configuracion de la DB de las zonas--##
###################################################


echo ";"                                                      >  /etc/bind/db.asir6
echo '$TTL    86400'                                          >> /etc/bind/db.asir6
echo "@     IN  SOA  dns.asir6.icv.  adrian.  ("              >> /etc/bind/db.asir6
echo "                             1   ;  Serial"             >> /etc/bind/db.asir6
echo "                        604800   ; Refresh"             >> /etc/bind/db.asir6
echo "                         86400   ; Retry"               >> /etc/bind/db.asir6
echo "                       2419200   ; Expire"              >> /etc/bind/db.asir6
echo "                         86400 ) ; Negative Cache TTL"  >> /etc/bind/db.asir6
echo ";"                                                      >> /etc/bind/db.asir6
echo "@                 IN  NS        dns.asir6.icv."         >> /etc/bind/db.asir6
echo "dns               IN  A         192.168.1.2"            >> /etc/bind/db.asir6
echo "ipfire            IN  A         40.12.1.1"              >> /etc/bind/db.asir6

###################################################
#######---------- DELEGACIÓN --------------########
###################################################
# * Dejar los reenviadores hacia google * #

echo "options {"                                >  /etc/bind/named.conf.options
echo "        directory \"/var/cache/bind\";"   >> /etc/bind/named.conf.options
echo ""                                         >> /etc/bind/named.conf.options
echo "        forwarders {"                     >> /etc/bind/named.conf.options
echo "                8.8.8.8;"                 >> /etc/bind/named.conf.options
echo "                1.1.1.1;"                 >> /etc/bind/named.conf.options
echo "        };"                               >> /etc/bind/named.conf.options
echo ""                                         >> /etc/bind/named.conf.options
echo "        dnssec-validation auto;"          >> /etc/bind/named.conf.options
echo ""                                         >> /etc/bind/named.conf.options
echo "        listen-on-v6 { any; };"           >> /etc/bind/named.conf.options
echo "};"                                       >> /etc/bind/named.conf.options



###################################################
###-----Comprobar zonas directas e inversas-----###
###################################################
named-checkconf # Si no devuelve nada significa q todo okey
echo "named-checkconf checked"

service bind9 restart

sleep 3

named-checkzone asir6 /etc/bind/db.asir6