#!/bin/bash

set -euo pipefail

###################################################
######-------Declarar variables--------############
###################################################
MYSQLUser=''
MYSQLPassword=''
MYSQLRootPassword=''
DockerComposeDir="$HOME/docker-compose/nginxproxy"
DockerComposePath="$DockerComposeDir/docker-compose.yml"

###################################################
######----------Instalación------------############
###################################################
mkdir -p "$DockerComposeDir"

cat > "$DockerComposePath" <<EOF
services:
  app:
    container_name: NginxProxyManager_WEB
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    environment:
      DB_MYSQL_HOST: 'db'
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "${MYSQLUser}"
      DB_MYSQL_PASSWORD: "${MYSQLPassword}"
      DB_MYSQL_NAME: 'npm'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    depends_on:
      - db

  db:
    container_name: NginxProxyManager_DB
    image: 'mariadb:lts'
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: "${MYSQLRootPassword}"
      MYSQL_DATABASE: 'npm'
      MYSQL_USER: "${MYSQLUser}"
      MYSQL_PASSWORD: "${MYSQLPassword}"
    volumes:
      - ./data/mysql:/var/lib/mysql
EOF

cd "$DockerComposeDir"

docker compose up -d

###################################################
######-------POST-Instalación----------############
###################################################
# Entrar en el navegador a: http://<tu ip publica>:81
# Iniciar sesión con los valores por defecto:
# Email:    admin@example.com
# Password: changeme
