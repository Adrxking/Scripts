# * --> Lubuntu 18 con dirección IP 10.33.xx.100
# * --> Debian 9 con Hosts virtuales (uno por cada dominio), sobre la misma dirección IP 
# * --> El dominio es: sonido.fp.

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
##--- Configuracion NGINX ---##
################################
# Comprobar si nginx esta instalado, si no lo instala
REQUIRED_PKG="nginx"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi

# Declaracion de variables
web_dir=/var/www/html
nginxConf=/etc/nginx/nginx.conf
sitesAvailable=/etc/nginx/sites-available
logs=/var/fp/logs

# Creacion de las carpetas para cada fp
if ! [ -d $web_dir/sonido ]; then
    mkdir -p $web_dir/sonido
fi
if ! [ -d $logs ]; then
    mkdir -p $logs
fi

# Creacion de las paginas web para cada fp
echo "sonido"           > $web_dir/sonido/index.html

# Configuracion del nginx
    echo "server {"                                                 >  $sitesAvailable/sonido
    echo "    listen        80;"                                    >> $sitesAvailable/sonido
    echo "    server_name   www.sonido.fp;"                         >> $sitesAvailable/sonido
    echo "    index         index.html;"                            >> $sitesAvailable/sonido
    echo "    root          /var/www/proxy-inverso;"                >> $sitesAvailable/sonido
    echo "    location / {"                                         >> $sitesAvailable/sonido
    echo "             proxy_pass           http://10.33.6.200/;"   >> $sitesAvailable/sonido
    echo "             proxy_set_header     Host    \$host;"        >> $sitesAvailable/sonido
    echo "    }"                                                    >> $sitesAvailable/sonido
    echo "}"                                                        >> $sitesAvailable/sonido

# Habilitar los sitios
if ! [ -f /etc/nginx/sites-enabled/sonido ]; then 
    ln -s /etc/nginx/sites-available/sonido /etc/nginx/sites-enabled/
fi

################################
######---- FIN NGINX -----######
################################
service nginx restart