# Configurar las interfaces

#!/bin/bash
# Instalar paquetes
apt update -y
apt install bind9 -y
apt install nmap -y

echo ""                                               >> /etc/bind/named.conf.local

# Crear Slave del lubuntu
echo "zone \"barriosesamo.edu\" {"                    >> /etc/bind/named.conf.local
echo "      type slave;"                              >> /etc/bind/named.conf.local
echo "      file \"db.barriosesamo.edu\"; "           >> /etc/bind/named.conf.local
echo "      masters {10.33.6.3;}; "                   >> /etc/bind/named.conf.local
echo "};"                                             >> /etc/bind/named.conf.local

echo ""                                               >> /etc/bind/named.conf.local

# Crear Slave del lubuntu
echo "zone \"quiosco.barriosesamo.edu\" {"            >> /etc/bind/named.conf.local
echo "      type slave;"                              >> /etc/bind/named.conf.local
echo "      file \"db.quiosco.barriosesamo.edu\"; "   >> /etc/bind/named.conf.local
echo "      masters {10.33.6.3;}; "                   >> /etc/bind/named.conf.local
echo "};"                                             >> /etc/bind/named.conf.local

echo ""                                               >> /etc/bind/named.conf.local

# Crear Slave del lubuntu
echo "zone \"laplaza.barriosesamo.edu\" {"            >> /etc/bind/named.conf.local
echo "      type slave;"                              >> /etc/bind/named.conf.local
echo "      file \"db.laplaza.barriosesamo.edu\"; "   >> /etc/bind/named.conf.local
echo "      masters {10.33.6.4;}; "                   >> /etc/bind/named.conf.local
echo "};"                                             >> /etc/bind/named.conf.local

echo ""                                               >> /etc/bind/named.conf.local

# Crear Slave del lubuntu
echo "zone \"6.192.in-addr.arpa\" {"                  >> /etc/bind/named.conf.local
echo "      type slave;"                              >> /etc/bind/named.conf.local
echo "      file \"db.192.6\"; "                      >> /etc/bind/named.conf.local
echo "      masters {10.33.6.3;}; "                   >> /etc/bind/named.conf.local
echo "};"                                             >> /etc/bind/named.conf.local

# Comprobar que se ha transferido todo correctamente
ls -al /var/cache/bind