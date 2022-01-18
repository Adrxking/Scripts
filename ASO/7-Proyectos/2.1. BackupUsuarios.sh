# ! --> Script para exportar usuarios a un fichero de texto:

# * El primer script debe crear un archivo comprimido con el home de cada usuario pasado por parámetro.

# * La copia de seguridad se debe guardar en una unidad diferente a la ubicación de las carpetas personales 
# * de los usuarios o en un equipo remoto.

# * Para gestionar eficientemente el espacio de almacenamiento la copia de seguridad se debe comprimir y al 
# * realizar una nueva copia de un usuario se eliminarán las copias más antiguas.

# * Un segundo script se encargará de restaurar la copia de seguridad más reciente de uno o 
# * más usuarios pasados por parámetro.

#!/bin/bash
clear

# Comprobar que el usuario ha introducido 1 o mas parametros
if [ $# == 0 ]; then
    echo "Debes introducir un parametro o mas, los cuales son los usuarios."
    echo ""
    exit 0;
fi

# Comprobar que existe el destino donde guardaremos los backups
if ! [ -d /disk1/userBackups ]; then
    echo "La ruta /disk1/userBackups no existe, creela antes de comenzar."
    echo ""
    exit 0;
fi

# bucle para cada usuario introducido como parámetro 
for user in $*
do
    # Comprobar si existen los usuarios introducidos como parámetros
    if ! [ "$(grep -cw "^$user" /etc/passwd)" -ge 1 ]; then
        echo "$user no existe, no se puede realizar un backup de este usuario."
        continue;
    fi

    # Comprobamos que el usuario tiene un home sobre el que realizar un backup
    if [ -d /home/$user ]; then
        # Comprobar si ya existe algun backup de este usuario, si existe lo eliminamos
        if [ -f /disk1/userBackups/$user.tar ]; then
            rm -rf /disk1/userBackups/$user.tar
        fi

        # Creamos un nuevo backup de este usuario
        tar -zcpf /disk1/userBackups/$user.tar /home/$user
        echo "Tar del usuario $user creado correctamente"
    fi
done

echo ""
echo "Script de copias de seguridad de usuarios finalizado correctamente."
echo ""