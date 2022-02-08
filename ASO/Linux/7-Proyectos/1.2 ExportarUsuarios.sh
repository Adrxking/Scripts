# ! --> Script para exportar usuarios a un fichero de texto:

# * El script debe obtener los usuarios del sistema (/etc/passwd) ✓

# * Buscar los usuarios con un identificador >= 999 ✓

# * En el archivo que se genera debe aparecer un carácter de dos puntos para separar los campos.
# * Los campos son: Nombre, Grupo primario (Ejemplo: pepe:users). ✓

#!/bin/bash

# Comprobar si ya existe un archivo de exportación y eliminarlo en caso positivo
if [ -f usersExported.txt ]; then
    rm usersExported.txt
fi

# Bucle de todos los usuarios con ID >= 999 y diferente de 65534 ya que es el nobody
for user in $(awk -F ':' '$3>=999 && $3!=65534 {print $1":"$4}' /etc/passwd); do
    # Bucle de todos los grupos con ID >= 999 y diferente de 65534 ya que es el nogroup
    for group in $(awk -F ':' '$3>=999 && $3!=65534 {print $1":"$3}' /etc/group); do
        # Guardar el nombre del usuario en una variable
        username=$(echo $user | cut -d ":" -f 1)
        # Guardar el GID del usuario en una variable
        userGID=$(echo $user | cut -d ":" -f 2)
        # Guardar el nombre del grupo en una variable
        groupname=$(echo $group | cut -d ":" -f 1)
        # Guardar el ID del grupo en una variable
        groupID=$(echo $group | cut -d ":" -f 2)
        # Comprobar si el GID del usuario es igual al ID del grupo
        if [ "$userGID" == "$groupID"  ]; then
            # En caso positivo se guarda el nombre del usuario y el nombre del grupo en el archivo de exportacion
            echo $username":"$groupname >> usersExported.txt
        fi
    done
done

echo "Usuarios exportados correctamente a usersExported.txt"