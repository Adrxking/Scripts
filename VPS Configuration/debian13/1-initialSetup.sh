#!/bin/bash
# Este script debe ejecutarse como root en Debian GNU/Linux 13 (trixie).

set -euo pipefail

# Verificar que se esté ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo "Este script debe ejecutarse como root"
  exit 1
fi

###################################################
### Declaración de variables y entrada de datos ###
###################################################
# Puerto SSH deseado (puedes cambiarlo si lo requieres)
puertoSSH="22022"

# Solicitar el nombre del usuario a crear
read -r -p "Ingrese el nombre del nuevo usuario: " usuario

###################################################
########## Crear usuario y asignar sudo ###########
###################################################
# Se creará el usuario (se le pedirá la contraseña y otros datos)
adduser "$usuario"

# Añadir el usuario al grupo sudo
usermod -aG sudo "$usuario"

###################################################
########### Configuración del SSH #################
###################################################
ssh_config() {
    # Deshabilitar el acceso SSH para el usuario root
    if grep -qE "^[#[:space:]]*PermitRootLogin" /etc/ssh/sshd_config; then
        sed -i 's/^[#[:space:]]*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    else
        echo "PermitRootLogin no" >> /etc/ssh/sshd_config
    fi

    # Establecer el puerto SSH especificado
    if grep -qE "^[#[:space:]]*Port " /etc/ssh/sshd_config; then
        sed -i "s/^[#[:space:]]*Port .*/Port $puertoSSH/" /etc/ssh/sshd_config
    else
        echo "Port $puertoSSH" >> /etc/ssh/sshd_config
    fi

    # Permitir únicamente el nuevo usuario
    if grep -q "^AllowUsers" /etc/ssh/sshd_config; then
        sed -i "s/^AllowUsers.*/AllowUsers $usuario/" /etc/ssh/sshd_config
    else
        echo "AllowUsers $usuario" >> /etc/ssh/sshd_config
    fi

    # Reiniciar el servicio SSH para aplicar los cambios
    systemctl restart ssh
}

ssh_config

###################################################
########### Instalación de Docker #################
###################################################
install_docker() {
    # Actualizar repositorios e instalar dependencias
    apt-get update
    apt-get install -y ca-certificates curl

    install -m 0755 -d /etc/apt/keyrings

    # Agregar la clave GPG oficial de Docker para Debian
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Debian 13 usa "trixie". Si VERSION_CODENAME no existe, se usa trixie como fallback.
    . /etc/os-release
    debian_codename="${VERSION_CODENAME:-trixie}"

    # Configurar el repositorio estable de Docker para Debian
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${debian_codename} stable" \
      > /etc/apt/sources.list.d/docker.list

    # Actualizar repositorios con la nueva fuente
    apt-get update

    # Instalar Docker Engine, CLI, containerd, Buildx y el plugin de Docker Compose
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Habilitar e iniciar el servicio de Docker
    systemctl enable --now docker

    # Agregar el usuario creado al grupo docker para usar docker sin sudo
    usermod -aG docker "$usuario"
}

install_docker

echo "----------------------------------------------"
echo "Configuración completada para Debian GNU/Linux 13."
echo "Recuerda reiniciar tu sesión para aplicar los cambios de grupo."
