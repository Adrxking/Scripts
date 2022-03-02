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

echo "Fin de la instalacion de paquetes"

############################
### CONFIGURACION DE PHP ###
############################

sed -i "s/;date.timezone =/date.timezone = Europe\/Madrid/" /etc/php/7.4/apache2/php.ini

echo "<?php"            >  /var/www/html/index.php
echo "  phpinfo();"     >> /var/www/html/index.php
echo "?>"               >> /var/www/html/index.php

chown www-data -R /var/www/html/logs