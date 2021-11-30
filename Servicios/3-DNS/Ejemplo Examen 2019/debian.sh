#!/bin/bash
###################################################
###-----Crear zonas secundarias y delegación-----##
###################################################

# Cuando es slave el file tiene que ser creado por el proceso bind
# Zona primaria
echo 'zone "lossimpsons.edu" {'                  >  /etc/bind/named.conf.local
echo "      type slave;"                         >> /etc/bind/named.conf.local
echo '      file "db.lossimpsons.edu"; '         >> /etc/bind/named.conf.local
echo '      masters {10.33.6.3;}; '              >> /etc/bind/named.conf.local # Se pone la ip del primario 
echo "};"                                        >> /etc/bind/named.conf.local

echo ""                                          >> /etc/bind/named.conf.local

# Zona inversa
echo 'zone "6.16.172.in-addr.arpa" {'            >> /etc/bind/named.conf.local
echo "      type slave;"                         >> /etc/bind/named.conf.local
echo '      file "db.172.16.6"; '                >> /etc/bind/named.conf.local
echo '      masters {10.33.6.3;}; '              >> /etc/bind/named.conf.local # Se pone la ip del primario 
echo "};"                                        >> /etc/bind/named.conf.local

echo ""                                          >> /etc/bind/named.conf.local

# Subdominio sin delegación, en este caso va incluido en la zona de lossimpsons.edu

# Zona que recibo de wserver
echo 'zone "familia.lossimpsons.edu" {'          >> /etc/bind/named.conf.local
echo "      type slave;"                         >> /etc/bind/named.conf.local
echo '      file "db.familia.lossimpsons.edu"; ' >> /etc/bind/named.conf.local
echo "};"                                        >> /etc/bind/named.conf.local

named-checkconf

systemctl restart bind9

ls -al /var/cache/bind