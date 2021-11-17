#! /bin/bash

###################################################
########--------INCREMENTAL BACKUP-------##########
###################################################

tar -cvzf /home/usuario/Prac1T3/backup-4/`date +%d-%m-%Y`.tgz -g /home/usuario/Prac1T3/backup-4/snapshot.tgz /home/usuario/Prac1T3/tarea4