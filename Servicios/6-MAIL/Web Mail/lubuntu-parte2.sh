#!/bin/bash
# | VARIABLES | #
webDirLubuntu=/var/www/lubuntu
webDirWindows=/var/www/windows
# | FIN VARIABLES | #

# Descargar roundcube y descomprimir en /var/www/lubuntu
# Descargar roundcube y descomprimir en /var/www/windows

chown www-data:www-data -R $webDirWindows
chown www-data:www-data -R $webDirLubuntu

############################
# CONFIGURACION ROUNDCUBE ##
############################
mv config.inc.php $webDirLubuntu/config/config.inc.php
mv w-config.inc.php $webDirWindows/config/config.inc.php

############################
### REINICIO DE SERVICIOS ##
############################
service apache2 restart
service bind9 restart