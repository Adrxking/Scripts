# * IP Router (Ipfire): 10.33.6.1 * #
# * IP DNS Primario (WServer): 10.33.6.4 * #
# * IP DNS Secundario Debian: 10.33.6.2 * #
# * IP DNS Secundario Lubuntu 2019: 10.33.6.3 * #

# Configurar las interfaces

#!/bin/bash
# Instalar paquetes
apt update -y
apt install bind9 -y
apt install nmap -y

echo ""                                               >> /etc/bind/named.conf.local

# Crear Slave del WServer
echo "zone \"pericodelospalotes.edu\" {"              >> /etc/bind/named.conf.local
echo "      type slave;"                              >> /etc/bind/named.conf.local
echo "      file \"db.pericodelospalotes.edu\"; "     >> /etc/bind/named.conf.local
echo "      masters {10.33.6.4;}; "                   >> /etc/bind/named.conf.local
echo "};"                                             >> /etc/bind/named.conf.local

echo ""                                               >> /etc/bind/named.conf.local

# Crear Slave del WServer zona Inversa
echo "zone \"6.33.10.in-addr.arpa\" {"                >> /etc/bind/named.conf.local
echo "      type slave;"                              >> /etc/bind/named.conf.local
echo "      file \"db.10.33.6\"; "                    >> /etc/bind/named.conf.local
echo "      masters {10.33.6.4;}; "                   >> /etc/bind/named.conf.local
echo "};"                                             >> /etc/bind/named.conf.local

# Comprobar que se ha transferido todo correctamente
#ls -al /var/cache/bind