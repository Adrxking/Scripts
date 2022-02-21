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
mysql -u root < /mysql.sql
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

### CONFIGURACION DEL MAIN.CF ###
echo "Cambiando el archivo /etc/postfix/main.cf"
mainCf=/etc/postfix/main.cf
echo "smtpd_banner = $myhostname ESMTP $mail_name (Ubuntu)"                                 >  $mainCf
echo "biff = no"                                                                            >> $mainCf
echo "append_dot_mydomain = no"                                                             >> $mainCf
echo "readme_directory = no"                                                                >> $mainCf
echo "compatibility_level = 2"                                                              >> $mainCf
echo "# SASL parameters"                                                                    >> $mainCf
echo "# -----------------------"                                                            >> $mainCf
echo "smtpd_sasl_type = dovecot"                                                            >> $mainCf
echo "smtpd_sasl_path = private/auth"                                                       >> $mainCf
echo "smtpd_sasl_auth_enable = yes"                                                         >> $mainCf
echo "broken_sasl_auth_clients = yes"                                                       >> $mainCf
echo "smtpd_sasl_security_options = noanonymous, noplaintext"                               >> $mainCf
echo "smtpd_sasl_local_domain ="                                                            >> $mainCf
echo "smtpd_sasl_authenticated_header = yes"                                                >> $mainCf
echo "# TLS parameters"                                                                     >> $mainCf
echo "# -----------------------"                                                            >> $mainCf
echo "smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem"                             >> $mainCf
echo "smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key"                            >> $mainCf
echo "smtpd_use_tls=yes"                                                                    >> $mainCf
echo "smtpd_tls_security_level = may"                                                       >> $mainCf
echo "smtpd_tls_auth_only = yes"                                                            >> $mainCf
echo "smtpd_sasl_tls_security_options = noanonymous"                                        >> $mainCf
echo "smtpd_tls_loglevel = 1"                                                               >> $mainCf
echo "smtpd_tls_received_header = yes"                                                      >> $mainCf
echo "smtpd_tls_session_cache_timeout = 3600s"                                              >> $mainCf
echo "smtpd_tls_protocols = !SSLv2, !SSLv3"                                                 >> $mainCf
echo "smtpd_tls_ciphers = high"                                                             >> $mainCf
echo "smtp_use_tls=yes"                                                                     >> $mainCf
echo "smtp_tls_security_level = may"                                                        >> $mainCf
echo "smtp_tls_note_starttls_offer = yes"                                                   >> $mainCf
echo "tls_random_source = dev:/dev/urandom"                                                 >> $mainCf
echo "# SMTPD parameters"                                                                   >> $mainCf
echo "# -----------------------"                                                            >> $mainCf
echo "unknown_local_recipient_reject_code = 450"                                            >> $mainCf
echo "maximal_queue_lifetime = 7d"                                                          >> $mainCf
echo "minimal_backoff_time = 1000s"                                                         >> $mainCf
echo "maximal_backoff_time = 8000s"                                                         >> $mainCf
echo "smtp_helo_timeout = 60s"                                                              >> $mainCf
echo "smtpd_recipient_limit = 25"                                                           >> $mainCf
echo "smtpd_error_sleep_time = 1s"                                                          >> $mainCf
echo "smtpd_soft_error_limit = 3"                                                           >> $mainCf
echo "smtpd_hard_error_limit = 12"                                                          >> $mainCf
echo "smtpd_delay_reject = yes"                                                             >> $mainCf
echo "disable_vrfy_command = yes"                                                           >> $mainCf
echo "# HELO Restrictions - Reject - HELO/EHLO information"                                 >> $mainCf
echo "smtpd_helo_required = yes"                                                            >> $mainCf
echo "smtpd_helo_restrictions = permit_mynetworks, warn_if_reject"                          >> $mainCf
echo "reject_non_fqdn_hostname, reject_invalid_hostname, permit"                            >> $mainCf
echo "# Sender Restrictions - Reject - MAIL FROM"                                           >> $mainCf
echo "smtpd_sender_restrictions = permit_mynetworks, permit_sasl_authenticated,"            >> $mainCf
echo "warn_if_reject reject_non_fqdn_sender, reject_authenticated_sender_login_mismatch,"   >> $mainCf
echo "reject_unknown_sender_domain, reject_unauth_pipelining, permit"                       >> $mainCf
echo "# Client Restrictions - Connecting server - Reject client host"                       >> $mainCf
echo "smtpd_client_restrictions = reject_rbl_client sbl.spamhaus.org, reject_rbl_client"    >> $mainCf
echo "blackholes.easynet.nl, reject_rbl_client dnsbl.njabl.org"                             >> $mainCf
echo "# Recipient Restrictions - Reject - RCPT TO"                                          >> $mainCf
echo "smtpd_recipient_restrictions = permit_mynetworks, permit_sasl_authenticated,"         >> $mainCf
echo "reject_non_fqdn_hostname, reject_non_fqdn_sender, reject_non_fqdn_recipient,"         >> $mainCf
echo "reject_unknown_recipient_domain, reject_unauth_destination,"                          >> $mainCf
echo "reject_unauth_pipelining, reject_invalid_hostname, check_policy_service"              >> $mainCf
echo "unix:private/policy-spf, check_policy_service inet:127.0.0.1:10023, permit"           >> $mainCf
echo "# Reject - DATA"                                                                      >> $mainCf
echo "smtpd_data_restrictions = reject_unauth_pipelining"                                   >> $mainCf
echo "# Relay Restrictions - Reject - RCPT TO"                                              >> $mainCf
echo "smtpd_relay_restrictions = permit_mynetworks, reject_unauth_pipelining,"              >> $mainCf
echo "permit_sasl_authenticated, reject_non_fqdn_recipient,"                                >> $mainCf
echo "reject_unknown_recipient_domain, reject_unauth_destination, check_policy_service"     >> $mainCf
echo "unix:private/policy-spf, check_policy_service inet:127.0.0.1:10023, permit"           >> $mainCf
echo "# General parameters"                                                                 >> $mainCf
echo "# -----------------------"                                                            >> $mainCf
echo "myhostname = lubuntu"                                                                 >> $mainCf
echo "alias_maps = hash:/etc/aliases"                                                       >> $mainCf
echo "alias_database = hash:/etc/aliases"                                                   >> $mainCf
echo "myorigin = /etc/mailname"                                                             >> $mainCf
echo "mydestination = localhost"                                                            >> $mainCf
echo "relayhost ="                                                                          >> $mainCf
echo "mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128"                            >> $mainCf
echo "mailbox_size_limit = 0"                                                               >> $mainCf
echo "recipient_delimiter = +"                                                              >> $mainCf
echo "inet_interfaces = all"                                                                >> $mainCf
echo "inet_protocols = all"                                                                 >> $mainCf
echo "mynetworks_style = host"                                                              >> $mainCf
echo "message_size_limit = 10240000"                                                        >> $mainCf
echo "# Dovecot"                                                                            >> $mainCf
echo "# -----------------------"                                                            >> $mainCf
echo "virtual_transport = lmtp:unix:private/dovecot-lmtp"                                   >> $mainCf
echo "# Virtual Mailbox"                                                                    >> $mainCf
echo "# -----------------------"                                                            >> $mainCf
echo "virtual_uid_maps = static:5000"                                                       >> $mainCf
echo "virtual_gid_maps = static:5000"                                                       >> $mainCf
echo "virtual_mailbox_base = /var/vmail"                                                    >> $mainCf
echo "virtual_mailbox_domains = mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf"        >> $mainCf
echo "virtual_mailbox_maps = mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf"              >> $mainCf
echo "virtual_alias_maps = mysql:/etc/postfix/mysql-virtual-alias-maps.cf"                  >> $mainCf
echo "queue_directory = /var/spool/postfix"                                                 >> $mainCf
echo "Fin de la modificacion del archivo /etc/postfix/main.cf"


### CONFIGURACION DEL MASTER.CF ###
masterCf = 

### SET OUR DNS SERVER  ###
sed -i "s/mydestination = \$myhostname, usuario-vmwarevirtualplatform, localhost.localdomain, , localhost/mydestination = \$myhostname, usuario-vmwarevirtualplatform, localhost.localdomain, midominio.icv, localhost/" /etc/postfix/main.cf



############################
### DOVECOT CONFIGURATION ##
############################
if [ "$(grep -cw "^disable_plaintext_auth=no" /etc/dovecot/dovecot.conf)" -eq 0 ]; then
    echo "disable_plaintext_auth=no" >> /etc/dovecot/dovecot.conf
fi
if [ "$(grep -cw "^mail_location = mbox:~/mail:INBOX=/var/mail/%u" /etc/dovecot/dovecot.conf)" -eq 0 ]; then
    echo "mail_location = mbox:~/mail:INBOX=/var/mail/%u" >> /etc/dovecot/dovecot.conf
fi

