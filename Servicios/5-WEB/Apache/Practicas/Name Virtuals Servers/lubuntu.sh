# * --> Lubuntu 18 con dirección IP 10.33.xx.100
# * --> Debian 9 con Hosts virtuales (uno por cada dominio), sobre la misma dirección IP 
# * --> Los dominios son: informatica.fp, metal.fp, madera.fp y sonido.fp.

# * --> informatica.fp (http://www.informatica.fp)
# * document root /var/fp/informatica
• página de inicio: index.html
• no mostrar el contenido del directorio
• acceso sólo desde la red 10.33.xx.0/24 o dominio informatica.fp

# * --> metal (http://www.metal.fp:8000)
• document root /var/fp/metal
• página de inicio: inicio.html
• mostrar contenido del directorio
• acceso desde cualquier red o dominio
• directorio privado accesible sólo para el usuario herrero con password herrero
mediante la url http://www.metal.fp:8000/hierro (configurar sin .htaccess)

# * --> madera.fp (https://www.madera.fp)
• document root: /var/fp/madera
• página de inicio: indice.html
• mostrar contenido del directorio
• directorio privado accesible sólo para el usuario carpintero con password carpintero
mediante la url https://www.madera.fp/carpinteria (configurar con .htaccess)
# * --> sonido.fp (http://www.sonido.fp)
• será redirigido al equipo Debian con dirección IP 10.33.xx.200 mediante un proxy
inverso
• document root: /var/fp/sonido
• directorio /surround alias de /home/surround (se debe configurar con la directiva
Alias)
• página de inicio: index.html
• accesible desde cualquier red o dominio

#!/bin/bash
################################
######------ DNS -------########
################################
# * Comprobar si bind9 esta instalado, si no lo instala
REQUIRED_PKG="bind9"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi
# * RECUERDA PONER EL DNS CORRECTO
namedLocal=/etc/bind/named.conf.local

echo "zone \"fp\" {"                                          >  $namedLocal
echo "  type master;"                                         >> $namedLocal
echo "  file \"/etc/bind/db.fp\";"                            >> $namedLocal
echo "};"                                                     >> $namedLocal

echo ";"                                                      >  /etc/bind/db.fp
echo '$TTL    86400'                                          >> /etc/bind/db.fp
echo "@     IN  SOA  lubuntu.icv.  adrian.  ("                >> /etc/bind/db.fp
echo "                             1   ;  Serial"             >> /etc/bind/db.fp
echo "                        604800   ; Refresh"             >> /etc/bind/db.fp
echo "                         86400   ; Retry"               >> /etc/bind/db.fp
echo "                       2419200   ; Expire"              >> /etc/bind/db.fp
echo "                         86400 ) ; Negative Cache TTL"  >> /etc/bind/db.fp
echo ";"                                                      >> /etc/bind/db.fp
echo "@                 IN  NS   lubuntu.icv."                >> /etc/bind/db.fp
echo "www.informatica   IN  A    10.33.6.3"                   >> /etc/bind/db.fp
echo "www.metal         IN  A    10.33.6.3"                   >> /etc/bind/db.fp
echo "www.madera        IN  A    10.33.6.3"                   >> /etc/bind/db.fp
echo "www.sonido        IN  A    10.33.6.3"                   >> /etc/bind/db.fp

service bind9 restart

################################
##--- Configuracion Apache ---##
################################
# * Comprobar si apache2 esta instalado, si no lo instala
REQUIRED_PKG="apache2"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi

web_dir=/var/fp
apache2Conf=/etc/apache2/apache2.conf
sitesAvailable=/etc/apache2/sites-available
logs=/var/fp/logs

if ! [ -d $web_dir/informatica ]; then
    mkdir -p $web_dir/informatica
fi
if ! [ -d $web_dir/metal ]; then
    mkdir -p $web_dir/metal
fi
if ! [ -d $web_dir/madera ]; then
    mkdir -p $web_dir/madera
fi
if ! [ -d $web_dir/sonido ]; then
    mkdir -p $web_dir/sonido
fi
if ! [ -d $logs ]; then
    mkdir -p $logs
fi

echo "Informatica"      > $web_dir/informatica/index.html
echo "metal"            > $web_dir/metal/inicio.html
echo "madera"           > $web_dir/madera/index.html
echo "sonido"           > $web_dir/sonido/index.html

echo "<Directory /var/fp>"                              >> $apache2Conf
echo "    Options Indexes FollowSymLinks Multiviews"    >> $apache2Conf
echo "    AllowOverride none"                           >> $apache2Conf
echo "    Require all granted"                          >> $apache2Conf
echo "</Directory>"                                     >> $apache2Conf

echo "<VirtualHost 10.33.6.3:80>"                           >  $sitesAvailable/informatica.conf
echo "  ServerName www.informatica.fp"                      >> $sitesAvailable/informatica.conf
echo "  DocumentRoot /var/fp/informatica"                   >> $sitesAvailable/informatica.conf
echo "  <Directory /var/fp/informatica>"                    >> $sitesAvailable/informatica.conf
echo "      DirectoryIndex index.html"                      >> $sitesAvailable/informatica.conf
echo "      Options FollowSymLinks Multiviews"              >> $sitesAvailable/informatica.conf
echo "      <RequireAny>"                                   >> $sitesAvailable/informatica.conf
echo "          Require ip 10.33.6.0/24"                    >> $sitesAvailable/informatica.conf
echo "          Require host informatica.fp"                >> $sitesAvailable/informatica.conf
echo "      </RequireAny>"                                  >> $sitesAvailable/informatica.conf
echo "  </Directory>"                                       >> $sitesAvailable/informatica.conf
echo "  ErrorLog $logs/error_informatica.log"               >> $sitesAvailable/informatica.conf
echo "  CustomLog $logs/access_informatica.log combined"    >> $sitesAvailable/informatica.conf
echo "</VirtualHost>"                                       >> $sitesAvailable/informatica.conf

echo "<VirtualHost 10.33.6.3:8000>"                         >  $sitesAvailable/metal.conf
echo "  ServerName www.metal.fp"                            >> $sitesAvailable/metal.conf
echo "  DocumentRoot /var/fp/metal"                         >> $sitesAvailable/metal.conf
echo "  <Directory /var/fp/metal>"                          >> $sitesAvailable/metal.conf
echo "      DirectoryIndex inicio.html"                     >> $sitesAvailable/metal.conf
echo "      Options Indexes FollowSymLinks Multiviews"      >> $sitesAvailable/metal.conf
echo "  </Directory>"                                       >> $sitesAvailable/metal.conf
echo "  ErrorLog $logs/error_metal.log"                     >> $sitesAvailable/metal.conf
echo "  CustomLog $logs/access_metal.log combined"          >> $sitesAvailable/metal.conf
echo "</VirtualHost>"                                       >> $sitesAvailable/metal.conf

echo "<VirtualHost 10.33.6.3:80>"           >  $sitesAvailable/madera.conf
echo "  ServerName www.madera.fp"           >> $sitesAvailable/madera.conf
echo "  DocumentRoot /var/fp/madera"        >> $sitesAvailable/madera.conf
echo "</VirtualHost>"                       >> $sitesAvailable/madera.conf

echo "<VirtualHost 10.33.6.3:80>"           >  $sitesAvailable/sonido.conf
echo "  ServerName www.sonido.fp"           >> $sitesAvailable/sonido.conf
echo "  DocumentRoot /var/fp/sonido"        >> $sitesAvailable/sonido.conf
echo "</VirtualHost>"                       >> $sitesAvailable/sonido.conf

a2ensite informatica.conf madera.conf sonido.conf metal.conf

################################
#- CAMBIAR PUERTOS DE ESCUCHA -#
################################
# Comprobar si existen los usuarios introducidos como parámetros
if [ "$(grep -cw "^Listen 8000" /etc/apache2/ports.conf)" -eq 0 ]; then
    echo "Habilitando Puerto 8000"
    echo "Listen 8000" >> /etc/apache2/ports.conf
fi

service apache2 restart