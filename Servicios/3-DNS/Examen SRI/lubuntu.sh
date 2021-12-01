#!/bin/bash

###################################################
###---Crear nuestras zonas directas e inversas---##
###################################################
echo 'zone "juegodetronos.icv" {'                       >  /etc/bind/named.conf.local
echo "      type master;"                               >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.juegodetronos.icv"; '    >> /etc/bind/named.conf.local
echo "};"                                               >> /etc/bind/named.conf.local

echo ""                                                 >> /etc/bind/named.conf.local

echo 'zone "6.10.in-addr.arpa" {'                       >> /etc/bind/named.conf.local
echo "      type master;"                               >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.10.6"; '                 >> /etc/bind/named.conf.local
echo "};"                                               >> /etc/bind/named.conf.local

echo ""                                                 >> /etc/bind/named.conf.local

###################################################
###---Crear configuracion de la DB de las zonas--##
###################################################

echo ";"                                                        >  /etc/bind/db.juegodetronos.icv 
echo '"$TTL"    86400'                                          >> /etc/bind/db.juegodetronos.icv
echo "@     IN  SOA  ns1.juegodetronos.icv.  adrian.  ("        >> /etc/bind/db.juegodetronos.icv
echo "                       1   ; Serial"                      >> /etc/bind/db.juegodetronos.icv 
echo "                   43200   ; Refresh"                     >> /etc/bind/db.juegodetronos.icv 
echo "                   86400   ; Retry"                       >> /etc/bind/db.juegodetronos.icv 
echo "                 2419200   ; Expire"                      >> /etc/bind/db.juegodetronos.icv
echo "                   21600 ) ; Negative Cache TTL"          >> /etc/bind/db.juegodetronos.icv
echo ";"                                                        >> /etc/bind/db.juegodetronos.icv
echo "@        IN  NS       ns1.juegodetronos.icv."             >> /etc/bind/db.juegodetronos.icv
echo "@        IN  NS       ns2.juegodetronos.icv."             >> /etc/bind/db.juegodetronos.icv
echo "ns1      IN  A        10.6.0.2"                           >> /etc/bind/db.juegodetronos.icv
echo "ns2      IN  A        10.6.0.4"                           >> /etc/bind/db.juegodetronos.icv
echo "robert   IN  A        10.6.0.101"                         >> /etc/bind/db.juegodetronos.icv
echo "cersei   IN  A        10.6.0.102"                         >> /etc/bind/db.juegodetronos.icv
echo "www      IN  CNAME    robert.juegodetronos.icv."          >> /etc/bind/db.juegodetronos.icv
echo "correo   IN  CNAME    cersei.juegodetronos.icv."          >> /etc/bind/db.juegodetronos.icv
echo "@        IN  MX 15    cersei.juegodetronos.icv."          >> /etc/bind/db.juegodetronos.icv
###################################################
######-----Subdominio sin delegación-------########
###################################################
echo "; subdominio hijos sin delegación"                        >> /etc/bind/db.juegodetronos.icv
echo "ned.invernalia        IN  A    10.6.1.201"                >> /etc/bind/db.juegodetronos.icv
echo "jon.invernalia        IN  A    10.6.1.102"                >> /etc/bind/db.juegodetronos.icv
###################################################
#######---------- DELEGACIÓN --------------########
###################################################
echo "hierro.juegodetronos.icv.       IN  NS  ns1.hierro.juegodetronos.icv."    >> /etc/bind/db.juegodetronos.icv
echo "hierro.juegodetronos.icv.       IN  NS  ns2.hierro.juegodetronos.icv."    >> /etc/bind/db.juegodetronos.icv
echo "ns1.hierro.juegodetronos.icv.   IN  A   10.6.0.3"                         >> /etc/bind/db.juegodetronos.icv
echo "ns2.hierro.juegodetronos.icv.   IN  A   10.6.0.4"                         >> /etc/bind/db.juegodetronos.icv

# ! * ZONA INVERSA * #

echo ";"                                                          >  /etc/bind/db.10.6
echo '"$TTL"    86400'                                            >> /etc/bind/db.10.6
echo "@     IN  SOA  ns1.juegodetronos.icv.  adrian.  ("          >> /etc/bind/db.10.6
echo "                       1   ; Serial"                        >> /etc/bind/db.10.6
echo "                  604800   ; Refresh"                       >> /etc/bind/db.10.6
echo "                   86400   ; Retry"                         >> /etc/bind/db.10.6
echo "                 2419200   ; Expire"                        >> /etc/bind/db.10.6
echo "                   86400 ) ; Negative Cache TTL"            >> /etc/bind/db.10.6
echo ";"                                                          >> /etc/bind/db.10.6
echo "@        IN  NS       ns1.juegodetronos.icv."               >> /etc/bind/db.10.6
echo "@        IN  NS       ns2.juegodetronos.icv."               >> /etc/bind/db.10.6
echo "0.101      IN  PTR      robert.juegodetronos.icv."          >> /etc/bind/db.10.6
echo "0.102      IN  PTR      cersei.juegodetronos.icv."          >> /etc/bind/db.10.6
echo "1.201      IN  PTR      ned.invernalia.juegodetronos.icv."  >> /etc/bind/db.10.6
echo "1.102      IN  PTR      jon.invernalia.juegodetronos.icv."  >> /etc/bind/db.10.6
echo "2.151      IN  PTR      theon.hierro.juegodetronos.icv."    >> /etc/bind/db.10.6
echo "2.152      IN  PTR      balon.hierro.juegodetronos.icv."    >> /etc/bind/db.10.6

###################################################
#######---------- DELEGACIÓN --------------########
###################################################
echo "options {"                              >  /etc/bind/named.conf.options
echo "        directory \"/var/cache/bind\";" >> /etc/bind/named.conf.options
echo ""                                       >> /etc/bind/named.conf.options
echo "//        forwarders {"                 >> /etc/bind/named.conf.options
echo "//                8.8.8.8;"             >> /etc/bind/named.conf.options
echo "//                1.1.1.1;"             >> /etc/bind/named.conf.options
echo "//        };"                           >> /etc/bind/named.conf.options
echo ""                                       >> /etc/bind/named.conf.options
echo "        dnssec-validation auto;"        >> /etc/bind/named.conf.options
echo ""                                       >> /etc/bind/named.conf.options
echo "        listen-on-v6 { any; };"         >> /etc/bind/named.conf.options
echo "};"                                     >> /etc/bind/named.conf.options

###################################################
###-----Comprobar zonas directas e inversas-----###
###################################################
named-checkconf # Si no devuelve nada significa q todo okey
echo "named-checkconf checked"

service bind9 restart