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

REQUIRED_PKG="bind9"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="mariadb-server"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="postfix"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="postfix-mysql"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="dovecot-pop3d"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="dovecot-core"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="dovecot-lmtpd"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="dovecot-imapd"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="dovecot-mysql"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="nmap"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="thunderbird"
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
### CONFIGURACION MYSQL  ###
############################
echo "Iniciada la configuracion de MySQL"
mysql -u root < ./mysql.sql
echo "Fin de la configuracion de MySQL"



##############################
### CONFIGURACION POSTFIX  ###
##############################

### CONFIGURACION DEL USUARIO VMAIL ###
echo "Creando usuario, grupo y directorio de vmail"
# DIRECTORIO DE LOS BUZONES DE CORREO
mkdir -p /var/vmail
# CREAR EL GRUPO VMAIL
groupadd -g 5000 vmail
# CREAR EL USUARIO VMAIL
sudo useradd -g vmail -u 5000 vmail -d /var/vmail -s /bin/false
# PERMISOS PARA EL USUARIO VMAIL
sudo chmod 770 /var/vmail
sudo chown -R vmail:vmail /var/vmail
# COMPROBAR QUE SE CREO CORRECTAMENTE
ls -ld /var/vmail
id -u vmail
id -g vmail
echo "Fin de la creacion del usuario, grupo y directorio de vmail"

### ASOCIACION DE LA BD CON POSTFIX ### 

# ASIGNAR LA TABLA DOMAINS A POSTFIX
echo "Asignando la tabla domains a postfix"
dbConnectionDomains=/etc/postfix/mysql_virtual_mailbox_domains.cf
echo "user = usuariocorreo"                                     >  $dbConnectionDomains
echo "password = usuariocorreo"                                 >> $dbConnectionDomains
echo "hosts = 127.0.0.1"                                        >> $dbConnectionDomains
echo "dbname = correo"                                          >> $dbConnectionDomains
echo "query = SELECT 1 FROM virtual_domains WHERE name='%s'"    >> $dbConnectionDomains
echo "Fin de la asignacion de la BD a postfix"
# COMPROBAR LA ASIGNACION
echo "Comprobando que la conexion de postfix-mariadb es correcta"
echo "Si devuelve un 1 significa que es correcta"
postmap -q aldeagala.icv mysql:$dbConnectionDomains
echo "Fin comprobar la asignacion con la tabla domains"

# ASIGNAR LA TABLA USERS A POSTFIX
echo "Asignando la tabla users a postfix"
dbConnectionUsers=/etc/postfix/mysql_virtual_mailbox_maps.cf
echo "user = usuariocorreo"                                     >  $dbConnectionUsers
echo "password = usuariocorreo"                                 >> $dbConnectionUsers
echo "hosts = 127.0.0.1"                                        >> $dbConnectionUsers
echo "dbname = correo"                                          >> $dbConnectionUsers
echo "query = SELECT 1 FROM virtual_users WHERE email='%s'"     >> $dbConnectionUsers
echo "Fin de la asignacion de la BD a postfix"
# COMPROBAR LA ASIGNACION
echo "Comprobando que la conexion de postfix-mariadb es correcta"
echo "Si devuelve un 1 significa que es correcta"
postmap -q homer@simpsons.icv mysql:$dbConnectionUsers
echo "Fin comprobar la asignacion con la tabla users"

# ASIGNAR LA TABLA ALIAS A POSTFIX
echo "Asignando la tabla alias a postfix"
dbConnectionAlias=/etc/postfix/mysql_virtual_alias_maps.cf
echo "user = usuariocorreo"                                                 >  $dbConnectionAlias
echo "password = usuariocorreo"                                             >> $dbConnectionAlias
echo "hosts = 127.0.0.1"                                                    >> $dbConnectionAlias
echo "dbname = correo"                                                      >> $dbConnectionAlias
echo "query = SELECT destination FROM virtual_aliases WHERE source='%s'"    >> $dbConnectionAlias
echo "Fin de la asignacion de la BD a postfix"
# COMPROBAR LA ASIGNACION
echo "Comprobando que la conexion de postfix-mariadb es correcta"
echo "Si devuelve un correo significa que es correcta"
postmap -q bajito@aldeagala.icv mysql:$dbConnectionAlias
echo "Fin comprobar la asignacion con la tabla Alias"


### CREAR EL ORIGEN DEL MAILNAME ###
echo "usuario-vmwarevirtualplatform" > /etc/mailname


### CONFIGURACION MAIN.CF Y MASTER.CF ###

# CONFIGURACION DEL MAIN.CF
echo "Cambiando el archivo /etc/postfix/main.cf"
mainCf=/etc/postfix/main.cf
cat ./main.cf                                                               >  $mainCf/main.cf 
echo "Fin de la modificacion del archivo /etc/postfix/main.cf"


# CONFIGURACION DEL MASTER.CF
masterCf=/etc/postfix/master.cf
echo "Cambiando el archivo /etc/postfix/master.cf"
cat ./master.cf                                                             >  $masterCf/master.cf
echo "Fin de la modificacion del archivo /etc/postfix/master.cf"

# COMPROBAR LA CONFIGURACION DE POSTFIX
echo "Comprobando la configuracion de Postfix"
postfix check
echo "Fin de la comprobacion de la configuracion de Postfix"

service postfix restart

############################
### DOVECOT CONFIGURATION ##
############################

### CONFIGURACION CARPETA /ETC/DOVECOT/CONF.D ###
dovecotConf=/etc/dovecot/conf.d

# CONFIGURACION DEL 10-AUTH.CONF
echo "Cambiando el archivo /etc/dovecot/conf.d/10-auth.conf"
cat ./10-auth.conf                                                          >  $dovecotConf/10-auth.conf
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/10-auth.conf"

# CONFIGURACION DEL 10-MAIL.CONF
echo "Cambiando el archivo /etc/dovecot/conf.d/10-mail.conf"
cat ./10-mail.conf                                                          >  $dovecotConf/10-mail.conf
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/10-mail.conf"

# CONFIGURACION DEL 10-MASTER.CONF
echo "Cambiando el archivo /etc/dovecot/conf.d/10-master.conf"
cat ./10-master.conf                                                        >  $dovecotConf/10-master.conf
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/10-master.conf"

# CONFIGURACION DEL 10-SSL.CONF
echo "Cambiando el archivo /etc/dovecot/conf.d/10-ssl.conf"
cat ./10-ssl.conf                                                           >  $dovecotConf/10-ssl.conf
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/10-ssl.conf"

# CONFIGURACION DEL 15-LDA.CONF
echo "Cambiando el archivo /etc/dovecot/conf.d/15-lda.conf"
cat ./15-lda.conf                                                           >  $dovecotConf/15-lda.conf
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/15-lda.conf"

# CONFIGURACION DEL AUTH-SQL.CONF.EXT
echo "Cambiando el archivo /etc/dovecot/conf.d/auth-sql.conf.ext"
cat ./auth-sql.conf.ext                                                     >  $dovecotConf/auth-sql.conf.ext
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/auth-sql.conf.ext"

### CONFIGURACION CARPETA /ETC/DOVECOT ###
dovecot=/etc/dovecot

# CONFIGURACION DEL DOVECOT-SQL.CONF.EXT
echo "Cambiando el archivo /etc/dovecot/dovecot-sql.conf.ext"
cat ./dovecot-sql.conf.ext                                                   >  $dovecot/dovecot-sql.conf.ext
echo "Fin de la modificacion del archivo /etc/dovecot/dovecot-sql.conf.ext"

# CONFIGURACION DEL DOVECOT.CONF
echo "Cambiando el archivo /etc/dovecot/dovecot.conf"
cat ./dovecot.conf                                                           >  $dovecot/dovecot.conf
echo "Fin de la modificacion del archivo /etc/dovecot/dovecot.conf"

service dovecot restart