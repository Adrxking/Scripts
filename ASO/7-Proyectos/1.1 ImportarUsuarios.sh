# ! --> Script para crear usuarios importados desde un archivo de texto y exportar los usuarios a un fichero de texto:

# * El script debe recibir como parámetro el nombre del archivo y debe comprobar que el archivo existe. ✓

# * En el archivo debe aparecer un carácter de dos puntos para separar los campos.
# * los campos son: Nombre, Grupo primario y Comentario (Ejemplo: pepe:users:Usuario pepe). ✓

# * Si la carpeta personal del usuario no existe se debe crear. ✓

# * A los usuarios creados se les asignará la shell /bin/bash. ✓

# * Si el usuario se crea correctamente se guardará un fichero llamado usuarios.log en el que debe 
# * aparecer cada usuario creado junto con su clave temporal asignada. ✓

#!/bin/bash

if [ -f $1 ]
then
    # Para que el bucle for no cree una nueva $i cuando encuentre espacios, solo cuando haya salto de línea
    IFS=$'\n'

    # Bucle de todas las líneas del archivo a importar
    for i in $(cat $1)
    do
        # Guardar en variables los diferentes campos del usuario
        name=$( echo $i | cut -d ":" -f 1 )
        group=$( echo $i | cut -d ":" -f 2 )
        comment=$( echo $i | cut -d ":" -f 3 )
        
        # Comprobar si existe el grupo, crearlo en caso contrario
        if ! grep -q $group /etc/group
         then
            groupadd "${group}"
        fi

        # Comprobar si existe el usuario, crearlo en caso contrario
        if ! grep -q $name /etc/passwd
         then
            # Generar contraseña random de máximo 6 números
            passwd=$( echo $RANDOM )
            shortPasswd="${passwd:0:6}"

            # Crear el usuario
            useradd "${name}" -g "${group}" -p "${shortPasswd}" -s "/bin/bash" -c "${comment}"

            # Comprobar si el usuario ha sido creado correctamente
            if [ $? -eq 0 ]
             then

                # Crear un home para el usuario si no lo tiene
                if ! [[ -d ~/${name} ]]
                 then
                    mkdir ~/${name}
                fi

                # Añadir el usuario al log de usuarios creados con sus contraseñas temporales
                echo "Usuario: ${name} --- Clave Temporal: ${shortPasswd}" >> ~/usuarios.log

            else
                echo "Ha ocurrido un error creando el usuario ${name}"
            fi
            
         else
            echo "El usuario ${name} ya existe"
        fi
    done
else
    echo "El archivo introducido no existe."
fi