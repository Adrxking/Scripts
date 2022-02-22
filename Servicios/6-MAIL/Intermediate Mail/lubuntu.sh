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
dnsDb=/etc/bind/db.midominio.icv

echo "zone \"midominio.icv\" {"                               >  $namedLocal
echo "  type master;"                                         >> $namedLocal
echo "  file \"/etc/bind/db.midominio.icv\";"                 >> $namedLocal
echo "};"                                                     >> $namedLocal

echo ";"                                                      >  $dnsDb
echo '$TTL    86400'                                          >> $dnsDb
echo "@     IN  SOA  dns.midominio.icv.  adrian.  ("          >> $dnsDb
echo "                             1   ;  Serial"             >> $dnsDb
echo "                        604800   ; Refresh"             >> $dnsDb
echo "                         86400   ; Retry"               >> $dnsDb
echo "                       2419200   ; Expire"              >> $dnsDb
echo "                         86400 ) ; Negative Cache TTL"  >> $dnsDb
echo ";"                                                      >> $dnsDb
echo "@                 IN  NS   dns.midominio.icv."          >> $dnsDb
echo "dns               IN  A         10.33.6.3"              >> $dnsDb
echo "@                 IN  MX  10    10.33.6.3"              >> $dnsDb
echo "correo            IN  A         10.33.6.3"              >> $dnsDb

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

### CREAR EL ORIGEN DEL MAILNAME
echo "usuario-vmwarevirtualplatform" > /etc/mailname

### CONFIGURACION MAIN.CF Y MASTER.CF ###

# CONFIGURACION DEL MAIN.CF
echo "Cambiando el archivo /etc/postfix/main.cf"
mainCf=/etc/postfix/main.cf
cat ./main.cf                                                    >  $mainCf
echo "Fin de la modificacion del archivo /etc/postfix/main.cf"


# CONFIGURACION DEL MASTER.CF
masterCf=/etc/postfix/master.cf
echo "Cambiando el archivo /etc/postfix/master.cf"
cat ./master.cf                                                    >  $masterCf
echo "Fin de la modificacion del archivo /etc/postfix/master.cf"

# COMPROBAR LA CONFIGURACION DE POSTFIX
echo "Comprobando la configuracion de Postfix"
postfix check
echo "Fin de la comprobacion de la configuracion de Postfix"

############################
### DOVECOT CONFIGURATION ##
############################

### CONFIGURACION CARPETA /ETC/DOVECOT/CONF.D ###
dovecotConf=/etc/dovecot/conf.d

# CONFIGURACION DEL MASTER.CF
echo "Cambiando el archivo /etc/dovecot/conf.d/10-auth.conf"
cat ./10-auth.conf                                                    >  $dovecotConf/10-auth.conf
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/10-auth.conf"

# CONFIGURACION DEL MASTER.CF
echo "Cambiando el archivo /etc/dovecot/conf.d/10-mail.conf"
cat ./10-mail.conf                                                    >  $dovecotConf/10-mail.conf
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/10-mail.conf"

# CONFIGURACION DEL MASTER.CF
echo "Cambiando el archivo /etc/dovecot/conf.d/10-master.conf"
cat ./10-master.conf                                                    >  $dovecotConf/10-master.conf
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/10-master.conf"

# CONFIGURACION DEL MASTER.CF
echo "Cambiando el archivo /etc/dovecot/conf.d/10-ssl.conf"
cat ./10-ssl.conf                                                    >  $dovecotConf/10-ssl.conf
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/10-ssl.conf"

# CONFIGURACION DEL MASTER.CF
echo "Cambiando el archivo /etc/dovecot/conf.d/15-lda.conf"
cat ./15-lda.conf                                                    >  $dovecotConf/15-lda.conf
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/15-lda.conf"

# CONFIGURACION DEL MASTER.CF
echo "Cambiando el archivo /etc/dovecot/conf.d/auth-sql.conf.ext"
cat ./auth-sql.conf.ext                                                    >  $dovecotConf/auth-sql.conf.ext
echo "Fin de la modificacion del archivo /etc/dovecot/conf.d/auth-sql.conf.ext"

### CONFIGURACION CARPETA /ETC/DOVECOT ###
dovecot=/etc/dovecot

# CONFIGURACION DEL MASTER.CF
echo "Cambiando el archivo /etc/dovecot/dovecot-sql.conf.ext"
cat ./dovecot-sql.conf.ext                                                    >  $dovecot/dovecot-sql.conf.ext
echo "Fin de la modificacion del archivo /etc/dovecot/dovecot-sql.conf.ext"

# CONFIGURACION DEL MASTER.CF
echo "Cambiando el archivo /etc/dovecot/dovecot.conf"
cat ./dovecot.conf                                                    >  $dovecot/dovecot.conf
echo "Fin de la modificacion del archivo /etc/dovecot/dovecot.conf"