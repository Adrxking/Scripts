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
# * Servir directorios virtuales con uso de alias
→ a2enmod alias --> Comando para habilitar el módulo alias.
→ a2dismod alias --> Comando para deshabilitar el módulo alias.

Alias /midirectoriovirtual /home/adrian/html
<Directory /home/adrian/html>
Require all granted
DirectoryIndex index.html
</Directory>

# * Servir directorios virtuales con uso de enlaces simbólicos
→ ln -s /home/gines/documentos /var/www/gines/misdocumentos --> Comando para generar enlace simbólico.

<Directory /var/www/gines/misdocumentos>
DirectoryIndex index.html
Options Indexes FollowSymLinks
Require all granted
</Directory>


################################
##-- DIRECTORIOS PERSONALES --##
################################
# * Servir directorios personales de los usuarios:
→ a2enmod userdir
→ mkdir /home/adrian/public_html

→ http://IP/~adrian/index.html

################################
#- CAMBIAR PUERTOS DE ESCUCHA -#
################################
# * Escuchar en otros puertos:
Listen 8080 >> /etc/apache2/ports.conf

<VirtualHost 192.168.0.111:2020>
DocumentRoot /var/www/maria
</VirtualHost>

O bien:

<VirtualHost 192.168.0.111>
DocumentRoot /var/www/maria
</VirtualHost>

# * De esta última manera, este host virtual sería accesible por cualquier puerto que esté habilitado.

################################
##-- DIRECTORIOS PERSONALES --##
################################
