#!/bin/bash

###################################################
######-----Guardar copia del resolv.conf-----###
###################################################
sudo mv /etc/resolv.conf /etc/resolv.conf.original

###################################################
######-----Modificar resolv.conf-----###
###################################################

touch /etc/resolv.conf

echo 'nameserver 1.1.1.1' > /etc/resolv.conf