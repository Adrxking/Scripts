# ! 3) Crear un script que permita el borrado seguro de archivos, para ello se intentará imitar la función 
# ! de la papelera de reciclaje de Windows. (4 puntos)

# * El script debe crear, si no existe, un directorio llamado papelera en la carpeta personal del usuario 
# * y debe implementar las siguientes funciones:

# * Con la opción -d se enviará todos los archivos pasados como parámetro a la papelera. 
# * (Ejemplo: papelera.sh -d fichero1 fichero2 fichero3). Los archivos mayores a 2GB se eliminarán directamente 
# * sin enviarse a la papelera.

# * Con la opción -l se mostrarán todos los archivos de la papelera. Si hay archivos almacenados en el directorio 
# * de la papelera durante más de siete días se eliminarán automáticamente antes de mostrar el listado.

# * Con la opción -r se restaurarán todos los archivos almacenados en la papelera que se pasen como parámetro 
# * (Ejemplo: papelera.sh -r fichero2).

# * Con la opción -v se vaciará completamente la papelera.

#!/bin/bash

if ! [ -d ~/papelera ]
then 
    mkdir ~/papelera
fi

case $1 in 
    -d)
        for i in $*
        do
            if [ $i == $1 ]
             then
                continue;
            fi

            if [ $(du -BG $i | cut -d "G" -f 1) -ge 2 ]
            then
                rm $i
            else
                mv $i ~/papelera/
            fi

        done
    ;;
    -l)
        for i in $(ls ~/papelera/)
        do
            for viejo in $( find . -mtime +7 )
            do
                if [ "$viejo" == "." ]
                then
                    continue
                fi
                rm ~/papelera/$viejo
            done
        done
        ls ~/papelera/
    ;;
    -r)
        if ! [ -d ~/recovery/ ]
        then
            mkdir ~/recovery/
        fi

        for i in $*
        do
            if [ $i == $1 ]
             then
                continue;
            fi
            if [ -f ~/papelera/$i ]
             then
                mv ~/papelera/$i ~/recovery/
            else
                echo "No existe el archivo ${i} en la papelera"
            fi
        done
    ;;
    -v)
        rm -rf ~/papelera/*
    ;;
esac