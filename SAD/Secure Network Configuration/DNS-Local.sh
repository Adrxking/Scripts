#!/bin/bash
# Instalar paquetes
apt update -y
apt install bind9 -y
apt install nmap -y

###################################################
###---Crear nuestras zonas directas e inversas---##
###################################################
# * Aquí no hay que hacer nada para las delegaciones * #
echo 'zone "asir6" {'                         > /etc/bind/named.conf.local
echo "      type master;"                     >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.asir6"; '      >> /etc/bind/named.conf.local
echo "};"                                     >> /etc/bind/named.conf.local

echo ""                                       >> /etc/bind/named.conf.local

echo 'zone "1.168.192.in-addr.arpa" {'        >> /etc/bind/named.conf.local
echo "      type master;"                     >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.192.168.1"; '  >> /etc/bind/named.conf.local
echo "};"                                     >> /etc/bind/named.conf.local

echo ""                                       >> /etc/bind/named.conf.local

###################################################
###---Crear configuracion de la DB de las zonas--##
###################################################
touch /etc/bind/db.asir6

echo ";"                                               >  /etc/bind/db.asir6 
echo '"$TTL"    86400'                                 >> /etc/bind/db.asir6
echo "@     IN  SOA  ns1.asir6.  adrian.asir6.  ("     >> /etc/bind/db.asir6 
echo "                       3   ; Serial"             >> /etc/bind/db.asir6
echo "                  604800   ; Refresh"            >> /etc/bind/db.asir6
echo "                   86400   ; Retry"              >> /etc/bind/db.asir6
echo "                 2419200   ; Expire"             >> /etc/bind/db.asir6
echo "                   86400 ) ; Negative Cache TTL" >> /etc/bind/db.asir6
echo ";"                                               >> /etc/bind/db.asir6
echo "@        IN  NS       ns1.asir6."                >> /etc/bind/db.asir6 # @ quiere decir "para esta zona"
echo "ipfire   IN  A        40.12.1.1"                 >> /etc/bind/db.asir6

# * ZONA INVERSA * #
touch /etc/bind/db.192.168.1

echo ";"                                               >  /etc/bind/db.192.168.1
echo '"$TTL"    86400'                                 >> /etc/bind/db.192.168.1
echo "@     IN  SOA  ns1.asir6.  adrian.asir6.  ("     >> /etc/bind/db.192.168.1
echo "                       4   ; Serial"             >> /etc/bind/db.192.168.1
echo "                  604800   ; Refresh"            >> /etc/bind/db.192.168.1
echo "                   86400   ; Retry"              >> /etc/bind/db.192.168.1 
echo "                 2419200   ; Expire"             >> /etc/bind/db.192.168.1
echo "                   86400 ) ; Negative Cache TTL" >> /etc/bind/db.192.168.1
echo ";"                                               >> /etc/bind/db.192.168.1
echo "@        IN  NS       ns1.asir6."                >> /etc/bind/db.192.168.1
echo "1        IN  PTR      ipfire.asir6."             >> /etc/bind/db.192.168.1



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