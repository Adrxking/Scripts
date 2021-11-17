#! /bin/bash

###################################################
########--------DIFERENCIAL BACKUP-------##########
###################################################
clear
echo ""
echo ""

read -p "Introduce el path del archivo al que hacer el backup diferencial" forBackup

read -p "Introduce el path del último backup de ese archivo" lastBackup

clear
echo ""
echo ""

tar -cvzf $HOME/Prac1T3/backup-4/`date +%d-%m-%Y`.tgz -N /home/usuario/Prac1T3/backup-4/tarea4-dia1.tgz /home/usuario/Prac1T3/tarea4