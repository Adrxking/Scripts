# * Crear una Debian como DNS Secundario * #
# * IP Debian: 10.33.6.2 * #
# * IP DNS Primario (Lubuntu): 10.33.6.3 * #
# * IP Router (Ipfire): 10.33.6.1 * #

# Configurar las interfaces

# Instalar paquetes
apt update -y
apt install bind9 -y
apt install nmap -y

# Reiniciar pc

# Comprobar funcionamiento
systemctl status bind9

#!/bin/bash
###################################################
###-----Crear zonas secundarias y delegación-----##
###################################################

# Cuando es slave el file tiene que ser creado por el proceso bind
# Zona primaria
echo 'zone "asir6" {'                            >  /etc/bind/named.conf.local
echo "      type slave;"                         >> /etc/bind/named.conf.local
echo '      file "db.asir6"; '                   >> /etc/bind/named.conf.local
echo '      masters {10.33.6.3;}; '              >> /etc/bind/named.conf.local # Se pone la ip del primario 
echo "};"                                        >> /etc/bind/named.conf.local

echo ""                                          >> /etc/bind/named.conf.local

# Zona inversa
echo 'zone "6.33.10.in-addr.arpa" {'             >> /etc/bind/named.conf.local
echo "      type slave;"                         >> /etc/bind/named.conf.local
echo '      file "db.10.33.6"; '                 >> /etc/bind/named.conf.local
echo '      masters {10.33.6.3;}; '              >> /etc/bind/named.conf.local # Se pone la ip del primario 
echo "};"                                        >> /etc/bind/named.conf.local

echo ""                                          >> /etc/bind/named.conf.local

# Zona que recibo delegada de lubuntu
echo 'zone "ssoo.asir6" {'                       >> /etc/bind/named.conf.local
echo "      type master;"                        >> /etc/bind/named.conf.local
echo '      file "/etc/bind/db.ssoo.asir6"; '    >> /etc/bind/named.conf.local
echo "};"                                        >> /etc/bind/named.conf.local


###################################################
###-----Crear configuración de la delegación-----##
###################################################
touch /etc/bind/db.ssoo.asir6

echo ";"                                                      >  /etc/bind/db.ssoo.asir6 
echo '"$TTL"    86400'                                        >> /etc/bind/db.ssoo.asir6
echo "@     IN  SOA  dns.ssoo.asir6.  adrian.asir6.  ("       >> /etc/bind/db.ssoo.asir6
echo "                             1   ;  Serial"             >> /etc/bind/db.ssoo.asir6
echo "                        604800   ; Refresh"             >> /etc/bind/db.ssoo.asir6
echo "                         86400   ; Retry"               >> /etc/bind/db.ssoo.asir6
echo "                       2419200   ; Expire"              >> /etc/bind/db.ssoo.asir6
echo "                         86400 ) ; Negative Cache TTL"  >> /etc/bind/db.ssoo.asir6
echo ";"                                                      >> /etc/bind/db.ssoo.asir6
echo "@     IN  NS   dns.ssoo.asir6."                         >> /etc/bind/db.ssoo.asir6
echo "dns   IN  A    10.33.6.2"                               >> /etc/bind/db.ssoo.asir6
echo "pc1   IN  A    10.33.6.109"                             >> /etc/bind/db.ssoo.asir6
echo "pc2   IN  A    10.33.6.110"                             >> /etc/bind/db.ssoo.asir6

###################################################
###--Resolver nosotros mismos para la delegación-##
###################################################
echo "nameserver 10.33.6.3" > /etc/resolv.conf

named-checkconf

systemctl restart bind9