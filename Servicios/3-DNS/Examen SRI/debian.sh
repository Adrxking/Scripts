#!/bin/bash
###################################################
###-----Crear zonas secundarias y delegación-----##
###################################################

# Cuando es slave el file tiene que ser creado por el proceso bind
# Zona primaria
echo 'zone "juegodetronos.icv" {'                >  /etc/bind/named.conf.local
echo "      type slave;"                         >> /etc/bind/named.conf.local
echo '      file "db.juegodetronos.icv"; '       >> /etc/bind/named.conf.local
echo '      masters {10.6.0.2;}; '               >> /etc/bind/named.conf.local
echo "};"                                        >> /etc/bind/named.conf.local

echo ""                                          >> /etc/bind/named.conf.local

# Zona inversa
echo 'zone "6.10.in-addr.arpa" {'                >> /etc/bind/named.conf.local
echo "      type slave;"                         >> /etc/bind/named.conf.local
echo '      file "db.10.6"; '                    >> /etc/bind/named.conf.local
echo '      masters {10.6.0.2;}; '               >> /etc/bind/named.conf.local
echo "};"                                        >> /etc/bind/named.conf.local

echo ""                                          >> /etc/bind/named.conf.local

# Subdominio sin delegación, en este caso va incluido en la zona de juegodetronos.icv

# Zona que recibo de wserver
echo 'zone "hierro.juegodetronos.icv" {'          >> /etc/bind/named.conf.local
echo "      type slave;"                          >> /etc/bind/named.conf.local
echo '      file "db.hierro.juegodetronos.icv"; ' >> /etc/bind/named.conf.local
echo '      masters {10.6.0.3;}; '                >> /etc/bind/named.conf.local
echo "};"                                         >> /etc/bind/named.conf.local

named-checkconf

systemctl restart bind9

ls -al /var/cache/bind