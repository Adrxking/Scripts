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
REQUIRED_PKG="bind9"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="mailutils"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="dovecot-pop3d"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="dovecot-imapd"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="nmap"
checkPackage $REQUIRED_PKG

REQUIRED_PKG="thunderbird"
checkPackage $REQUIRED_PKG

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

##############################
### CONFIGURACION POSTFIX  ###
##############################

### SET OUR DNS SERVER  ###
sed -i "s/mydestination = \$myhostname, usuario-vmwarevirtualplatform, localhost.localdomain, , localhost/mydestination = \$myhostname, usuario-vmwarevirtualplatform, localhost.localdomain, midominio.icv, localhost/" /etc/postfix/main.cf

### SEND MESSAGE  ###
# telnet localhost smtp
#    --> ehlo localhost
#    --> mail from: <usuario@midominio.icv>
#    --> rcpt to: <usuario@midominio.icv>
#    --> data
#    --> Hola.
#    --> Esto es una prueba de correo.
#    --> .
#    --> quit


############################
### DOVECOT CONFIGURATION ##
############################
if [ "$(grep -cw "^disable_plaintext_auth=no" /etc/dovecot/dovecot.conf)" -eq 0 ]; then
    echo "disable_plaintext_auth=no" >> /etc/dovecot/dovecot.conf
fi
if [ "$(grep -cw "^mail_location = mbox:~/mail:INBOX=/var/mail/%u" /etc/dovecot/dovecot.conf)" -eq 0 ]; then
    echo "mail_location = mbox:~/mail:INBOX=/var/mail/%u" >> /etc/dovecot/dovecot.conf
fi

### SEND MESSAGE  ###
# telnet localhost 110
#   --> user usuario
#   --> pass usuario
#   --> list --> Lista de mensajes
#   --> retr 1 --> Obtener el primer mensaje
#   --> quit

# telnet localhost 143
#   --> 1 login usuario usuario
#   --> 2 list "" "*"
#   --> 3 select "INBOX"
#   --> 4 fetch 1 all
#   --> 5 fetch 1 body[]
#   --> 6 fetch 2 all
#   --> 7 fetch 2 body[]
#   --> 8 logout

###########################################
## SEND MESSAGE FROM ONE USER TO ANOTHER ##
###########################################
### CREATE USER  ###
# adduser pepe

### SEND MESSAGE  ###
# telnet localhost 25
#    --> ehlo localhost
#    --> mail from: <usuario@midominio.icv>
#    --> rcpt to: <pepe@midominio.icv>
#    --> data
#    --> Hola.
#    --> Esto es una prueba de correo.
#    --> .
#    --> quit