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
web_dir=/var/fp
apache2Conf=/etc/apache2/apache2.conf
sitesAvailable=/etc/apache2/sites-available
logs=/var/fp/logs
surround=/home/surround

# Creacion de directorios necesarios
if ! [ -d $web_dir/sonido ]; then
    mkdir -p $web_dir/sonido
fi
if ! [ -d $surround ]; then
    mkdir -p $surround
fi


# Agregar el directorio sonido a los permisos de apache
if [ "$(grep -cw "<Directory $web_dir/sonido>" $apache2Conf)" -eq 0 ]; then
  echo "<Directory $web_dir/sonido>"                          >> $apache2Conf
  echo "  Require all granted"                                >> $apache2Conf
  echo "</Directory>"                                         >> $apache2Conf
fi

# Crear el virtual host de sonido
echo "<VirtualHost 10.33.6.200:80>"                         >  $sitesAvailable/sonido.conf
echo "  ServerName www.sonido.fp"                           >> $sitesAvailable/sonido.conf
echo "  DocumentRoot $web_dir/sonido"                       >> $sitesAvailable/sonido.conf
echo "  Alias /surround $surround"                          >> $sitesAvailable/sonido.conf
echo "  <Directory $surround>"                              >> $sitesAvailable/sonido.conf
echo "    Require all granted"                              >> $sitesAvailable/sonido.conf
echo "    DirectoryIndex index.html"                        >> $sitesAvailable/sonido.conf
echo "    Options Indexes"                                  >> $sitesAvailable/sonido.conf
echo "  </Directory>"                                       >> $sitesAvailable/sonido.conf
echo "</VirtualHost>"                                       >> $sitesAvailable/sonido.conf

echo "Holaa"                                                >  $web_dir/sonido/index.html

echo "Directorio Surround"                                  >  $surround/index.html

# Habilitar los sitios
a2ensite sonido.conf

################################
######---- FIN APACHE ----######
################################
service apache2 restart