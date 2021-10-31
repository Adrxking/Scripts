#!/bin/bash

###################################################
######-------Declarate variables--------###########
###################################################
usuario=''
dockerComposeVersion='1.29.2'

###################################################
######--------Configurate Users-------#############
###################################################
adduser=$usuario

usermod -a -G sudo $usuario

ssh_config() {
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    echo "" >> /etc/ssh/sshd_config
    echo "AllowUsers ${usuario}" >> /etc/ssh/sshd_config
    service ssh restart
}

ssh_config

###################################################
######----------Install Docker--------#############
###################################################

install_docker() {
    apt-get install apt-transport-https  ca-certificates curl gnupg-agent software-properties-common npm -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    sudo curl -L "https://github.com/docker/compose/releases/download/${dockerComposeVersion}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    usermod -a -G docker $usuario
}

install_docker

