# * 1.  Instalar y configurar un equipo con la distribución IPCop con las siguientes características:
    # * - Tarjeta ROJA - IP estática de la red del aula.
    # * - Tarjeta VERDE - Primera dirección IP de la LAN, por ejemplo, 10.33.xx.1
    # * - Tarjeta NARANJA - Primera dirección IP de la DMZ, por ejemplo 10.33.1xx.1
    # * - Configuración de las reglas NAT para dirigir el tráfico por el puerto 80 desde la WAN a la DMZ.

# * 2.  Instalar y configurar un equipo el la DMZ con la distribución Debian con las siguientes características:
    # * - Una interfaz de red (ensxx) con una dirección IP de la DMZ.
    # * - Un servidor Apache 2.4 con un proxy inverso que redirija las peticiones al servidor Web que estará ubicado en la LAN.

# * 3.  Instalar y configurar un equipo en la LAN con la distribución Ubuntu server 18 con las siguientes características:
    # * - Una interfaz de red (ensxx) con una dirección IP de la LAN.
    # * - Un servidor Apache 2.4 con un servidor Web que atiende las peticiones que le pasa el proxy con un gestor de contenidos o una plataforma educativa, por ejemplo Joomla o Moodle.

# * 4.  Comprobar que desde la red del aula se puede acceder al gestor de contenidos o plataforma educativa.

# * 5.  Documentar la práctica.

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

# Declaracion de variables
namedLocal=/etc/bind/named.conf.local

# Creacion de zonas
echo "zone \"fp\" {"                                          >  $namedLocal
echo "  type master;"                                         >> $namedLocal
echo "  file \"/etc/bind/db.fp\";"                            >> $namedLocal
echo "};"                                                     >> $namedLocal

# Configuracion de las zonas
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

# Reiniciar servicio bind
service bind9 restart

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

# Creacion de las carpetas para cada fp
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

# Creacion de las paginas web para cada fp
echo "Informatica"      > $web_dir/informatica/index.html
echo "metal"            > $web_dir/metal/inicio.html
echo "madera"           > $web_dir/madera/index.html
echo "sonido"           > $web_dir/sonido/index.html

# Crear el virtual host de informatica
if [ "$(grep -cw "<Directory /var/fp>" $apache2Conf)" -eq 0 ]; then
    echo "<Directory /var/fp>"                              >> $apache2Conf
    echo "    Options Indexes FollowSymLinks Multiviews"    >> $apache2Conf
    echo "    AllowOverride none"                           >> $apache2Conf
    echo "    Require all granted"                          >> $apache2Conf
    echo "</Directory>"                                     >> $apache2Conf
fi

################################
###- CREAR LOS VIRTUALHOST --###
################################
# Crear el virtual host de informatica
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


# Crear el virtual host de metal
# Crear la carpeta restringida 
if ! [ -d $web_dir/metal/hierro ]; then
    mkdir -p $web_dir/metal/hierro
fi

# Añadir usuario
if ! [ -f $web_dir/metal/usuarios_metal.txt ]; then
    htpasswd -c /var/fp/metal/usuarios_metal.txt herrero
fi
echo "<VirtualHost 10.33.6.3:8000>"                         >  $sitesAvailable/metal.conf
echo "  ServerName www.metal.fp"                            >> $sitesAvailable/metal.conf
echo "  DocumentRoot /var/fp/metal"                         >> $sitesAvailable/metal.conf
echo "  <Directory /var/fp/metal>"                          >> $sitesAvailable/metal.conf
echo "      DirectoryIndex inicio.html"                     >> $sitesAvailable/metal.conf
echo "      Options Indexes FollowSymLinks Multiviews"      >> $sitesAvailable/metal.conf
echo "  </Directory>"                                       >> $sitesAvailable/metal.conf
echo "  <Directory /var/fp/metal/hierro>"                   >> $sitesAvailable/metal.conf
echo "      DirectoryIndex index.html"                      >> $sitesAvailable/metal.conf
echo "      AuthType Basic"                                 >> $sitesAvailable/metal.conf
echo "      AuthName \"Diretorio Restringido\""             >> $sitesAvailable/metal.conf
echo "      AuthUserFile /var/fp/metal/usuarios_metal.txt"  >> $sitesAvailable/metal.conf
echo "      Require user herrero"                           >> $sitesAvailable/metal.conf
echo "  </Directory>"                                       >> $sitesAvailable/metal.conf
echo "  ErrorLog $logs/error_metal.log"                     >> $sitesAvailable/metal.conf
echo "  CustomLog $logs/access_metal.log combined"          >> $sitesAvailable/metal.conf
echo "</VirtualHost>"                                       >> $sitesAvailable/metal.conf

# Crear el virtual host de madera
# Crear la carpeta restringida 
if ! [ -d $web_dir/madera/carpinteria ]; then
    mkdir -p $web_dir/madera/carpinteria
    echo "Carpinteria"                                      >  $web_dir/madera/carpinteria/index.html
fi
# Añadir usuario
if ! [ -f $web_dir/madera/usuarios_madera.txt ]; then
    htpasswd -c /var/fp/madera/usuarios_madera.txt carpintero
fi
echo "<VirtualHost 10.33.6.3:443>"                          >  $sitesAvailable/madera.conf
echo "  ServerName www.madera.fp"                           >> $sitesAvailable/madera.conf
echo "  DocumentRoot /var/fp/madera"                        >> $sitesAvailable/madera.conf
echo "  SSLEngine on"                                       >> $sitesAvailable/madera.conf
echo "  SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem"        >> $sitesAvailable/madera.conf
echo "  SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key"   >> $sitesAvailable/madera.conf
echo "  <Directory /var/fp/madera>"                         >> $sitesAvailable/madera.conf
echo "      DirectoryIndex indice.html"                     >> $sitesAvailable/madera.conf
echo "      Options Indexes FollowSymLinks Multiviews"      >> $sitesAvailable/madera.conf
echo "  </Directory>"                                       >> $sitesAvailable/madera.conf
echo "  <Directory /var/fp/madera/carpinteria>"             >> $sitesAvailable/madera.conf
echo "      AllowOverride all"                              >> $sitesAvailable/madera.conf
echo "  </Directory>"                                       >> $sitesAvailable/madera.conf
echo "  ErrorLog $logs/error_madera.log"                    >> $sitesAvailable/madera.conf
echo "  CustomLog $logs/access_madera.log combined"         >> $sitesAvailable/madera.conf
echo "</VirtualHost>"                                       >> $sitesAvailable/madera.conf
# Configuracion del htaccess
echo "AuthType Basic"                                       >  $web_dir/madera/carpinteria/.htaccess
echo "AuthName \"Diretorio Restringido\""                   >> $web_dir/madera/carpinteria/.htaccess
echo "AuthUserFile /var/fp/madera/usuarios_madera.txt"      >> $web_dir/madera/carpinteria/.htaccess
echo "Require user carpintero"                              >> $web_dir/madera/carpinteria/.htaccess

# Crear el virtual host de sonido
echo "<VirtualHost 10.33.6.3:80>"                           >  $sitesAvailable/sonido.conf
echo "  ServerName www.sonido.fp"                           >> $sitesAvailable/sonido.conf
echo "  ProxyPass / http://10.33.6.200/"                    >> $sitesAvailable/sonido.conf # Redirigir la peticion
echo "  ProxyPassReverse / http://10.33.6.200/"             >> $sitesAvailable/sonido.conf # Que la peticion devuelta contenga en la cabecera la ip del servidor proxy (6.3)
echo "  ProxyPreserveHost on"                               >> $sitesAvailable/sonido.conf # Preservar el nombre de dominio en lugar de cambiar la peticion a la ip
echo "</VirtualHost>"                                       >> $sitesAvailable/sonido.conf
# Habilitar los modulos para proxy reverso
a2enmod proxy_html
a2enmod proxy_http

# Habilitar los sitios
a2ensite informatica.conf madera.conf sonido.conf metal.conf

################################
#- CAMBIAR PUERTOS DE ESCUCHA -#
################################
# Comprobar si existen los puertos necesarios
if [ "$(grep -cw "^Listen 8000" /etc/apache2/ports.conf)" -eq 0 ]; then
    echo "Habilitando Puerto 8000"
    echo "Listen 8000" >> /etc/apache2/ports.conf
fi
if [ "$(grep -cw "Listen 443" /etc/apache2/ports.conf)" -eq 0 ]; then
    echo "Habilitando Puerto 443"
    echo "Listen 443" >> /etc/apache2/ports.conf
fi

################################
######---- FIN APACHE ----######
################################
service apache2 restart