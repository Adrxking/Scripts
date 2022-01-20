# ! --> Script para exportar usuarios a un fichero de texto:

# * Un segundo script se encargará de restaurar la copia de seguridad más 
# * reciente de uno o más usuarios pasados por parámetro.

# * El primer parametro del script sera el destino desde donde obtendremos los backups

#!/bin/bash
clear

# Comprobar que el usuario ha introducido 2 o mas parametros
if [ $# -le 1 ]; then
    echo "Debes introducir dos parametro o mas, el primero la ruta de los backup y la segunda el usuario."
    echo ""
    exit 0;
fi

# Comprobar que existe el destino desde donde obtendremos los backups
if ! [ -d $1 ]; then
    echo "La ruta $1 no existe, no hay un lugar desde donde obtener los backups."
    exit 0;
fi

# Desplazar los parametros uno hacia la derecha ya que el primer parametro es la ruta de los backups
shift 1
# Bucle para cada usuario introducido como parámetro 
for user in $*
do
    # Comprobar si existen los usuarios introducidos como parámetros
    if ! [ "$(grep -cw "^$user" /etc/passwd)" -ge 1 ]; then
        echo "$user no existe, no se puede realizar una restauracion de este usuario."
        continue;
    fi

    # Comprobar si existe algun backup sobre ese usuario
    if ! [ -f /disk1/userBackups/$user.tar ]; then
        echo "No existe ningun backup para el usuario $user"
        continue;
    fi

    # Comprobar si ya existe algun home para ese usuario, si no existe lo creamos desde el backup, si existe
    # pedimos al usuario que nos introduzca si quiere sustiuir el home del backup por el home actual
    if [ -d /home/$user ]; then
        flag=0
        until [[ ${flag} == 1 ]]
        do
            # Mostrar las opciones al usuario
            read -p "Actualme ya existe un home del usuario $user, ¿quiere borrar el home actual 
            y sustituirlo por el home del backup? y/n --> " option
            # Comprobar que ha introducido el usuario
            case ${option} in
                "y")
                    # Eliminando el home actual...
                    echo "Eliminando el home actual..."
                    rm -rf /home/$user
                    # Recuperando el home del recovery...
                    echo "Recuperando el home del recovery..."
                    tar -xzf /disk1/userBackups/$user.tar -C /
                    flag=1
                ;;
                "n")
                    # Abortar el recovery del usuario...
                    echo "Recovery del usuario $user skipeado"
                    flag=1
                ;;
                *)
                    # En caso de q el usuario introduzca una opción no válida se mostrará lo siguiente
                    echo "Opción no válida, introduzca y/n"
                ;;
            esac
            # Al final de cada opción se pide que el usuario teclee cualquier tecla para continuar
            echo ""
            read -p "Pulsa cualquier tecla para continuar..." pausa

            clear
        done
    else
        tar -xzf /disk1/userBackups/$user.tar -C /
    fi
    
done

echo ""
echo "Script de restauracion de copias de seguridad de usuarios finalizado correctamente."
echo ""