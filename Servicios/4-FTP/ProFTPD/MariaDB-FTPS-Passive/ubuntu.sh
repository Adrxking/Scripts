#!/bin/bash
# 1. Modo Pasivo
# 2. FTPS explicito (requerido)
# 3. Usuarios virtuales con una BBDD MySQL o María DB y confinados
# 4. No se permite acceso anónimo
# 5. Instalado detrás de un router IPFire

#####################################
######----- INSTALACIONES -----######
#####################################
apt update
apt install -y proftpd mariadb-server proftpd-mod-mysql filezilla expect

#####################################
######---- 0. BASIC CONFIG ----######
#####################################
sed -i "s/UseIPv6 on/UseIPv6 off/" /etc/proftpd/proftpd.conf

#####################################
######---- 1. MODO PASIVO -----######
#####################################
sed -i "s/# PassivePorts 49152 65534/PassivePorts 49152 65534/" /etc/proftpd/proftpd.conf
# ip de la pública de nuestro router (Tarjeta roja)
sed -i "s/# MasqueradeAddress 1.2.3.4/MasqueradeAddress 192.168.7.206/" /etc/proftpd/proftpd.conf 


#####################################
######--- 2. FTPS explicito ---######
#####################################
bash script.exp

echo "<IfModule mod_tls.c>"                                                >  /etc/proftpd/tls.conf
echo "    TLSEngine                           on"                          >> /etc/proftpd/tls.conf
echo "    TLSLog                              /var/log/proftpd/tls.log"    >> /etc/proftpd/tls.conf
echo "    TLSProtocol                         SSLv23"                      >> /etc/proftpd/tls.conf
echo "    TLSRSACertificateFile               /etc/ssl/certs/cert.crt"     >> /etc/proftpd/tls.conf
echo "    TLSRSACertificateKeyFile            /etc/ssl/private/cert.key"   >> /etc/proftpd/tls.conf
echo "    TLSOptions                          NoSessionReuseRequired"      >> /etc/proftpd/tls.conf
echo "    TLSOptions                          AllowClientRenegotiations"   >> /etc/proftpd/tls.conf
echo "    TLSVerifyClient                     off"                         >> /etc/proftpd/tls.conf
echo "    TLSRequired                         on"                          >> /etc/proftpd/tls.conf
echo "    TLSRenegotiate                      required off"                >> /etc/proftpd/tls.conf
echo "</IfModule>"                                                         >> /etc/proftpd/tls.conf

sed -i "s/#Include \/etc\/proftpd\/tls.conf/Include \/etc\/proftpd\/tls.conf/" /etc/proftpd/proftpd.conf

#####################################
####--- 3. Usuarios virtuales ---####
#####################################
groupadd -g 2001 ftpgroup
useradd -u 2001 -s /bin/false -d /bin/null -g ftpgroup ftpuser

mysql -u root < conf.sql

mkdir /var/ftp
cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.original

sed -i "s/# RequireValidShelloff/RequireValidShell off/" /etc/proftpd/proftpd.conf
sed -i "s/User proftpd/User ftpuser/" /etc/proftpd/proftpd.conf
sed -i "s/Group nogroup/Group ftpgroup/" /etc/proftpd/proftpd.conf

sed -i "s/#Include \/etc\/proftpd\/sql.conf/Include \/etc\/proftpd\/sql.conf/" /etc/proftpd/proftpd.conf

sed -i "s/#LoadModule mod_sql.c/LoadModule mod_sql.c/" /etc/proftpd/modules.conf
sed -i "s/#LoadModule mod_sql_mysql.c/LoadModule mod_sql_mysql.c/" /etc/proftpd/modules.conf

cp /etc/proftpd/sql.conf /etc/proftpd/sql.conf.original

echo "<IfModule mod_sql.c>"                                         >  /etc/proftpd/sql.conf
echo ""                                                             >> /etc/proftpd/sql.conf
echo "  SQLBackend mysql"                                           >> /etc/proftpd/sql.conf
echo ""                                                             >> /etc/proftpd/sql.conf
echo "  SQLEngine on"                                               >> /etc/proftpd/sql.conf
echo ""                                                             >> /etc/proftpd/sql.conf
echo "  SQLAuthenticate on"                                         >> /etc/proftpd/sql.conf
echo ""                                                             >> /etc/proftpd/sql.conf
echo "  SQLAuthTypes Crypt Plaintext"                               >> /etc/proftpd/sql.conf
echo ""                                                             >> /etc/proftpd/sql.conf
 # Parámetros para la conecxion con el servidor MySQL
 # basedatos@servidor usuario password
echo "  SQLConnectInfo ftp@localhost proftpd proftpd"               >> /etc/proftpd/sql.conf
echo ""                                                             >> /etc/proftpd/sql.conf
 # Descripción de la tabla de usuarios y sus campos (los que se van a usar)
echo "  SQLUserInfo ftpuser userid passwd uid gid homedir shell"    >> /etc/proftpd/sql.conf
echo ""                                                             >> /etc/proftpd/sql.conf
echo "  SQLGroupInfo ftpgroup groupname gid members"                >> /etc/proftpd/sql.conf
echo ""                                                             >> /etc/proftpd/sql.conf
echo "  CreateHome on"                                              >> /etc/proftpd/sql.conf
echo ""                                                             >> /etc/proftpd/sql.conf
echo "</IfModule>"                                                  >> /etc/proftpd/sql.conf

# No requerir que los usuarios tengan una shell válida
sed -i "s/# RequireValidShelloff/RequireValidShell off/" /etc/proftpd/proftpd.conf

# Confinar a los usuarios en su home
sed -i "s/# DefaultRoot~/DefaultRoot ~/" /etc/proftpd/proftpd.conf

#####################################
## 4. No se permite acceso anónimo ##
#####################################

# * Así está configurado por defecto

#####################################
####--- 5. Restart service :) ---####
#####################################
service proftpd restart