#!/bin/bash

###################################################
###---Crear nuestras zonas directas e inversas---##
###################################################
echo 'zone "asir6" {'                      > /etc/bind/named.conf.local
echo "      type master;"                  >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.asir6"; '   >> /etc/bind/named.conf.local
echo '      notify yes; '                  >> /etc/bind/named.conf.local # Cuando haya cambios en la zona se notifican a los secundarios
#echo '      also-notify {} '               >> /etc/bind/named.conf.local # Para notificar también a otros secundarios no declarados
echo "};"                                  >> /etc/bind/named.conf.local

echo ""                                    >> /etc/bind/named.conf.local

echo 'zone "6.33.10.in-addr.arpa" {'       >> /etc/bind/named.conf.local
echo "      type master;"                  >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.10.33.6"; ' >> /etc/bind/named.conf.local
echo "      notify yes; "                  >> /etc/bind/named.conf.local # Cuando haya cambios en la zona se notifican a los secundarios que no estén declarados
echo "};"                                  >> /etc/bind/named.conf.local


###################################################
###---Crear configuracion de la DB de las zonas--##
###################################################
touch /etc/bind/db.asir6

echo ";"                                               > /etc/bind/db.asir6 
echo '"$TTL"    86400'                                 >> /etc/bind/db.asir6 # Tiempo en caché de las respuestas positivas
echo "@     IN  SOA  ns1.asir6.  adrian.asir6.  ("     >> /etc/bind/db.asir6 # El segundo parámetro es el contacto administrativo 
echo "                       3   ; Serial"             >> /etc/bind/db.asir6 # Es la version
echo "                  604800   ; Refresh"            >> /etc/bind/db.asir6 # Cada cuanto tiempo tienen que preguntar los servidores secundarios
echo "                   86400   ; Retry"              >> /etc/bind/db.asir6 # Tiempo de reintento
echo "                 2419200   ; Expire"             >> /etc/bind/db.asir6 # Tiempo en el que expira
echo "                   86400 ) ; Negative Cache TTL" >> /etc/bind/db.asir6 # Tiempo en caché de las respuestas negativas
echo ";"                                               >> /etc/bind/db.asir6
echo "@        IN  NS       ns1.asir6."     >> /etc/bind/db.asir6 # @ quiere decir "para esta zona"
#echo "@        IN  NS       ns2.asir6."     >> /etc/bind/db.asir6 # Zona secundaria del wserver
echo "@        IN  NS       ns3.asir6."     >> /etc/bind/db.asir6 # Zona secundaria del debian
echo "ipfire   IN  A        10.33.6.1"      >> /etc/bind/db.asir6
echo "router   IN  CNAME    ipfire.asir6."  >> /etc/bind/db.asir6 # CNAME quiere decir que es un alias
echo "debian   IN  A        10.33.6.2"      >> /etc/bind/db.asir6
echo "ns1      IN  A        10.33.6.3"      >> /etc/bind/db.asir6
#echo "ns2      IN  A        10.33.6.4"      >> /etc/bind/db.asir6 # Zona secundaria del wserver
echo "ns3      IN  A        10.33.6.2"      >> /etc/bind/db.asir6 # Zona secundaria del debian
echo "wserver  IN  A        10.33.6.4"      >> /etc/bind/db.asir6
echo "@        IN  MX 10    debian.asir6."  >> /etc/bind/db.asir6 # MX es del mail y el 10 es la prioridad, a menor número mayor prioridad
echo "@        IN  MX 20    wserver.asir6." >> /etc/bind/db.asir6

touch /etc/bind/db.10.33.6

echo ";"                                               > /etc/bind/db.10.33.6 
echo '"$TTL"    86400'                                 >> /etc/bind/db.10.33.6
echo "@     IN  SOA  ns1.asir6.  adrian.asir6.  ("     >> /etc/bind/db.10.33.6
echo "                       3   ; Serial"             >> /etc/bind/db.10.33.6
echo "                  604800   ; Refresh"            >> /etc/bind/db.10.33.6
echo "                   86400   ; Retry"              >> /etc/bind/db.10.33.6 
echo "                 2419200   ; Expire"             >> /etc/bind/db.10.33.6
echo "                   86400 ) ; Negative Cache TTL" >> /etc/bind/db.10.33.6
echo ";"                                               >> /etc/bind/db.10.33.6
echo "@        IN  NS       ns1.asir6."     >> /etc/bind/db.10.33.6
#echo "@        IN  NS       ns2.asir6."     >> /etc/bind/db.10.33.6 # Zona secundaria del wserver
echo "@        IN  NS       ns3.asir6."     >> /etc/bind/db.10.33.6 # Zona secundaria del debian
echo "1        IN  PTR      ipfire.asir6."  >> /etc/bind/db.10.33.6
echo "1        IN  PTR      router.asir6."  >> /etc/bind/db.10.33.6 # Este es el CNAME
echo "2        IN  PTR      debian.asir6."  >> /etc/bind/db.10.33.6


###################################################
###-----Comprobar zonas directas e inversas-----###
###################################################
named-checkconf # Si no devuelve nada significa q todo okey
echo "named-checkconf checked"

service bind9 restart

sleep 5

named-checkzone asir6 /etc/bind/db.asir6