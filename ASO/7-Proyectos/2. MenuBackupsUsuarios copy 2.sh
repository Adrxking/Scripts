# ! --> Script con Menú para importar o exportar usuarios usando 2 scripts externos

# * El script debe preguntar si queremos crear un backup
# * o restaurar ciertos usuarios. ✓

#!/bin/bash

# Limpiar la pantalla al lanzar el menú
clear

# Función que muestra las opciones del menú
getOptions() {
    echo "1) Backup usuarios"
    echo "2) Restaurar usuarios"
    echo "3) Salir"
}

# Ejecución de la funcion para que muestre las opciones del menú
getOptions

# Leer la opción introducida por el usuario
read -p "Introduce una opción --> " option

clear
# Bucle de permanecer en el menú hasta que el usuario introduzca la opción 3
while [[ ${option} != 3 ]]
do
clear
    # Comprobar que ha introducido el usuario
    case ${option} in
        1)
            # Si el usuario introduce la opción 1 le pedimos que introduzca un archivo de importación
            read -p "Introduce un archivo de importacion de usuarios --> " import
            # Comprobamos que el archivo de importación existe
            if [ -f $import ]; then
                bash import.sh $import
            else
                echo "El archivo de importacion no existe"
            fi
        ;;
        2)
            # Si el usuario introduce la opción 2 creamos un archivo con los usuarios del sistema y su grupo
            bash export.sh
        ;;
        *)
            # En caso de q el usuario introduzca una opción no válida se mostrará lo siguiente
            echo "Opción no válida"
        ;;
    esac
    # Al final de cada opción se pide que el usuario teclee cualquier tecla para continuar
    echo ""
    read -p "Pulsa cualquier tecla para continuar..." pausa

    clear

    # Volvemos a mostrar las opciones del menú
    getOptions
    read -p "Introduce una nueva opción --> " option    
done
clear
echo "Has cerrado el programa :)"
echo ""