# * 1.  Instalar y configurar un equipo con la distribución IPCop con las siguientes características:
    # * - Tarjeta ROJA - IP estática de la red del aula.
    # * - Tarjeta VERDE - Primera dirección IP de la LAN, por ejemplo, 10.33.6.1
    # * - Tarjeta NARANJA - Primera dirección IP de la DMZ, por ejemplo 10.33.106.1
    # * - Configuración de las reglas NAT para dirigir el tráfico por el puerto 80 desde la WAN a la DMZ.

# * 2.  Instalar y configurar un equipo en la DMZ con la distribución Debian con las siguientes características:
    # * - Una interfaz de red (ens6) con una dirección IP de la DMZ.
    # * - Un servidor Apache 2.4 con un proxy inverso que redirija las peticiones al servidor Web que estará ubicado en la LAN.

# * 3.  Instalar y configurar un equipo en la LAN con la distribución Ubuntu server 18 con las siguientes características:
    # * - Una interfaz de red (ens6) con una dirección IP de la LAN.
    # * - Un servidor Apache 2.4 con un servidor Web que atiende las peticiones que le pasa el proxy con un gestor de contenidos o una plataforma educativa, por ejemplo Joomla o Moodle.

# * 4.  Comprobar que desde la red del aula se puede acceder al gestor de contenidos o plataforma educativa.

# * 5.  Documentar la práctica.

#! IP DEL LUBUNTU DMZ: 10.33.106.3

#!/bin/bash
################################
##--- Configuracion Apache ---##
################################
# Comprobar si apache2 esta instalado, si no lo instala
REQUIRED_PKG="apache2"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi

# Declaracion de variables
web_dir=/var/fp
apache2Conf=/etc/apache2/apache2.conf
sitesAvailable=/etc/apache2/sites-available
logs=/var/fp/logs

###########################################
###-- CREAR VIRTUALHOST PROXY INVERSO --###
###########################################
# Crear el virtual host de informatica
echo "<VirtualHost 10.33.106.3:80>"                         >  $sitesAvailable/proxy.conf
echo "  ProxyPass / http://10.33.6.3/"                      >> $sitesAvailable/proxy.conf
echo "  ProxyPassReverse / http://10.33.6.3/"               >> $sitesAvailable/proxy.conf
echo "  ProxyPreserveHost on"                               >> $sitesAvailable/proxy.conf
echo "</VirtualHost>"                                       >> $sitesAvailable/proxy.conf


# Habilitar los modulos para proxy reverso
a2enmod proxy_html
a2enmod proxy_http

# Habilitar los sitios
a2ensite proxy.conf

################################
######---- FIN APACHE ----######
################################
service apache2 restart