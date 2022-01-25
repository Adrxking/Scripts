# ! --> Script para monitorear los recursos del sistema.

# * El script monitorea la RAM

# * El script manda un email de aviso si algún recurso está por debajo del limite establecido

# * El script creara un log cada vez que se monitorean los recursos

#!/bin/bash
function SystemInfo() {
    # Mostrar el nombre del sistema
    echo "Nombre del Sistema : `hostname`">>$LOG

    # Mostrar la version del Kernel
    echo "">>$LOG
    echo "Version del Kernel : `uname -r`">>$LOG
    echo "">>$LOG

    # Comprobar el tiempo que lleva encendido nuestro sistema
    echo "Tiempo levantado : `uptime | sed 's/.*up ([^,]*), .*/1/'`">>$LOG
    echo "">>$LOG

    # Obtener la carga de la CPU y mostrar un mensaje que indica si es una carga normal, peligrosa o muy peligrosa
    uptime | awk -F'load average:' '{ print $2 }' | cut -f1 -d, | awk '{if ($1 > 2) print "Carga de la CPU: " $1 " - Muy peligrosa"; else if ($1 > 1) print "Carga de la CPU: " $1 " - Peligrosa"; else print "Carga de la CPU: " $1 " - Normal"}'>>$LOG
    echo "">>$LOG
}

function Ram_Monitor() {
    # Obtener la memoria ram con el comando free y awk.
    RAM_FREE=`free -m | grep 'Mem:' | awk {'print $4'}`
    RAM_AVAILABLE=`free -m | grep 'Mem:' | awk {'print $2'}`

    echo "RAM disponible: $RAM_AVAILABLE MB">>$LOG
    echo "RAM libre: $RAM_FREE MB">>$LOG
    echo "">>$LOG
}

# Obtener las particiones con un uso mayor del especificado
function Disk_Monitor() {
    # Porcentaje de uso maximo permitido
    Disk_limit="20"

    # Adelantamos el head 2 posiciones ya que omitimos el filesystem y el overlay del comando df -kh
    i=3

    # Obtener los porcentajes de cada particion
    particiones=`df -kh |grep -v "Filesystem" | grep -v "overlay" | awk '{ print $5 }' | sed 's/%//g'`

    for porcentaje in $particiones; do

        if ((porcentaje > Disk_limit)); then

            particion=`df -kh | head -$i | tail -1| awk '{print $1}'`

            echo "La particion $particion esta al ${porcentaje}%">>$LOG
            echo "">>$LOG

        fi

    let i=$i+1

    done
}

clear

# Fecha y hora del script, se usa para el LOG
DATE=`date +%F`
TIME=`date +%H:%M`

# Directorio del LOG
DIRLOG=/var/logs/resources
if ! [ -d $DIRLOG ]; then
    echo "El directorio $DIRLOG para los logs no existe"
    echo "Creando directorio $DIRLOG..."
    mkdir -p $DIRLOG
fi

# Ruta de los ficheros de LOG y Warnings
LOG="$DIRLOG/resources_$DATE.txt"
 
echo "">>$LOG
echo "Resultado del dia $DATE a las $TIME">>$LOG
echo "">>$LOG

SystemInfo
Ram_Monitor
Disk_Monitor

echo "Fin del reporte de monitoreo de recursos, puedes consultarlo en $LOG"
echo ""