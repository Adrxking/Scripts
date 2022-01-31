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

if [ -f /etc/apache2/sites-enabled/000-default.conf ]; then
    rm /etc/apache2/sites-enabled/000-default.conf
fi

# Crear el virtual host de sonido
echo "<VirtualHost 10.33.6.200:80>"                         >  $sitesAvailable/sonido.conf
echo "  ServerName www.sonido.fp"                           >> $sitesAvailable/sonido.conf
echo "  ProxyPass / http://10.33.6.200/"                    >> $sitesAvailable/sonido.conf # Redirigir la peticion
echo "  ProxyPassReverse / http://10.33.6.200/"             >> $sitesAvailable/sonido.conf # Que la peticion devuelta contenga en la cabecera la ip del servidor proxy (6.3)
echo "  ProxyPreserveHost on"                               >> $sitesAvailable/sonido.conf # Preservar el nombre de dominio en lugar de cambiar la peticion a la ip
echo "</VirtualHost>"                                       >> $sitesAvailable/sonido.conf