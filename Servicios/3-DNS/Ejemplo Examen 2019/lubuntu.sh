#!/bin/bash

###################################################
###---Crear nuestras zonas directas e inversas---##
###################################################
# * Aquí no hay que hacer nada para las delegaciones * #
echo 'zone "lossimpsons.edu" {'                     >  /etc/bind/named.conf.local
echo "      type master;"                           >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.lossimpsons.edu"; '  >> /etc/bind/named.conf.local
echo "};"                                           >> /etc/bind/named.conf.local

echo ""                                             >> /etc/bind/named.conf.local

echo 'zone "6.16.172.in-addr.arpa" {'               >> /etc/bind/named.conf.local
echo "      type master;"                           >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.172.16.6"; '         >> /etc/bind/named.conf.local
echo "};"                                           >> /etc/bind/named.conf.local

echo ""                                             >> /etc/bind/named.conf.local

###################################################
###---Crear configuracion de la DB de las zonas--##
###################################################
touch /etc/bind/db.asir6

echo ";"                                                        >  /etc/bind/db.lossimpsons.edu 
echo '"$TTL"    86400'                                          >> /etc/bind/db.lossimpsons.edu # Tiempo en caché de las respuestas positivas
echo "@     IN  SOA  ns1.lossimpsons.edu.  adrian.  ("          >> /etc/bind/db.lossimpsons.edu # El segundo parámetro es el contacto administrativo 
echo "                       1   ; Serial"                      >> /etc/bind/db.lossimpsons.edu # Es la version
echo "                  604800   ; Refresh"                     >> /etc/bind/db.lossimpsons.edu # Cada cuanto tiempo tienen que preguntar los servidores secundarios
echo "                   86400   ; Retry"                       >> /etc/bind/db.lossimpsons.edu # Tiempo de reintento
echo "                 2419200   ; Expire"                      >> /etc/bind/db.lossimpsons.edu # Tiempo en el que expira
echo "                   86400 ) ; Negative Cache TTL"          >> /etc/bind/db.lossimpsons.edu # Tiempo en caché de las respuestas negativas
echo ";"                                                        >> /etc/bind/db.lossimpsons.edu
echo "@        IN  NS       ns1.lossimpsons.edu."               >> /etc/bind/db.lossimpsons.edu # @ quiere decir "para esta zona"
echo "@        IN  NS       ns2.lossimpsons.edu."               >> /etc/bind/db.lossimpsons.edu # Zona secundaria del wserver
echo "ns1      IN  A        10.33.6.3"                          >> /etc/bind/db.lossimpsons.edu
echo "ns2      IN  A        10.33.6.2"                          >> /etc/bind/db.lossimpsons.edu # Zona secundaria del wserver
echo "homer    IN  A        172.16.6.101"                       >> /etc/bind/db.lossimpsons.edu
echo "marge    IN  A        172.16.6.102"                       >> /etc/bind/db.lossimpsons.edu
echo "mail     IN  CNAME    marge.lossimpsons.edu."             >> /etc/bind/db.lossimpsons.edu
echo "www      IN  CNAME    homer.lossimpsons.edu."             >> /etc/bind/db.lossimpsons.edu
echo "@        IN  MX 10    marge.lossimpsons.edu."             >> /etc/bind/db.lossimpsons.edu
###################################################
####----Subdominio Forma 1 sin delegación----######
###################################################
echo "; subdominio hijos sin delegación"                        >> /etc/bind/db.lossimpsons.edu 
echo "lisa.hijos        IN  A    172.16.6.201"                  >> /etc/bind/db.lossimpsons.edu
echo "bart.hijos        IN  A    172.16.6.202"                  >> /etc/bind/db.lossimpsons.edu
echo "maggie.hijos      IN  A    172.16.6.203"                  >> /etc/bind/db.lossimpsons.edu
###################################################
#######---------- DELEGACIÓN --------------########
###################################################
echo "familia.lossimpsons.edu.   IN  NS  ns1.familia.lossimpsons.edu."      >> /etc/bind/db.lossimpsons.edu # ! Delegación a wserver
echo "familia.lossimpsons.edu.   IN  NS  ns2.familia.lossimpsons.edu."      >> /etc/bind/db.lossimpsons.edu # ! Delegación a debian
echo "ns1.familia.lossimpsons.edu.   IN  A   10.33.6.4"                     >> /etc/bind/db.lossimpsons.edu # ! Delegación a wserver
echo "ns2.familia.lossimpsons.edu.   IN  A   10.33.6.2"                     >> /etc/bind/db.lossimpsons.edu # ! Delegación a debian

# ! * ZONA INVERSA * #

echo ";"                                                        >  /etc/bind/db.172.16.6
echo '"$TTL"    86400'                                          >> /etc/bind/db.172.16.6
echo "@     IN  SOA  ns1.lossimpsons.edu.  adrian.  ("          >> /etc/bind/db.172.16.6
echo "                       1   ; Serial"                      >> /etc/bind/db.172.16.6
echo "                  604800   ; Refresh"                     >> /etc/bind/db.172.16.6
echo "                   86400   ; Retry"                       >> /etc/bind/db.172.16.6
echo "                 2419200   ; Expire"                      >> /etc/bind/db.172.16.6
echo "                   86400 ) ; Negative Cache TTL"          >> /etc/bind/db.172.16.6
echo ";"                                                        >> /etc/bind/db.172.16.6
echo "@        IN  NS       ns1.lossimpsons.edu."               >> /etc/bind/db.172.16.6
echo "@        IN  NS       ns2.lossimpsons.edu."               >> /etc/bind/db.172.16.6
echo "101      IN  PTR      homer.lossimpsons.edu."             >> /etc/bind/db.172.16.6
echo "102      IN  PTR      marge.lossimpsons.edu."             >> /etc/bind/db.172.16.6
echo "201      IN  PTR      lisa.hijos.lossimpsons.edu."        >> /etc/bind/db.172.16.6
echo "202      IN  PTR      bart.hijos.lossimpsons.edu."        >> /etc/bind/db.172.16.6
echo "202      IN  PTR      maggie.hijos.lossimpsons.edu."      >> /etc/bind/db.172.16.6
echo "221      IN  PTR      abraham.familia.lossimpsons.edu."   >> /etc/bind/db.172.16.6
echo "222      IN  PTR      patty.familia.lossimpsons.edu."     >> /etc/bind/db.172.16.6

###################################################
#######---------- DELEGACIÓN --------------########
###################################################
# * Hay que comentar los reenviadores (/etc/bind/named.conf.options) para que la delegación funcione * #

echo "options {"                            >  /etc/bind/named.conf.options
echo "        directory \"/var/cache/bind\";" >> /etc/bind/named.conf.options
echo ""                                     >> /etc/bind/named.conf.options
echo "//        forwarders {"               >> /etc/bind/named.conf.options
echo "//                8.8.8.8;"           >> /etc/bind/named.conf.options
echo "//                1.1.1.1;"           >> /etc/bind/named.conf.options
echo "//        };"                         >> /etc/bind/named.conf.options
echo ""                                     >> /etc/bind/named.conf.options
echo "        dnssec-validation auto;"      >> /etc/bind/named.conf.options
echo ""                                     >> /etc/bind/named.conf.options
echo "        listen-on-v6 { any; };"       >> /etc/bind/named.conf.options
echo "};"                                   >> /etc/bind/named.conf.options

###################################################
###-----Comprobar zonas directas e inversas-----###
###################################################
named-checkconf # Si no devuelve nada significa q todo okey
echo "named-checkconf checked"

service bind9 restart

sleep 3

named-checkzone asir6 /etc/bind/db.asir6