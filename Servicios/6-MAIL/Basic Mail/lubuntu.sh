#!/bin/bash
############################
### INSTALACIÓN PAQUETES ###
############################
REQUIRED_PKG="bind9"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
    echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
    sudo apt-get --yes install $REQUIRED_PKG
fi
REQUIRED_PKG="dns-utils"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
    echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
    sudo apt-get --yes install $REQUIRED_PKG
fi
REQUIRED_PKG="mailutils"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
    echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
    sudo apt-get --yes install $REQUIRED_PKG
fi

############################
### CONFIGURACION BIND9  ###
############################
# * RECUERDA PONER EL DNS CORRECTO
namedLocal=/etc/bind/named.conf.local

echo "zone \"midominio.icv\" {"                               >  $namedLocal
echo "  type master;"                                         >> $namedLocal
echo "  file \"/etc/bind/db.midominio.icv\";"                 >> $namedLocal
echo "};"                                                     >> $namedLocal

echo ";"                                                      >  /etc/bind/db.midominio.icv
echo '$TTL    86400'                                          >> /etc/bind/db.midominio.icv
echo "@     IN  SOA  dns.midominio.icv.  adrian.  ("          >> /etc/bind/db.midominio.icv
echo "                             1   ;  Serial"             >> /etc/bind/db.midominio.icv
echo "                        604800   ; Refresh"             >> /etc/bind/db.midominio.icv
echo "                         86400   ; Retry"               >> /etc/bind/db.midominio.icv
echo "                       2419200   ; Expire"              >> /etc/bind/db.midominio.icv
echo "                         86400 ) ; Negative Cache TTL"  >> /etc/bind/db.midominio.icv
echo ";"                                                      >> /etc/bind/db.midominio.icv
echo "@                 IN  NS   dns.midominio.icv."          >> /etc/bind/db.midominio.icv
echo "dns               IN  A         10.33.6.3"              >> /etc/bind/db.midominio.icv
echo "@                 IN  MX  10    10.33.6.3"              >> /etc/bind/db.midominio.icv
echo "correo            IN  A         10.33.6.3"              >> /etc/bind/db.midominio.icv

service bind9 restart