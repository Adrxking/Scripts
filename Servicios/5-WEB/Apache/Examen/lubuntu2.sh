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

if [ -f /etc/apache2/sites-enabled/000-default.conf ]; then
    rm /etc/apache2/sites-enabled/000-default.conf
fi

# Declaracion de variables
web_dir=/var/ciclos
apache2Conf=/etc/apache2/apache2.conf
sitesAvailable=/etc/apache2/sites-available
logs=/var/ciclos/logs
apuntes=/home/ciclosmr/apuntes

# Creacion de directorios necesarios
if ! [ -d $web_dir/ciclosmr ]; then
    mkdir -p $web_dir/ciclosmr
fi
if ! [ -d $apuntes ]; then
    mkdir -p $apuntes
fi
if ! [ -d $logs ]; then
    mkdir -p $logs
fi

# Agregar el directorio ciclosmr a los permisos de apache
if [ "$(grep -cw "<Directory $web_dir/ciclosmr>" $apache2Conf)" -eq 0 ]; then
  echo "<Directory $web_dir/ciclosmr>"                        >> $apache2Conf
  echo "  Require all granted"                                >> $apache2Conf
  echo "</Directory>"                                         >> $apache2Conf
fi

# Crear el virtual host de ciclosmr
echo "<VirtualHost 10.33.6.55:80>"                          >  $sitesAvailable/ciclosmr.conf
echo "  ServerName www.ciclosmr.edu"                        >> $sitesAvailable/ciclosmr.conf
echo "  DocumentRoot $web_dir/ciclosmr"                     >> $sitesAvailable/ciclosmr.conf
echo "  Alias /apuntes $apuntes"                            >> $sitesAvailable/ciclosmr.conf
echo "  <Directory $apuntes>"                               >> $sitesAvailable/ciclosmr.conf
echo "    Require all granted"                              >> $sitesAvailable/ciclosmr.conf
echo "    DirectoryIndex index.html"                        >> $sitesAvailable/ciclosmr.conf
echo "    Options Indexes"                                  >> $sitesAvailable/ciclosmr.conf
echo "  </Directory>"                                       >> $sitesAvailable/ciclosmr.conf
echo "  ErrorLog $logs/error-smr.log"                       >> $sitesAvailable/ciclosmr.conf
echo "  CustomLog $logs/access-smr.log combined"            >> $sitesAvailable/ciclosmr.conf
echo "</VirtualHost>"                                       >> $sitesAvailable/ciclosmr.conf

echo "Holaa"                                                >  $web_dir/ciclosmr/index.html

echo "Directorio Apuntes"                                   >  $apuntes/index.html

# Habilitar los sitios
a2ensite ciclosmr.conf

################################
######---- FIN APACHE ----######
################################
service apache2 restart