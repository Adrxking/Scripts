#!/bin/bash

###################################################
######-------Declarate variables--------###########
###################################################
MYSQLUser=''
MYSQLPassword=''
MYSQLRootPassword=''
DockerComposePath='/docker-compose/nginxproxy/docker-compose.yml'

###################################################
######----------Installation------------###########
###################################################
mkdir /docker-compose
mkdir /docker-compose/nginxproxy
touch /docker-compose/nginxproxy/docker-compose.yml

echo "version: '3'" > $DockerComposePath
echo "services:" >> $DockerComposePath
echo "  app:" >> $DockerComposePath
echo "    container_name: NginxProxyManager_WEB" >> $DockerComposePath
echo "    image: 'jc21/nginx-proxy-manager:latest'" >> $DockerComposePath
echo "    restart: unless-stopped" >> $DockerComposePath
echo "    ports:" >> $DockerComposePath
echo "      - '80:80'" >> $DockerComposePath
echo "      - '81:81'" >> $DockerComposePath
echo "      - '443:443'" >> $DockerComposePath
echo "    environment:" >> $DockerComposePath
echo "      DB_MYSQL_HOST: 'db'" >> $DockerComposePath
echo "      DB_MYSQL_PORT: 3306" >> $DockerComposePath
echo "      DB_MYSQL_USER: \"${MYSQLUser}\" " >> $DockerComposePath
echo "      DB_MYSQL_PASSWORD: \"${MYSQLPassword}\" " >> $DockerComposePath
echo "      DB_MYSQL_NAME: 'npm'" >> $DockerComposePath
echo "    volumes:" >> $DockerComposePath
echo "      - ./data:/data" >> $DockerComposePath
echo "      - ./letsencrypt:/etc/letsencrypt" >> $DockerComposePath
echo "  db:" >> $DockerComposePath
echo "    container_name: NginxProxyManager_DB" >> $DockerComposePath
echo "    image: 'mariadb:latest'" >> $DockerComposePath
echo "    restart: unless-stopped" >> $DockerComposePath
echo "    environment:" >> $DockerComposePath
echo "      MYSQL_ROOT_PASSWORD: \"${MYSQLRootPassword}\" " >> $DockerComposePath
echo "      MYSQL_DATABASE: 'npm'" >> $DockerComposePath
echo "      MYSQL_USER: \"${MYSQLUser}\" " >> $DockerComposePath
echo "      MYSQL_PASSWORD: \"${MYSQLPassword}\" " >> $DockerComposePath
echo "    volumes:" >> $DockerComposePath
echo "      - ./data/mysql:/var/lib/mysql" >> $DockerComposePath

cd /docker-compose/nginxproxy/

docker-compose up -d

###################################################
######-------POST-Installation----------###########
###################################################
# Entrar en google a :  https://<tu ip publica>:81
# Iniciar sesion con los valores por defecto:
#Email:    admin@example.com
#Password: changeme