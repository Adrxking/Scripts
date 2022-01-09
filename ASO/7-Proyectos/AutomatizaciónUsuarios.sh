# ! --> Script para crear usuarios importados desde un archivo de texto:

# * El script debe recibir como parámetro el nombre del archivo y debe comprobar que el archivo existe.

# * En el archivo debe aparecer en cada línea el usuario, un carácter de dos puntos para separar
# * los campos, grupo primario y comentario (Ejemplo: pepe:users:Usuario pepe).

# * Cuando creas un usuario con useradd y pones la contraseña en -p tienes que poner la contraseña cifrada
# * mkpassword cifra textos en formato de contraseña

# * Si la carpeta personal del usuario no existe se debe crear.

# * A los usuarios creados se les asignará la shell /bin/bash.

# * Si el usuario se crea correctamente se guardará un fichero llamado usuarios.log en el que debe 
# * aparecer cada usuario creado junto con su clave temporal asignada.

#!/bin/bash

if [ -f $1 ]
then
    for i in $(cat $1)
    do
        name=$( echo $i | cut -d ":" -f 1 )
        group=$( echo $i | cut -d ":" -f 2 )
        
        if ! [[ -d ~/${name} ]]
         then
            mkdir ~/${name}
        fi

        passwd=$( echo $RANDOM )

        shortPasswd="${passwd:0:4}"

        groupadd "${group}"

        useradd "${name}" -g "${group}" -p "${shortPasswd}" -s "/bin/bash"

        if [ $? -eq 0 ]
         then
            echo "Usuario: ${name} --- Clave Temporal: ${shortPasswd}" >> ~/usuarios.log
        else
            echo "Ha ocurrido un error creando el usuario"
        fi
    done
else
    echo "El archivo introducido no existe."
fi