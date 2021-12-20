#!/bin/bash

apt install proftpd

# Si el servicio no inicia debemos cargar el módulo mod_ident.c
# echo "LoadModule mod_ident.c" >> /etc/proftpd/modules.conf

adduser --home /var/ftp/tres/user_tres --shell /bin/false user_tres
adduser --home /var/ftp/cuatro/user_cuatro --shell /bin/false user_cuatro

###################################################
########-------CONFIGURACIÓN PROFTPD-------########
###################################################
# Permitir el acceso solo a usuarios en concreto
echo "<Limit Login>"            >> /etc/proftpd/proftpd.conf
echo "  AllowUser usuario"      >> /etc/proftpd/proftpd.conf
echo "  DenyAll"                >> /etc/proftpd/proftpd.conf
echo "</Limit>"                 >> /etc/proftpd/proftpd.conf

echo ""                         >> /etc/proftpd/proftpd.conf

# No requerir que los usuarios tengan una shell válida
sed -i "s/# RequireValidShelloff/RequireValidShell off/" /etc/proftpd/proftpd.conf

# Confinar a los usuarios en su home
sed -i "s/# DefaultRoot~/DefaultRoot ~/" /etc/proftpd/proftpd.conf

# Banear IP's
echo "<Limit Login>"            >> /etc/proftpd/proftpd.conf
echo "  Order Deny,Allow"       >> /etc/proftpd/proftpd.conf
echo "  Deny 10.33.6.99"        >> /etc/proftpd/proftpd.conf
echo "  Allow from all"         >> /etc/proftpd/proftpd.conf
echo "</Limit>"                 >> /etc/proftpd/proftpd.conf

echo ""                         >> /etc/proftpd/proftpd.conf

# Limitar permiso de escritura en directorio
echo "<Directory /home/juan>"           >> /etc/proftpd/proftpd.conf
echo "  <Limit Write>"                  >> /etc/proftpd/proftpd.conf
echo "      Deny all"                   >> /etc/proftpd/proftpd.conf
echo "  </Limit>"                       >> /etc/proftpd/proftpd.conf
echo "</Directory>"                     >> /etc/proftpd/proftpd.conf

echo ""                         >> /etc/proftpd/proftpd.conf

# Limitar permiso de transferencias en directorio
echo "<Directory /home/juan>"           >> /etc/proftpd/proftpd.conf
echo "  <Limit STOR>"                   >> /etc/proftpd/proftpd.conf
echo "      Deny all"                   >> /etc/proftpd/proftpd.conf
echo "  </Limit>"                       >> /etc/proftpd/proftpd.conf
echo "</Directory>"                     >> /etc/proftpd/proftpd.conf

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

# Permitir hosts virtuales
sed -i "s/#Include \/etc\/proftpd\/virtuals.conf/Include \/etc\/proftpd\/virtuals.conf/" /etc/proftpd/proftpd.conf

# Ejemplo de Host Virtuales
echo "<VirtualHost 10.33.6.3>"                           >> /etc/proftpd/virtuals.conf
echo "  Port 21"                                         >> /etc/proftpd/proftpd.conf
echo "  RequireValidShell   off"                         >> /etc/proftpd/proftpd.conf
echo "  DefaultRoot   /var/ftp/tres"                     >> /etc/proftpd/proftpd.conf
echo "</VirtualHost>"                                    >> /etc/proftpd/proftpd.conf

echo "<IfModule mod_vroot.c>"                            >> /etc/proftpd/proftpd.conf
echo "</IfModule>"                                       >> /etc/proftpd/proftpd.conf