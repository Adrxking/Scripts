#!/bin/bash
# 1. Modo Pasivo
# 2. FTPS explicito (requerido)
# 3. Usuarios virtuales con una BBDD MySQL o María DB y confinados
# 4. Se permite acceso anónimo
# 5. Instalado detrás de un router IPFire
# 6. Abrir rango de puertos en el IPFire con los puertos asignados para la forma pasiva (31001-32000)

#####################################
######----- INSTALACIONES -----######
#####################################
apt update
apt install -y proftpd mariadb-server proftpd-mod-mysql filezilla expect
apt install -y proftpd-mod-crypto

#####################################
######---- 0. BASIC CONFIG ----######
#####################################

# Si el servicio no inicia debemos cargar el módulo mod_ident.c
# echo "LoadModule mod_ident.c" >> /etc/proftpd/modules.conf

sed -i "s/UseIPv6 on/UseIPv6 off/" /etc/proftpd/proftpd.conf

#####################################
######---- 1. MODO PASIVO -----######
#####################################
sed -i "s/# PassivePorts 49152 65534/PassivePorts 31001 32000/" /etc/proftpd/proftpd.conf
# ip de la pública de nuestro router (Tarjeta roja)
sed -i "s/# MasqueradeAddress 1.2.3.4/MasqueradeAddress 192.168.7.206/" /etc/proftpd/proftpd.conf 


#####################################
######--- 2. FTPS explicito ---######
#####################################
openssl req -x509 -newkey rsa:2048 -keyout /etc/ssl/private/cert.key -out /etc/ssl/certs/cert.crt -nodes -days 365

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
sed -i "s/#LoadModule mod_tls_memcache.c/LoadModule mod_tls_memcache.c/" /etc/proftpd/modules.conf
sed -i "s/#LoadModule mod_tls.c/LoadModule mod_tls.c/" /etc/proftpd/modules.conf
sed -i "s/#LoadModule mod_tls_fscache.c/LoadModule mod_tls_fscache.c/" /etc/proftpd/modules.conf
sed -i "s/#LoadModule mod_tls_shmcache.c/LoadModule mod_tls_shmcache.c/" /etc/proftpd/modules.conf

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
##-- 4. Se permite acceso anónimo -##
#####################################

mkdir /var/ftp/publico

echo ""                                 >> /etc/proftpd/proftpd.conf
# Ejemplo configuración anónima
echo "<Anonymous /var/ftp/publico>"     >> /etc/proftpd/proftpd.conf

echo "  User   ftp"                     >> /etc/proftpd/proftpd.conf
echo "  Group  nogroup"                 >> /etc/proftpd/proftpd.conf
echo "  UserAlias  anonymous ftp"       >> /etc/proftpd/proftpd.conf
echo "  DirFakeUser  on ftp"            >> /etc/proftpd/proftpd.conf
echo "  DirFakeGroup  on ftp"           >> /etc/proftpd/proftpd.conf

echo "  RequireValidShell   off"        >> /etc/proftpd/proftpd.conf
echo "  MaxClients  10"                 >> /etc/proftpd/proftpd.conf

echo "  <Directory *>"                  >> /etc/proftpd/proftpd.conf
echo "      <Limit WRITE>"              >> /etc/proftpd/proftpd.conf
echo "          Deny all"               >> /etc/proftpd/proftpd.conf
echo "      </Limit>"                   >> /etc/proftpd/proftpd.conf
echo "  </Directory>"                   >> /etc/proftpd/proftpd.conf

echo "</Anonymous>"                     >> /etc/proftpd/proftpd.conf

echo ""                                 >> /etc/proftpd/proftpd.conf

#####################################
####--- 5. Restart service :) ---####
#####################################
service proftpd restart