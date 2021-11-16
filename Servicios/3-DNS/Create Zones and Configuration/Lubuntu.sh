#!/bin/bash

###################################################
###---Crear nuestras zonas directas e inversas---##
###################################################
# * Aquí no hay que hacer nada para las delegaciones * #
echo 'zone "asir6" {'                         > /etc/bind/named.conf.local
echo "      type master;"                     >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.asir6"; '      >> /etc/bind/named.conf.local
echo '      notify yes; '                     >> /etc/bind/named.conf.local # Cuando haya cambios en la zona se notifican a los secundarios
#echo '      also-notify {} '                  >> /etc/bind/named.conf.local # Para notificar también a otros secundarios no declarados
echo "};"                                     >> /etc/bind/named.conf.local

echo ""                                       >> /etc/bind/named.conf.local

echo 'zone "6.33.10.in-addr.arpa" {'          >> /etc/bind/named.conf.local
echo "      type master;"                     >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.10.33.6"; '    >> /etc/bind/named.conf.local
echo "      notify yes; "                     >> /etc/bind/named.conf.local # Cuando haya cambios en la zona se notifican a los secundarios que no estén declarados
echo "};"                                     >> /etc/bind/named.conf.local

echo ""                                       >> /etc/bind/named.conf.local

###################################################
#######--------Subdominio Forma 2----------########
###################################################
echo 'zone "bbdd.asir6" {'                    >> /etc/bind/named.conf.local
echo "      type master;"                     >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.bbdd.asir6"; ' >> /etc/bind/named.conf.local
echo "};"                                     >> /etc/bind/named.conf.local


###################################################
###---Crear configuracion de la DB de las zonas--##
###################################################
touch /etc/bind/db.asir6

echo ";"                                               >  /etc/bind/db.asir6 
echo '"$TTL"    86400'                                 >> /etc/bind/db.asir6 # Tiempo en caché de las respuestas positivas
echo "@     IN  SOA  ns1.asir6.  adrian.asir6.  ("     >> /etc/bind/db.asir6 # El segundo parámetro es el contacto administrativo 
echo "                       3   ; Serial"             >> /etc/bind/db.asir6 # Es la version
echo "                  604800   ; Refresh"            >> /etc/bind/db.asir6 # Cada cuanto tiempo tienen que preguntar los servidores secundarios
echo "                   86400   ; Retry"              >> /etc/bind/db.asir6 # Tiempo de reintento
echo "                 2419200   ; Expire"             >> /etc/bind/db.asir6 # Tiempo en el que expira
echo "                   86400 ) ; Negative Cache TTL" >> /etc/bind/db.asir6 # Tiempo en caché de las respuestas negativas
echo ";"                                               >> /etc/bind/db.asir6
echo "@        IN  NS       ns1.asir6."                >> /etc/bind/db.asir6 # @ quiere decir "para esta zona"
#echo "@        IN  NS       ns2.asir6."                >> /etc/bind/db.asir6 # Zona secundaria del wserver
echo "@        IN  NS       ns3.asir6."                >> /etc/bind/db.asir6 # Zona secundaria del debian
echo "ipfire   IN  A        10.33.6.1"                 >> /etc/bind/db.asir6
echo "router   IN  CNAME    ipfire.asir6."             >> /etc/bind/db.asir6 # CNAME quiere decir que es un alias
echo "debian   IN  A        10.33.6.2"                 >> /etc/bind/db.asir6
echo "ns1      IN  A        10.33.6.3"                 >> /etc/bind/db.asir6
#echo "ns2      IN  A        10.33.6.4"                 >> /etc/bind/db.asir6 # Zona secundaria del wserver
echo "ns3      IN  A        10.33.6.2"                 >> /etc/bind/db.asir6 # Zona secundaria del debian
echo "wserver  IN  A        10.33.6.4"                 >> /etc/bind/db.asir6
echo "@        IN  MX 10    debian.asir6."             >> /etc/bind/db.asir6 # MX es del mail y el 10 es la prioridad, a menor número mayor prioridad
echo "@        IN  MX 20    wserver.asir6."            >> /etc/bind/db.asir6
echo "equipo1.redes        IN  A    10.33.6.101"       >> /etc/bind/db.asir6 # Subdominio con 2 equipos
echo "equipo2.redes        IN  A    10.33.6.102"       >> /etc/bind/db.asir6 # Subdominio con 2 equipos
###################################################
#######---------- DELEGACIÓN --------------########
###################################################
echo "ssoo.asir6.          IN  NS   dns.ssoo.asir6."   >> /etc/bind/db.asir6 # ! Delegación
echo "dns.ssoo.asir6.      IN  A    10.33.6.2"         >> /etc/bind/db.asir6 # ! Delegación
###################################################
#######--------Subdominio Forma 1----------########
###################################################
#echo "equipo1.redes        IN  A    10.33.6.101"       >> /etc/bind/db.asir6 # Subdominio con 2 equipos
#echo "equipo2.redes        IN  A    10.33.6.102"       >> /etc/bind/db.asir6 # Subdominio con 2 equipos

# * ZONA INVERSA * #
touch /etc/bind/db.10.33.6

echo ";"                                               >  /etc/bind/db.10.33.6 
echo '"$TTL"    86400'                                 >> /etc/bind/db.10.33.6
echo "@     IN  SOA  ns1.asir6.  adrian.asir6.  ("     >> /etc/bind/db.10.33.6
echo "                       4   ; Serial"             >> /etc/bind/db.10.33.6
echo "                  604800   ; Refresh"            >> /etc/bind/db.10.33.6
echo "                   86400   ; Retry"              >> /etc/bind/db.10.33.6 
echo "                 2419200   ; Expire"             >> /etc/bind/db.10.33.6
echo "                   86400 ) ; Negative Cache TTL" >> /etc/bind/db.10.33.6
echo ";"                                               >> /etc/bind/db.10.33.6
echo "@        IN  NS       ns1.asir6."                >> /etc/bind/db.10.33.6
#echo "@        IN  NS       ns2.asir6."                >> /etc/bind/db.10.33.6 # Zona secundaria del wserver
echo "@        IN  NS       ns3.asir6."                >> /etc/bind/db.10.33.6 # Zona secundaria del debian
echo "1        IN  PTR      ipfire.asir6."             >> /etc/bind/db.10.33.6
###################################################
#####-----Subdominio Forma 1 y 2 INVERSA-----######
###################################################
echo "101      IN  PTR      equipo1.redes.asir6."      >> /etc/bind/db.10.33.6
echo "102      IN  PTR      equipo1.redes.asir6."      >> /etc/bind/db.10.33.6
echo "201      IN  PTR      pc01.bbdd.asir6."          >> /etc/bind/db.10.33.6
echo "202      IN  PTR      pc02.bbdd.asir6."          >> /etc/bind/db.10.33.6

###################################################
#######--------Subdominio Forma 2----------########
###################################################
touch /etc/bind/db.bbdd.asir6

echo ";"                                               >  /etc/bind/db.bbdd.asir6
echo '"$TTL"    86400'                                 >> /etc/bind/db.bbdd.asir6
echo "@     IN  SOA  ns1.asir6.  adrian.asir6.  ("     >> /etc/bind/db.bbdd.asir6 # Se podría poner ns1.bbdd.asir6. pero habría que crear un registro de tipo A
echo "                       3   ; Serial"             >> /etc/bind/db.bbdd.asir6
echo "                  604800   ; Refresh"            >> /etc/bind/db.bbdd.asir6
echo "                   86400   ; Retry"              >> /etc/bind/db.bbdd.asir6 
echo "                 2419200   ; Expire"             >> /etc/bind/db.bbdd.asir6
echo "                   86400 ) ; Negative Cache TTL" >> /etc/bind/db.bbdd.asir6
echo ";"                                               >> /etc/bind/db.bbdd.asir6
echo "@     IN  NS   ns1.asir6."                       >> /etc/bind/db.bbdd.asir6
echo "pc01  IN  A    10.33.6.201"                      >> /etc/bind/db.bbdd.asir6
echo "pc02  IN  A    10.33.6.201"                      >> /etc/bind/db.bbdd.asir6

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