# ! --> Script con Menú para obtener los recursos del sistema o obtener informacion o crear iptables

#!/bin/bash

# Limpiar la pantalla al lanzar el menú
clear

# Función que muestra las opciones del menú
getOptions() {
    echo "1) Obtener log con los recursos del sistema"
    echo "2) Ejecutar menu de iptables"
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
            # Si el usuario introduce la opción 1 ejecutamos el script de obtener los recursos del sistema
            bash monitoreo.sh
            
        ;;
        2)
            # Si el usuario introduce la opción 2 le ofrecemos el menu de iptables
            bash iptables.sh
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