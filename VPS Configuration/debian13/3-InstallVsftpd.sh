#!/bin/bash
# Este script instala vsftpd y lo configura para permitir el acceso únicamente a los usuarios autorizados.
# Debe ejecutarse como root en Debian GNU/Linux 13.

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root."
  exit 1
fi

# Actualizar repositorios e instalar vsftpd y OpenSSL
apt-get update
apt-get install -y vsftpd openssl

# Realizar backup de la configuración original si no existe uno previo
if [ ! -f /etc/vsftpd.conf.bak ]; then
  cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
fi

# Crear un directorio global para FTP que se usará como "home" virtual (si es necesario)
FTP_GLOBAL_DIR="/srv/ftp"
if [ ! -d "$FTP_GLOBAL_DIR" ]; then
  mkdir -p "$FTP_GLOBAL_DIR"
  chown root:root "$FTP_GLOBAL_DIR"
  chmod 755 "$FTP_GLOBAL_DIR"
fi

# Generar la nueva configuración de vsftpd
cat <<EOF > /etc/vsftpd.conf
# Deshabilitar acceso anónimo
anonymous_enable=NO

# Permitir acceso a usuarios locales
local_enable=YES

# Permitir subida de archivos
write_enable=YES

# Forzar el encierro (chroot) a los usuarios locales
chroot_local_user=YES
allow_writeable_chroot=YES

# Activar el uso de una lista de usuarios permitidos
userlist_enable=YES
userlist_file=/etc/vsftpd.userlist
userlist_deny=NO

# Opciones adicionales para la escucha y seguridad
listen=YES
listen_ipv6=NO

# Banner de bienvenida (opcional)
ftpd_banner=Bienvenido al servicio FTP.
ssl_enable=YES
allow_anon_ssl=NO
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_tlsv1=YES
ssl_sslv2=NO
ssl_sslv3=NO
rsa_cert_file=/etc/ssl/private/vsftpd.pem
rsa_private_key_file=/etc/ssl/private/vsftpd.pem
EOF

# Crear el archivo de lista de usuarios permitidos, si aún no existe.
if [ ! -f /etc/vsftpd.userlist ]; then
  touch /etc/vsftpd.userlist
fi

if [ ! -f /etc/ssl/private/vsftpd.pem ]; then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/vsftpd.pem \
    -out /etc/ssl/private/vsftpd.pem
fi

# Asegurar que el archivo tenga los permisos correctos
chown root:root /etc/vsftpd.userlist
chmod 600 /etc/vsftpd.userlist

# Reiniciar vsftpd para aplicar los cambios
systemctl restart vsftpd

echo "vsftpd instalado y configurado."
echo "Solo podrán acceder los usuarios listados en /etc/vsftpd.userlist (uno por línea)."
echo "Para agregar un usuario, edite el archivo /etc/vsftpd.userlist."
