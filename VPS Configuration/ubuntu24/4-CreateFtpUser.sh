#!/bin/bash
# Script para crear usuarios FTP con home personalizado y añadirlos a /etc/vsftpd.userlist.
# Se debe ejecutar como root.
# Uso: ./create_ftp_users.sh

if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root."
  exit 1
fi

# Verificar existencia de /etc/vsftpd.userlist, sino crearlo.
if [ ! -f /etc/vsftpd.userlist ]; then
    touch /etc/vsftpd.userlist
    echo "Archivo /etc/vsftpd.userlist creado."
fi

while true; do
    read -p "Ingrese el nombre del usuario FTP (o 'salir' para terminar): " usuario
    if [ "$usuario" = "salir" ]; then
        break
    fi
    read -p "Ingrese el path ABSOLUTO donde este usuario iniciará (ej. /var/www/wordpress): " ftp_path

    # Verificar que el path sea absoluto
    if [[ "$ftp_path" != /* ]]; then
        echo "El path debe ser ABSOLUTO. Intente de nuevo."
        continue
    fi

    # Crear el directorio si no existe
    if [ ! -d "$ftp_path" ]; then
        echo "El directorio $ftp_path no existe. ¿Desea crearlo? (s/n)"
        read -r respuesta
        if [[ "$respuesta" =~ ^[Ss] ]]; then
            mkdir -p "$ftp_path"
            # Se recomienda que el directorio sea propiedad de root para evitar que el usuario pueda modificar la raíz del chroot.
            chown root:root "$ftp_path"
            chmod 755 "$ftp_path"
            echo "Directorio $ftp_path creado."
        else
            echo "Saltando la creación del usuario $usuario."
            continue
        fi
    fi

    # Crear el usuario FTP con el home especificado y sin shell (evitando logins interactivos)
    useradd -d "$ftp_path" -s /usr/sbin/nologin "$usuario"
    if [ $? -ne 0 ]; then
        echo "Error al crear el usuario $usuario. Quizás ya exista."
        continue
    fi

    echo "Configure la contraseña para el usuario $usuario:"
    passwd "$usuario"

    # Agregar el usuario a /etc/vsftpd.userlist si no está ya presente
    if ! grep -q "^$usuario\$" /etc/vsftpd.userlist; then
        echo "$usuario" >> /etc/vsftpd.userlist
        echo "Usuario $usuario añadido a /etc/vsftpd.userlist."
    else
        echo "El usuario $usuario ya se encontraba en /etc/vsftpd.userlist."
    fi

    echo "Usuario '$usuario' creado y configurado para FTP con home en $ftp_path."
done

echo "Proceso completado."
