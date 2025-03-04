#!/bin/bash
# Este script debe ejecutarse como root

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
read -p "Ingrese el nombre del nuevo usuario: " usuario

###################################################
########## Crear usuario y asignar sudo ###########
###################################################
# Se creará el usuario (se le pedirá la contraseña y otros datos)
adduser "$usuario"

# Añadir el usuario al grupo sudo
usermod -aG sudo "$usuario"

###################################################
########### Configuración del SSH ###############
###################################################
ssh_config() {
    # Deshabilitar el acceso SSH para el usuario root
    sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config

    # Establecer el puerto SSH especificado
    # Reemplaza tanto líneas comentadas como activas
    sed -i "s/^#\?Port .*/Port $puertoSSH/" /etc/ssh/sshd_config

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
########### Instalación de Docker ###############
###################################################
install_docker() {
    # Actualizar repositorios e instalar dependencias
    apt-get update
    apt-get install -y ca-certificates curl gnupg lsb-release

    # Agregar la clave GPG oficial de Docker y guardarla en un keyring
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Configurar el repositorio estable de Docker
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Actualizar repositorios con la nueva fuente
    apt-get update

    # Instalar Docker Engine, CLI, containerd y el plugin de Docker Compose (últimas versiones)
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Habilitar e iniciar el servicio de Docker
    systemctl enable --now docker

    # Agregar el usuario creado al grupo docker para usar docker sin sudo
    usermod -aG docker "$usuario"
}

install_docker

echo "----------------------------------------------"
echo "Configuración completada."
echo "Recuerda reiniciar tu sesión para aplicar los cambios de grupo."
