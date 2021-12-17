#!/bin/bash

options() {
    echo "1. Versión de Kernel."
    echo "2. Procesador (modelo)."
    echo "3. Memoria Principal (GB)."
    echo "4. Memoria Swap (GB)."
    echo "5. Usuarios conectados."
    echo "6. Salir."
}

clear

options

read -p "Selecciona una opción --> " opcion

while [[ ${opcion} != 6 ]]
do
    clear
    case ${opcion} in
        1)  
            echo "Versión de Kernel."
            echo ""
            cat /proc/version
        ;;
        2)  
            echo "Procesador (modelo)."
            echo ""
            cat /proc/cpuinfo | egrep ^model.name
        ;;
        3)  
            echo "Memoria Principal (GB)."
            echo ""
            free -h | egrep ^Mem
        ;;
        4)  
            echo "Memoria Swap (GB)."
            echo ""
            free -h | egrep ^Swap
        ;;
        5)  
            echo "Usuarios conectados."
            echo ""
            who
        ;;
        *) 
            echo "Has introducido un número inválido, vuelta a intentarlo"
        ;;
    esac

    echo ""
    read -p "Pulse cualquier tecla para continuar..." pausa

    clear

    options

    read -p "Selecciona una opción --> " opcion
done

clear

echo ""
echo ""

echo "El programa ha finalizado correctamente :)"

echo ""
echo ""