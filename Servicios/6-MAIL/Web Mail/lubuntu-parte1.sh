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
dnsWebmailDb=/etc/bind/db.webmail.icv

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

echo ""                                                       >> $namedLocal

echo "zone \"webmail.icv\" {"                                 >> $namedLocal
echo "  type master;"                                         >> $namedLocal
echo "  file \"/etc/bind/db.webmail.icv\";"                   >> $namedLocal
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

echo ";"                                                      >  $dnsWebmailDb
echo '$TTL    86400'                                          >> $dnsWebmailDb
echo "@     IN  SOA  dns.picapiedra.icv.  adrian.  ("         >> $dnsWebmailDb
echo "                             1   ;  Serial"             >> $dnsWebmailDb
echo "                        604800   ; Refresh"             >> $dnsWebmailDb
echo "                         86400   ; Retry"               >> $dnsWebmailDb
echo "                       2419200   ; Expire"              >> $dnsWebmailDb
echo "                         86400 ) ; Negative Cache TTL"  >> $dnsWebmailDb
echo ";"                                                      >> $dnsWebmailDb
echo "@                 IN  NS        dns.picapiedra.icv."    >> $dnsWebmailDb
echo "dns               IN  A         10.33.6.3"              >> $dnsWebmailDb
echo "lubuntu           IN  A         10.33.6.3"              >> $dnsWebmailDb
echo "windows           IN  A         10.33.6.3"              >> $dnsWebmailDb

### REINICIO DEL SERVICIO ###
service bind9 restart

echo "Fin de la configuración de bind9"

############################
### CONFIGURACION DE PHP ###
############################
sed -i "s/;date.timezone =/date.timezone = Europe\/Madrid/" /etc/php/7.4/apache2/php.ini

############################
### CONFIGURACION APACHE ###
############################
# | VARIABLES | #
webDirLubuntu=/var/www/lubuntu
webDirWindows=/var/www/windows
apache2Conf=/etc/apache2/apache2.conf
sitesAvailable=/etc/apache2/sites-available
# | FIN VARIABLES | #

if ! [ -d $webDirLubuntu ]; then
    mkdir -p $webDirLubuntu
fi

if ! [ -d $webDirWindows ]; then
    mkdir -p $webDirWindows
fi

################################
###- CREAR LOS VIRTUALHOST --###
################################
# Crear el virtual host de windows
echo "<VirtualHost 10.33.6.3:80>"                           >  $sitesAvailable/windows.conf
echo "  ServerName windows.webmail.icv"                     >> $sitesAvailable/windows.conf
echo "  DocumentRoot $webDirWindows"                        >> $sitesAvailable/windows.conf
echo "  <Directory $webDirWindows>"                         >> $sitesAvailable/windows.conf
echo "      DirectoryIndex index.php"                       >> $sitesAvailable/windows.conf
echo "      Options FollowSymLinks Multiviews"              >> $sitesAvailable/windows.conf
echo "  </Directory>"                                       >> $sitesAvailable/windows.conf
echo "</VirtualHost>"                                       >> $sitesAvailable/windows.conf

# Crear el virtual host de lubuntu
echo "<VirtualHost 10.33.6.3:80>"                           >  $sitesAvailable/lubuntu.conf
echo "  ServerName lubuntu.webmail.icv"                     >> $sitesAvailable/lubuntu.conf
echo "  DocumentRoot $webDirLubuntu"                        >> $sitesAvailable/lubuntu.conf
echo "  <Directory $webDirLubuntu>"                         >> $sitesAvailable/lubuntu.conf
echo "      DirectoryIndex index.php"                       >> $sitesAvailable/lubuntu.conf
echo "      Options FollowSymLinks Multiviews"              >> $sitesAvailable/lubuntu.conf
echo "  </Directory>"                                       >> $sitesAvailable/lubuntu.conf
echo "</VirtualHost>"                                       >> $sitesAvailable/lubuntu.conf

# Habilitar los sitios
a2ensite lubuntu.conf windows.conf

############################
### CONFIGURACION MARIADB ##
############################
mysql -u root < mysql.sql

# Descargar roundcube y descomprimir en /var/www/html/lubuntu
# Descargar roundcube y descomprimir en /var/www/html/windows