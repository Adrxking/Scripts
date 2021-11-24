#!/bin/bash

apt install proftpd

# Si el servicio no inicia debemos cargar el módulo mod_ident.c
# echo "LoadModule mod_ident.c" >> /etc/proftpd/modules.conf

###################################################
########-------CONFIGURACIÓN PROFTPD-------########
###################################################
echo "<Limit Login>" >> /etc/proftpd/proftpd.conf
echo "  AllowUser usuario" >> /etc/proftpd/proftpd.conf
echo "  DenyAll" >> /etc/proftpd/proftpd.conf
echo "</Limit>" >> /etc/proftpd/proftpd.conf

sed -i "s/# RequireValidShelloff/RequireValidShell off/" /etc/proftpd/proftpd.conf