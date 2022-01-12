################################
##- ARCHIVOS DE CONFIGURACIÓN -#
################################
/etc/apache2/apache2.conf → Archivo de configuración por defecto
/etc/apache2/conf-available --> Diferentes configuraciones que podemos crear como plantillas de configuración
/etc/apache2/conf-enabled --> Habilitar configuraciones que hemos creado en el conf-available
/etc/apache2/mods-available → Módulos instalados
/etc/apache2/mods-enabled → Módulos habilitados
/etc/apache2/sites-available → Servidores virtuales definidos
/etc/apache2/sites-enabled → Servidores virtuales habilitados
/etc/apache2/envvars → Variables de entorno del servidor
/etc/apache2/ports.conf → Puertos de escucha por defecto
/etc/apache2/magic → Contiene instrucciones para determinar el tipo MIME en función de los primeros bytes de los ficheros

################################
###-- CONFIGURACIÓN BÁSICA --###
################################
# * Estas directivas las podemos añadir en los VirtualHost (/etc/apache2/sites-available/...)
ErrorLog /var/log/apache2/error.log --> Para indicar el fichero de registro de errores.
CustomLog /var/log/apache2/Access.log combined --> Para indicar el fichero de registro de accesos.
LogFormat --> Para indicar el formato de los registros.
ErrorDocument 404 /no_encontrada.html --> Página de errores personalizada
ErrorDocument 404 "no se ha podido encontrar" --> Página de errores personalizada

# * Opciones dentro de la directiva Directory
DirectoryIndex index.html index.php index.asp --> Ficheros a servir por defecto
Options Indexes FollowSymLinks Multiviews --> Opciones sobre directorios
    - Indexes --> Si no encuentra el archivo por defecto se mostrará la jerarquía de archivos en el navegador.
    - FollowSymLinks --> Para que se puedan seguir enlaces simbólicos
    - Multiviews --> Para poder ver diferentes vistas de un mismo archivo
Require all granted --> Dar permisos a apache.

Options debe estar entre la etiqueta Directory. E.x.:
<Directory /var/www/html>
    DirectoryIndex index.html index.php index.asp
    Options Indexes FollowSymLinks Multiviews
    Require all granted
</Directory>

################################
##-- DIRECTORIOS VIRTUALES --###
################################
# ! TENER EN CUENTA QUE A PARTIR DE UBUNTU 21 LAS CARPETAS /home/usuarios no tienen el permiso o+x
# * Servir directorios virtuales con uso de alias
→ a2enmod alias --> Comando para habilitar el módulo alias.
→ a2dismod alias --> Comando para deshabilitar el módulo alias.

Alias /midirectoriovirtual /home/usuario/html
<Directory /home/usuario/html>
    Require all granted
    DirectoryIndex index.html
</Directory>

# * Servir directorios virtuales con uso de enlaces simbólicos
→ ln -s /home/usuario/html /var/www/html/midirectoriovirtual --> Comando para generar enlace simbólico.

<Directory /var/www/html/midirectoriovirtual>
    Require all granted
    DirectoryIndex index.html
    Options Indexes FollowSymLinks
</Directory>


################################
##-- DIRECTORIOS PERSONALES --##
################################
# * Servir directorios personales de los usuarios:
→ a2enmod userdir
→ mkdir /home/usuario/public_html
→ nano /home/usuario/public_html/index.html

→ http://IP/~usuario/index.html

################################
#- CAMBIAR PUERTOS DE ESCUCHA -#
################################
# * Escuchar en otros puertos:
echo "Listen 8080" >> /etc/apache2/ports.conf

<VirtualHost 192.168.0.111:2020>
DocumentRoot /var/www/maria
</VirtualHost>

O bien:

<VirtualHost 192.168.0.111>
DocumentRoot /var/www/maria
</VirtualHost>

# * De esta última manera, este host virtual sería accesible por cualquier puerto que esté habilitado.

Ex:
#!/bin/bash
mkdir /var/www/adrian
echo "Soy adrian" > /var/www/adrian/index.html
mkdir /var/www/pepe
echo "Soy pepe" > /var/www/pepe/index.html
mkdir /var/www/maria
echo "Soy maria" > /var/www/maria/index.html

# * En el site availables añadimos lo siguiente
echo "<VirtualHost *:8081>"                             >  /etc/apache2/sites-available/adrian.conf
echo "    DocumentRoot /var/www/adrian"                 >> /etc/apache2/sites-available/adrian.conf
echo "</VirtualHost>"                                   >> /etc/apache2/sites-available/adrian.conf

echo "<VirtualHost *:8082>"                             >  /etc/apache2/sites-available/pepe.conf
echo "    DocumentRoot /var/www/pepe"                   >> /etc/apache2/sites-available/pepe.conf
echo "</VirtualHost>"                                   >> /etc/apache2/sites-available/pepe.conf

echo "<VirtualHost *:80>"                               >  /etc/apache2/sites-available/maria.conf
echo "    DocumentRoot /var/www/maria"                  >> /etc/apache2/sites-available/maria.conf
echo "</VirtualHost>"                                   >> /etc/apache2/sites-available/maria.conf

a2ensite maria.conf
a2ensite adrian.conf
a2ensite pepe.conf

service apache2 restart

# * Añadir DNS
apt install bind9 -y

echo "zone \"icv\" {"                                         >  /etc/bind/named.conf.local
echo "  type master;"                                         >> /etc/bind/named.conf.local
echo "  file \"/etc/bind/db.icv\";"                           >> /etc/bind/named.conf.local
echo "};"                                                     >> /etc/bind/named.conf.local

echo ";"                                                      >  /etc/bind/db.icv
echo '"$TTL"    86400'                                        >> /etc/bind/db.icv
echo "@     IN  SOA  lubuntu.icv.  adrian.  ("                >> /etc/bind/db.icv
echo "                             1   ;  Serial"             >> /etc/bind/db.icv
echo "                        604800   ; Refresh"             >> /etc/bind/db.icv
echo "                         86400   ; Retry"               >> /etc/bind/db.icv
echo "                       2419200   ; Expire"              >> /etc/bind/db.icv
echo "                         86400 ) ; Negative Cache TTL"  >> /etc/bind/db.icv
echo ";"                                                      >> /etc/bind/db.icv
echo "@            IN  NS   lubuntu.icv."                     >> /etc/bind/db.icv
echo "lubuntu      IN  A    10.33.6.2"                        >> /etc/bind/db.icv
echo "www.maria    IN  A    10.33.6.2"                        >> /etc/bind/db.icv
echo "www.pepe     IN  A    10.33.6.22"                       >> /etc/bind/db.icv

################################
##-- DIRECTORIOS PERSONALES --##
################################
