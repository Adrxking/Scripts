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

echo "zone \"edu\" {"                                         >  $namedLocal
echo "  type master;"                                         >> $namedLocal
echo "  file \"/etc/bind/db.edu\";"                           >> $namedLocal
echo "};"                                                     >> $namedLocal

echo ";"                                                      >  /etc/bind/db.edu
echo '$TTL    86400'                                          >> /etc/bind/db.edu
echo "@     IN  SOA  lubuntu.icv.  adrian.  ("                >> /etc/bind/db.edu
echo "                             1   ;  Serial"             >> /etc/bind/db.edu
echo "                        604800   ; Refresh"             >> /etc/bind/db.edu
echo "                         86400   ; Retry"               >> /etc/bind/db.edu
echo "                       2419200   ; Expire"              >> /etc/bind/db.edu
echo "                         86400 ) ; Negative Cache TTL"  >> /etc/bind/db.edu
echo ";"                                                      >> /etc/bind/db.edu
echo "@                 IN  NS   lubuntu.icv."                >> /etc/bind/db.edu
echo "www.cicloasir     IN  A    10.33.6.50"                  >> /etc/bind/db.edu
echo "www.ciclodaw      IN  A    10.33.6.50"                  >> /etc/bind/db.edu
echo "www.ciclodam      IN  A    10.33.6.50"                  >> /etc/bind/db.edu
echo "www.ciclosmr      IN  A    10.33.6.55"                  >> /etc/bind/db.edu

service bind9 restart
echo "Servicio bind9 reiniciado"

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
web_dir=/var/ciclos
apache2Conf=/etc/apache2/apache2.conf
sitesAvailable=/etc/apache2/sites-available
logs=/var/ciclos/logs

# Creacion de las carpetas para cada ciclo
if ! [ -d $web_dir/cicloasir ]; then
    mkdir -p $web_dir/cicloasir
fi
if ! [ -d $web_dir/ciclodam ]; then
    mkdir -p $web_dir/ciclodam
fi
if ! [ -d $web_dir/ciclodaw ]; then
    mkdir -p $web_dir/ciclodaw
fi
if ! [ -d $web_dir/ciclosmr ]; then
    mkdir -p $web_dir/ciclosmr
fi
if ! [ -d $logs ]; then
    mkdir -p $logs
fi

# Creacion de las paginas web para cada ciclo
echo "cicloasir"            > $web_dir/cicloasir/index.html
echo "ciclodam"             > $web_dir/ciclodam/index.html
echo "ciclodaw"             > $web_dir/ciclodaw/index.html

# Crear el directory de ciclos
if [ "$(grep -cw "<Directory /var/ciclos>" $apache2Conf)" -eq 0 ]; then
    echo "<Directory /var/ciclos>"                          >> $apache2Conf
    echo "    Options Indexes FollowSymLinks Multiviews"    >> $apache2Conf
    echo "    AllowOverride none"                           >> $apache2Conf
    echo "    Require all granted"                          >> $apache2Conf
    echo "</Directory>"                                     >> $apache2Conf
fi

################################
###- CREAR LOS VIRTUALHOST --###
################################
# Crear el virtual host de cicloasir
echo "<VirtualHost 10.33.6.50:80>"                          >  $sitesAvailable/cicloasir.conf
echo "  ServerName www.cicloasir.edu"                       >> $sitesAvailable/cicloasir.conf
echo "  DocumentRoot $web_dir/cicloasir"                    >> $sitesAvailable/cicloasir.conf
echo "  <Directory $web_dir/cicloasir>"                     >> $sitesAvailable/cicloasir.conf
echo "      DirectoryIndex index.html"                      >> $sitesAvailable/cicloasir.conf
echo "      Options FollowSymLinks Multiviews"              >> $sitesAvailable/cicloasir.conf
echo "      <RequireAny>"                                   >> $sitesAvailable/cicloasir.conf
echo "          Require ip 10.33.6.0/24"                    >> $sitesAvailable/cicloasir.conf
echo "          Require host cicloasir.edu"                 >> $sitesAvailable/cicloasir.conf
echo "      </RequireAny>"                                  >> $sitesAvailable/cicloasir.conf
echo "  </Directory>"                                       >> $sitesAvailable/cicloasir.conf
echo "  ErrorLog $logs/error-asir.log"                      >> $sitesAvailable/cicloasir.conf
echo "  CustomLog $logs/access-asir.log combined"           >> $sitesAvailable/cicloasir.conf
echo "</VirtualHost>"                                       >> $sitesAvailable/cicloasir.conf


# Crear el virtual host del ciclo dam
# Crear la carpeta restringida 
if ! [ -d $web_dir/ciclodam/adrian ]; then
    mkdir -p $web_dir/ciclodam/adrian
    echo "Carpeta restringida"                              >  $web_dir/ciclodam/adrian/index.html
fi

# Añadir usuario
if ! [ -f $web_dir/ciclodam/usuarios_ciclodam.txt ]; then
    htpasswd -c /var/ciclos/ciclodam/usuarios_ciclodam.txt adrian
fi
echo "<VirtualHost 10.33.6.50:8008>"                                >  $sitesAvailable/ciclodam.conf
echo "  ServerName www.ciclodam.edu"                                >> $sitesAvailable/ciclodam.conf
echo "  DocumentRoot $web_dir/ciclodam"                             >> $sitesAvailable/ciclodam.conf
echo "  <Directory $web_dir/ciclodam>"                              >> $sitesAvailable/ciclodam.conf
echo "      DirectoryIndex inicio.html"                             >> $sitesAvailable/ciclodam.conf
echo "      Options Indexes FollowSymLinks Multiviews"              >> $sitesAvailable/ciclodam.conf
#echo "      <RequireAny>"                                           >> $sitesAvailable/ciclodam.conf
#echo "          Require not ip 10.33.6.99"                          >> $sitesAvailable/ciclodam.conf
#echo "      </RequireAny>"                                          >> $sitesAvailable/ciclodam.conf
echo "  </Directory>"                                               >> $sitesAvailable/ciclodam.conf
echo "  <Directory $web_dir/ciclodam/adrian>"                       >> $sitesAvailable/ciclodam.conf
echo "      DirectoryIndex index.html"                              >> $sitesAvailable/ciclodam.conf
echo "      AuthType Basic"                                         >> $sitesAvailable/ciclodam.conf
echo "      AuthName \"Diretorio Restringido\""                     >> $sitesAvailable/ciclodam.conf
echo "      AuthUserFile $web_dir/ciclodam/usuarios_ciclodam.txt"   >> $sitesAvailable/ciclodam.conf
echo "      Require user adrian"                                    >> $sitesAvailable/ciclodam.conf
echo "  </Directory>"                                               >> $sitesAvailable/ciclodam.conf
echo "  ErrorLog $logs/error-dam.log"                               >> $sitesAvailable/ciclodam.conf
echo "  CustomLog $logs/access-dam.log combined"                    >> $sitesAvailable/ciclodam.conf
echo "</VirtualHost>"                                               >> $sitesAvailable/ciclodam.conf


# Crear el virtual host de ciclodaw
# Crear la carpeta restringida 
if ! [ -d $web_dir/ciclodaw/vitys ]; then
    mkdir -p $web_dir/ciclodaw/vitys
    echo "Carpeta restringida"                                      >  $web_dir/ciclodaw/vitys/index.html
fi

# Añadir usuario
if ! [ -f $web_dir/ciclodaw/usuarios_ciclodaw.txt ]; then
    htpasswd -c /var/ciclos/ciclodaw/usuarios_ciclodaw.txt vitys
    htpasswd -c /var/ciclos/ciclodaw/usuarios_ciclodaw.txt adrian
fi

echo "<VirtualHost 10.33.6.50:443>"                             >  $sitesAvailable/ciclodaw.conf
echo "  ServerName www.ciclodaw.edu"                            >> $sitesAvailable/ciclodaw.conf
echo "  DocumentRoot $web_dir/ciclodaw"                         >> $sitesAvailable/ciclodaw.conf
echo "  SSLEngine on"                                                   >> $sitesAvailable/ciclodaw.conf
echo "  SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem"        >> $sitesAvailable/ciclodaw.conf
echo "  SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key"   >> $sitesAvailable/ciclodaw.conf
echo "  <Directory $web_dir/ciclodaw>"                          >> $sitesAvailable/ciclodaw.conf
echo "      DirectoryIndex indice.html"                         >> $sitesAvailable/ciclodaw.conf
echo "      Options Indexes FollowSymLinks Multiviews"          >> $sitesAvailable/ciclodaw.conf
echo "  </Directory>"                                           >> $sitesAvailable/ciclodaw.conf
echo "  <Directory $web_dir/ciclodaw/vitys>"                    >> $sitesAvailable/ciclodaw.conf
echo "      AllowOverride all"                                  >> $sitesAvailable/ciclodaw.conf
echo "  </Directory>"                                           >> $sitesAvailable/ciclodaw.conf
echo "  ErrorLog $logs/error-daw.log"                           >> $sitesAvailable/ciclodaw.conf
echo "  CustomLog $logs/access-daw.log combined"                >> $sitesAvailable/ciclodaw.conf
echo "</VirtualHost>"                                           >> $sitesAvailable/ciclodaw.conf
# Configuracion del htaccess
echo "AuthType Basic"                                           >  $web_dir/ciclodaw/vitys/.htaccess
echo "AuthName \"Diretorio Restringido\""                       >> $web_dir/ciclodaw/vitys/.htaccess
echo "AuthUserFile /var/ciclos/ciclodaw/usuarios_ciclodaw.txt"  >> $web_dir/ciclodaw/vitys/.htaccess
echo "Require user adrian vitys"                                >> $web_dir/ciclodaw/vitys/.htaccess

# Crear el virtual host de ciclosmr
echo "<VirtualHost 10.33.6.3:80>"                               >  $sitesAvailable/ciclosmr.conf
echo "  ServerName www.ciclosmr.edu"                            >> $sitesAvailable/ciclosmr.conf
echo "  ProxyPass / http://10.33.6.55/"                         >> $sitesAvailable/ciclosmr.conf
echo "  ProxyPassReverse / http://10.33.6.55/"                  >> $sitesAvailable/ciclosmr.conf
echo "  ProxyPreserveHost on"                                   >> $sitesAvailable/ciclosmr.conf
echo "</VirtualHost>"                                           >> $sitesAvailable/ciclosmr.conf
# Habilitar los modulos para proxy reverso
a2enmod proxy_html
a2enmod proxy_http

# Habilitar los modulos para SSL
a2enmod ssl

# Habilitar los sitios
a2ensite cicloasir.conf ciclodam.conf ciclodaw.conf ciclosmr.conf

################################
#- CAMBIAR PUERTOS DE ESCUCHA -#
################################
# Comprobar si existen los puertos necesarios
if [ "$(grep -cw "^Listen 8008" /etc/apache2/ports.conf)" -eq 0 ]; then
    echo "Habilitando Puerto 8008"
    echo "Listen 8008" >> /etc/apache2/ports.conf
fi

################################
######---- FIN APACHE ----######
################################
service apache2 restart