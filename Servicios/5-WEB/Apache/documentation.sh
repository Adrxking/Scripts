################################
##- ARCHIVOS DE CONFIGURACIÓN -#
################################
/etc/apache2/apache2.conf → Archivo de configuración por defecto
/etc/apache2/conf-available -> Diferentes configuraciones que podemos crear como plantillas de configuración
/etc/apache2/conf-enabled -> Habilitar configuraciones que hemos creado en el conf-available
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
ErrorLog /var/log/apache2/error.log -> Para indicar el fichero de registro de errores.
CustomLog /var/log/apache2/Access.log combined -> Para indicar el fichero de registro de accesos.
LogFormat -> Para indicar el formato de los registros.
ErrorDocument 404 /no_encontrada.html -> Página de errores personalizada
ErrorDocument 404 "no se ha podido encontrar" -> Página de errores personalizada

# * Opciones dentro de la directiva Directory
DirectoryIndex index.html index.php index.asp --> Ficheros a servir por defecto
Options Indexes FollowSymLinks Multiviews --> Opciones sobre directorios
    - Indexes -> Si no encuentra el archivo por defecto se mostrará la jerarquía de archivos en el navegador.
    - FollowSymLinks -> Para que se puedan seguir enlaces simbólicos
    - Multiviews -> Para poder ver diferentes vistas de un mismo archivo
Require all granted -> Dar permisos a apache.

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
mkdir /var/www/pepe
mkdir /var/www/maria

echo "Soy adrian"   > /var/www/adrian/index.html
echo "Soy pepe"     > /var/www/pepe/index.html
echo "Soy maria"    > /var/www/maria/index.html

# En el site availables añadimos lo siguiente
echo "<VirtualHost *:8081>"                             >  /etc/apache2/sites-available/adrian.conf
echo "    DocumentRoot /var/www/adrian"                 >> /etc/apache2/sites-available/adrian.conf
echo "</VirtualHost>"                                   >> /etc/apache2/sites-available/adrian.conf

echo "<VirtualHost *:8082>"                             >  /etc/apache2/sites-available/pepe.conf
echo "    DocumentRoot /var/www/pepe"                   >> /etc/apache2/sites-available/pepe.conf
echo "</VirtualHost>"                                   >> /etc/apache2/sites-available/pepe.conf

echo "<VirtualHost *:80>"                               >  /etc/apache2/sites-available/maria.conf
echo "    DocumentRoot /var/www/maria"                  >> /etc/apache2/sites-available/maria.conf
echo "</VirtualHost>"                                   >> /etc/apache2/sites-available/maria.conf

# Comandos
a2ensite maria.conf
a2ensite adrian.conf
a2ensite pepe.conf

service apache2 restart

################################
######------ DNS -------########
################################
apt install bind9 -y

echo "zone \"icv\" {"                                         >  /etc/bind/named.conf.local
echo "  type master;"                                         >> /etc/bind/named.conf.local
echo "  file \"/etc/bind/db.icv\";"                           >> /etc/bind/named.conf.local
echo "};"                                                     >> /etc/bind/named.conf.local

echo ";"                                                      >  /etc/bind/db.icv
echo '$TTL    86400'                                          >> /etc/bind/db.icv
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
####--- Cambio de Idioma ----###
################################
# * Visualizar el contenido de la web en un idioma u otro dependiendo del idioma del navegador del cliente
#!bin/bash
mkdir /var/www/html/prueba

# En el directorio prueba
echo "Esta es la prueba en castellano"  > /var/www/html/prueba/index.html.es
echo "Esta es la prueba en ingles"      > /var/www/html/prueba/index.html.en
echo "Esta es la prueba en frances"     > /var/www/html/prueba/index.html.fr

# En 000-default:
echo "<Directory /var/www/html/prueba>"             >> /etc/apache2/sites-available/000-default.conf
echo "    DirectoryIndex index.html"                >> /etc/apache2/sites-available/000-default.conf
echo "    Options MultiViews FollowSymLinks"        >> /etc/apache2/sites-available/000-default.conf
echo "</Directory>"                                 >> /etc/apache2/sites-available/000-default.conf

# Comando:
a2ensite 000-default.conf

# apachectl -t : Comprobar sintaxis

#################################
###-- RESOLUCION POR NOMBRES --##
#################################

# * En el site available
echo "<VirtualHost *:80>"                               >  /etc/apache2/sites-available/adrian.conf
echo "    ServerName www.adrian.icv"                    >> /etc/apache2/sites-available/adrian.conf
echo "    DocumentRoot /var/www/adrian"                 >> /etc/apache2/sites-available/adrian.conf
echo "</VirtualHost>"                                   >> /etc/apache2/sites-available/adrian.conf

echo "<VirtualHost *:80>"                               >  /etc/apache2/sites-available/pepe.conf
echo "    ServerName www.pepe.icv"                      >> /etc/apache2/sites-available/pepe.conf
echo "    DocumentRoot /var/www/pepe"                   >> /etc/apache2/sites-available/pepe.conf
echo "</VirtualHost>"                                   >> /etc/apache2/sites-available/pepe.conf

echo "<VirtualHost *:80>"                               >  /etc/apache2/sites-available/maria.conf
echo "    ServerName www.maria.icv"                     >> /etc/apache2/sites-available/maria.conf
echo "    DocumentRoot /var/www/maria"                  >> /etc/apache2/sites-available/maria.conf
echo "</VirtualHost>"                                   >> /etc/apache2/sites-available/maria.conf

################################
####--- Control De Acceso ---###
################################
# * módulos importantes: mod_authz_core y mod_authz_host
- Require: Comprueba si un usuario autentificado está autorizado
    -> Require all granted: acceso permitido sin condiciones
    -> Require all denied: acceso denegado sin condiciones
    -> Require user userid [userid]: sólo los usuarios citados pueden acceder.
    -> Require group group-id [group-id]: sólo los usuarios pertenecientes a los grupos
    citados pueden acceder.
    -> Require ip 10 172.20 192.168.2 10.33.13.44: los clientes de los rangos especificados
    pueden acceder.
    -> Require valid-user: cualquier usuario válido puede acceder.
    -> Require host: sólo el FQDN citado puede acceder. Se pueden citar varios.

# * Está permitido el uso de not para negar una condición. (Require not ip 10.33.13.22)
Ex:

#!/bin/bash
mkdir /var/www/html/restringido
# En el directorio restringido
echo "Directorio restringido"                   >  /var/www/html/restringido/index.html

# En 000-default:
echo "<Directory /var/www/html/restringido>"    >> /etc/apache2/sites-available/000-default.conf
# Que se cumpla alguna regla
echo "    <RequireAny>"                         >> /etc/apache2/sites-available/000-default.conf 
# Permitir acceso solo desde esta IP
echo "        Require ip 10.33.6.99"            >> /etc/apache2/sites-available/000-default.conf
# Permitir acceso solo desde red
echo "        Require ip 10.33.6.0/24"          >> /etc/apache2/sites-available/000-default.conf 
# Permitir acceso solo desde esta IP local
echo "        Require ip 127.0.0.7"             >> /etc/apache2/sites-available/000-default.conf 
echo "    </RequireAny>"                        >> /etc/apache2/sites-available/000-default.conf
echo "</Directory>"                             >> /etc/apache2/sites-available/000-default.conf


################################
#####---- AUTENTICACIÓN ----####
################################
# ! Autenticacion sin digest
# Comandos
# * Crear un archivo con el usuario
htpasswd -c /etc/apache2/usuarios juan

# En 000-default
echo "<Directory /var/www/html/restringido>"            >> /etc/apache2/sites-available/000-default.conf
echo "    AuthType Basic"                               >> /etc/apache2/sites-available/000-default.conf
echo "    AuthName \"Se require autenticación\""        >> /etc/apache2/sites-available/000-default.conf
echo "    AuthUserFile \"/etc/apache2/usuarios\""       >> /etc/apache2/sites-available/000-default.conf
echo "    Require user usuario"                         >> /etc/apache2/sites-available/000-default.conf
echo "</Directory>"                                     >> /etc/apache2/sites-available/000-default.conf

# ! Autenticacion con digest
# Comandos
a2enmod auth_digest

# * Crear un archivo con los diferentes usuarios y grupos
htdigest -c /etc/apache2/usuarios_digest grupo1 usuario1
htdigest /etc/apache2/usuarios_digest grupo1 usuario2
htdigest /etc/apache2/usuarios_digest grupo2 usuario3

# En 000-default
echo "<Directory /var/www/html/restringido>"                >> /etc/apache2/sites-available/000-default.conf
echo "    AuthType Digest"                                  >> /etc/apache2/sites-available/000-default.conf
echo "    AuthName \"grupo1 grupo2\""                       >> /etc/apache2/sites-available/000-default.conf
echo "    AuthUserFile \"/etc/apache2/usuarios_digest\""    >> /etc/apache2/sites-available/000-default.conf
echo "    Require user usuario1"                            >> /etc/apache2/sites-available/000-default.conf
echo "</Directory>"                                         >> /etc/apache2/sites-available/000-default.conf

################################
#######----- HTTPs ------#######
################################
# Comandos
a2enmod ssl
a2ensite default-ssl.conf

################################
######---- .htaccess ----#######
################################
# En 000-default.conf
echo "<Directory /var/www/html/personal>"       >> /etc/apache2/sites-available/000-default.conf
echo "    AllowOverride all"                    >> /etc/apache2/sites-available/000-default.conf
echo "</Directory>"                             >> /etc/apache2/sites-available/000-default.conf

# En el .htaccess del directorio
echo "AuthType Basic"                           >  /var/www/html/personal/.htaccess
echo "AuthName \"Prohibido\""                   >> /var/www/html/personal/.htaccess
echo "AuthUserFile /var/www/html/users.txt"     >> /var/www/html/personal/.htaccess
echo "Require user rodolfo"                     >> /var/www/html/personal/.htaccess

# * Directiva -c porque es nuevo el archivo
htpasswd -c /var/www/html/users.txt rodolfo