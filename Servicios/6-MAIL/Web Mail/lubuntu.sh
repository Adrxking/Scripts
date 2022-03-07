#!/bin/bash
############################
### INSTALACIÓN PAQUETES ###
############################

checkPackage () {
    PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $1|grep "install ok installed")
    echo Checking for $1: $PKG_OK
    if [ "" = "$PKG_OK" ]; then
        echo "No $1. Setting up $1."
        sudo apt-get --yes install $1
    fi
}

echo "Inicio de la instalacion de paquetes"

REQUIRED_PKG="apache2"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="libapache2-mod-php7.4"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="php7.4-curl"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="php7.4-gd"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="php7.4-mbstring"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="php7.4-imap"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="php7.4-xml"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="php-apcu"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="php-mysql"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="zip"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="unzip"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="rar"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="unrar"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="pyzor"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="razor"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="arj"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="cabextract"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="lzop"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="nomarch"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="p7zip-full"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="rpm2cpio"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="tnef"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="unrar-free"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="bzip2"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="cpio"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="file"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="gzip"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="pax"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="mariadb-server"
checkPackage $REQUIRED_PKG

echo "Fin de la instalacion de paquetes"

############################
### CONFIGURACION BIND9  ###
############################
echo "Inicio de la configuracion de Bind9"

# * RECUERDA PONER EL DNS CORRECTO
namedLocal=/etc/bind/named.conf.local
dnsAldeagalaDb=/etc/bind/db.aldeagala.icv
dnsSimpsonsDb=/etc/bind/db.simpsons.icv
dnsBarriosesamoDb=/etc/bind/db.barriosesamo.icv
dnsPicapiedraDb=/etc/bind/db.picapiedra.icv

echo "zone \"aldeagala.icv\" {"                               >  $namedLocal
echo "  type master;"                                         >> $namedLocal
echo "  file \"/etc/bind/db.aldeagala.icv\";"                 >> $namedLocal
echo "};"                                                     >> $namedLocal

echo ""                                                       >> $namedLocal

echo "zone \"simpsons.icv\" {"                                >> $namedLocal
echo "  type master;"                                         >> $namedLocal
echo "  file \"/etc/bind/db.simpsons.icv\";"                  >> $namedLocal
echo "};"                                                     >> $namedLocal

echo ""                                                       >> $namedLocal

echo "zone \"barriosesamo.icv\" {"                            >> $namedLocal
echo "  type master;"                                         >> $namedLocal
echo "  file \"/etc/bind/db.barriosesamo.icv\";"              >> $namedLocal
echo "};"                                                     >> $namedLocal

echo ""                                                       >> $namedLocal

echo "zone \"picapiedra.icv\" {"                              >> $namedLocal
echo "  type master;"                                         >> $namedLocal
echo "  file \"/etc/bind/db.picapiedra.icv\";"                >> $namedLocal
echo "};"                                                     >> $namedLocal

echo ";"                                                      >  $dnsAldeagalaDb
echo '$TTL    86400'                                          >> $dnsAldeagalaDb
echo "@     IN  SOA  dns.aldeagala.icv.  adrian.  ("          >> $dnsAldeagalaDb
echo "                             1   ;  Serial"             >> $dnsAldeagalaDb
echo "                        604800   ; Refresh"             >> $dnsAldeagalaDb
echo "                         86400   ; Retry"               >> $dnsAldeagalaDb
echo "                       2419200   ; Expire"              >> $dnsAldeagalaDb
echo "                         86400 ) ; Negative Cache TTL"  >> $dnsAldeagalaDb
echo ";"                                                      >> $dnsAldeagalaDb
echo "@                 IN  NS        dns.aldeagala.icv."     >> $dnsAldeagalaDb
echo "dns               IN  A         10.33.6.3"              >> $dnsAldeagalaDb
echo "@                 IN  MX  10    correo.aldeagala.icv."  >> $dnsAldeagalaDb
echo "correo            IN  A         10.33.6.3"              >> $dnsAldeagalaDb

echo ";"                                                      >  $dnsSimpsonsDb
echo '$TTL    86400'                                          >> $dnsSimpsonsDb
echo "@     IN  SOA  dns.simpsons.icv.  adrian.  ("           >> $dnsSimpsonsDb
echo "                             1   ;  Serial"             >> $dnsSimpsonsDb
echo "                        604800   ; Refresh"             >> $dnsSimpsonsDb
echo "                         86400   ; Retry"               >> $dnsSimpsonsDb
echo "                       2419200   ; Expire"              >> $dnsSimpsonsDb
echo "                         86400 ) ; Negative Cache TTL"  >> $dnsSimpsonsDb
echo ";"                                                      >> $dnsSimpsonsDb
echo "@                 IN  NS        dns.simpsons.icv."      >> $dnsSimpsonsDb
echo "dns               IN  A         10.33.6.3"              >> $dnsSimpsonsDb
echo "@                 IN  MX  10    correo.simpsons.icv."   >> $dnsSimpsonsDb
echo "correo            IN  A         10.33.6.3"              >> $dnsSimpsonsDb

echo ";"                                                       >  $dnsBarriosesamoDb
echo '$TTL    86400'                                           >> $dnsBarriosesamoDb
echo "@     IN  SOA  dns.barriosesamo.icv.  adrian.  ("        >> $dnsBarriosesamoDb
echo "                             1   ;  Serial"              >> $dnsBarriosesamoDb
echo "                        604800   ; Refresh"              >> $dnsBarriosesamoDb
echo "                         86400   ; Retry"                >> $dnsBarriosesamoDb
echo "                       2419200   ; Expire"               >> $dnsBarriosesamoDb
echo "                         86400 ) ; Negative Cache TTL"   >> $dnsBarriosesamoDb
echo ";"                                                       >> $dnsBarriosesamoDb
echo "@                 IN  NS        dns.barriosesamo.icv."   >> $dnsBarriosesamoDb
echo "dns               IN  A         10.33.6.3"               >> $dnsBarriosesamoDb
echo "@                 IN  MX  10    correo.barriosesamo.icv.">> $dnsBarriosesamoDb
echo "correo            IN  A         10.33.6.5"               >> $dnsBarriosesamoDb

echo ";"                                                      >  $dnsPicapiedraDb
echo '$TTL    86400'                                          >> $dnsPicapiedraDb
echo "@     IN  SOA  dns.picapiedra.icv.  adrian.  ("         >> $dnsPicapiedraDb
echo "                             1   ;  Serial"             >> $dnsPicapiedraDb
echo "                        604800   ; Refresh"             >> $dnsPicapiedraDb
echo "                         86400   ; Retry"               >> $dnsPicapiedraDb
echo "                       2419200   ; Expire"              >> $dnsPicapiedraDb
echo "                         86400 ) ; Negative Cache TTL"  >> $dnsPicapiedraDb
echo ";"                                                      >> $dnsPicapiedraDb
echo "@                 IN  NS        dns.picapiedra.icv."    >> $dnsPicapiedraDb
echo "dns               IN  A         10.33.6.3"              >> $dnsPicapiedraDb
echo "@                 IN  MX  10    correo.picapiedra.icv." >> $dnsPicapiedraDb
echo "correo            IN  A         10.33.6.5"              >> $dnsPicapiedraDb

### REINICIO DEL SERVICIO ###
service bind9 restart

echo "Fin de la configuración de bind9"

############################
### CONFIGURACION DE PHP ###
############################

# | VARIABLES | #
webDir=/var/www/html
# | FIN VARIABLES | #


sed -i "s/;date.timezone =/date.timezone = Europe\/Madrid/" /etc/php/7.4/apache2/php.ini

echo "<?php"            >  $webDir/index.php
echo "  phpinfo();"     >> $webDir/index.php
echo "?>"               >> $webDir/index.php

# Descargar roundcube y descomprimir en /var/www/html

chown www-data:www-data -R $webDir

############################
### CONFIGURACION MARIADB ##
############################
mysql -u root < mysql.sql

############################
# CONFIGURACION ROUNDCUBE ##
############################
cp config.inc.php $web_dir/config/

############################
### REINICIO DE SERVICIOS ##
############################
service apache2 restart