# * Crear una Debian como DNS Secundario * #
# * IP Debian: 10.33.6.2 * #
# * IP DNS Primario: 10.33.6.3 * #
# * IP Router: 10.33.6.1 * #

#Configurar las interfaces
/etc/network/interfaces

auto lo
iface lo inet loopback

allow-hotplug ens33
iface ens33 inet static
    address 10.33.6.2/24
    gateway 10.33.6.1
    dns-nameservers: 8.8.8.8


apt update -y
apt install bind9 -y
apt install nmap -y

# Reiniciar pc

# Comprobar funcionamiento
systemctl status bind9

#!/bin/bash
###################################################
###---------Crear nuestras zonas secundaria------##
###################################################

# Cuando es slave el file tiene que ser creado por el proceso bind
# Zona primaria
echo 'zone "asir6" {'                      > /etc/bind/named.conf.local
echo "      type slave;"                   >> /etc/bind/named.conf.local
echo '      file "db.asir6"; '             >> /etc/bind/named.conf.local
echo '      masters {10.33.6.3;}; '        >> /etc/bind/named.conf.local # Se pone la ip del primario 
echo "};"                                  >> /etc/bind/named.conf.local

# Zona inversa
echo 'zone "6.33.10.in-addr.arpa" {'       > /etc/bind/named.conf.local
echo "      type slave;"                   >> /etc/bind/named.conf.local
echo '      file "db.10.33.6"; '           >> /etc/bind/named.conf.local
echo '      masters {10.33.6.3;}; '        >> /etc/bind/named.conf.local # Se pone la ip del primario 
echo "};"                                  >> /etc/bind/named.conf.local

named-checkconf

systemctl restart bind9