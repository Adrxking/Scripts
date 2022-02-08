# ! --> Script con Menu para crear reglas iptables o visualizarlas

#!/bin/bash
##########################################
##--- COMPROBAR QUE TENEMOS IPTABLES ---##
##########################################
REQUIRED_PKG="iptables"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
if [ "" = "$PKG_OK" ]; then
  echo "No existe $REQUIRED_PKG. Instalelo y vuelva a intentarlo."
  exit 0;
fi

# Comprobar que el usuario es root
if [ "$EUID" -ne 0 ]; then
    echo "Debes ser root"
    exit
fi

##########################################
##--- DEFINICION DE FUNCIONES COMUNES --##
##########################################
# Funcion que muestra que se ha elegido una tabla invalida y vuelve a ejecutar el bucle
tablaInvalida() {
    echo "Tabla seleccionada invalida"
    read -p "Pulsa cualquier tecla para continuar..." pausa
    continue
}

# Funcion que muestra que se ha elegido una cadena invalida y vuelve a ejecutar el bucle
cadenaInvalida() {
    echo "Cadena seleccionada invalida"
    read -p "Pulsa cualquier tecla para continuar..." pausa
    continue
}

# Funcion que muestra las cadenas de la tabla mangle y se comprueba que se haya introducido una valida
getFilterChain() {
    read -p "Que cadena deseas utilizar? opciones: (output, forward, input) --> " iptablesChain
    # Cambiar la variable introducida por el usuario a uppercase
    iptablesChain=${iptablesChain^^}

    # Comprobar que el usuario ha introducido una cadena valida
    if [[ "$iptablesChain" != "OUTPUT" && "$iptablesChain" != "FORWARD" && "$iptablesChain" != "INPUT" ]]; then
        cadenaInvalida()
    fi 
}

# Funcion que muestra las cadenas de la tabla mangle y se comprueba que se haya introducido una valida
getNatChain() {
    read -p "Que cadena deseas utilizar? opciones: (prerouting, postrouting, output) --> " iptablesChain
    # Cambiar la variable introducida por el usuario a uppercase
    iptablesChain=${iptablesChain^^}

    # Comprobar que el usuario ha introducido una cadena valida
    if [[ "$iptablesChain" != "PREROUTING" && "$iptablesChain" != "POSTROUTING" && "$iptablesChain" != "OUTPUT" ]]; then
        cadenaInvalida()
    fi 
}


# Funcion que muestra las cadenas de la tabla mangle y se comprueba que se haya introducido una valida
getMangleChain() {
    read -p "Que cadena deseas utilizar? opciones: (prerouting, postrouting, forward, input, output) --> " iptablesChain
    # Cambiar la variable introducida por el usuario a uppercase
    iptablesChain=${iptablesChain^^}

    # Comprobar que el usuario ha introducido una cadena valida
    if [[ "$iptablesChain" != "PREROUTING" && "$iptablesChain" != "POSTROUTING" && "$iptablesChain" != "OUTPUT" && "$iptablesChain" != "INPUT" && "$iptablesChain" != "FORWARD" ]]; then
        cadenaInvalida()
    fi
}

getIpPortChoices() {
            read -p "Introduce la ip de origen. (Dejar vacio si queremos cualquiera) --> " iptablesSourceIp
            read -p "Introduce la ip de Destino. (Dejar vacio si queremos cualquiera) --> " iptablesDestinationIp
            
            read -p "Introduce el puerto de origen. (Dejar vacio si queremos cualquiera) --> " iptablesSourcePort
            read -p "Introduce el puerto de Destino. (Dejar vacio si queremos cualquiera) --> " iptablesDestinationPort
}

getProtocol() {
    read -p "Introduce el protocolo. opciones: (tcp, upd) --> " iptablesProtocol

    # Comprobar que el protocolo introducido es valido
    if [[ "$iptablesProtocol" != "tcp" && "$iptablesProtocol" != "udp" ]]; then
        echo "Protocolo invalido"
        read -p "Pulsa cualquier tecla para continuar..." pausa
        continue
    fi 
}

getAction() {
    read -p "Introduce que accion deseas realizar. opciones: (accept, reject, drop) --> " iptablesAction

    # Cambiar la variable introducida por el usuario a uppercase
    iptablesAction=${iptablesAction^^}

    # Comprobar que la accion introducida es valida
    if [[ "$iptablesAction" != "ACCEPT" && "$iptablesAction" != "REJECT" && "$iptablesAction" != "DROP" ]]; then
        echo "Accion invalida"
        read -p "Pulsa cualquier tecla para continuar..." pausa
        continue
    fi 
}

# Funcion que muestra las opciones del menu
getOptions() {
    echo "1) Crear Regla Iptables"
    echo "2) Eliminar Regla Iptables"
    echo "3) Visualizar Reglas"
    echo "4) Resetear todas las Reglas"
    echo "5) Salir"
}

##########################################
#####------ COMIENZO DEL SCRIPT -----#####
##########################################
# Limpiar la pantalla al lanzar el menu
clear

# Ejecucion de la funcion para que muestre las opciones del menu
getOptions

# Leer la opcion introducida por el usuario
read -p "Introduce una opcion --> " option

clear
# Bucle de permanecer en el menu hasta que el usuario introduzca la opcion 4
while [[ ${option} != 5 ]]
do
clear
    # Comprobar que ha introducido el usuario
    case ${option} in
        1)
            # Si el usuario introduce la opcion 1 le ayudamos a crear una regla iptables
            read -p "Que tabla deseas utilizar? opciones: (filter) --> " iptablesTable

            # Comprobar si el usuario ha introducido la opcion filter
            if [ "$iptablesTable" == "filter" ]; then

                getFilterChain()
                
                getIpPortChoices()
            
                getProtocol()

                getAction()

                # Guardar el comando iptables con las opciones del usuario obligatorias 
                iptablesCommand="iptables -t $iptablesTable -A $iptablesChain -p $iptablesProtocol"

                # Comprobar si existe una ip de origen asignada por el usuario
                if [ "$iptablesSourceIp" != "" ]; then
                    # Añadir la ip de origen a la regla
                    iptablesCommand="$iptablesCommand -s $iptablesSourceIp"
                fi

                # Comprobar si existe una ip de destino asignada por el usuario
                if [ "$iptablesDestinationIp" != "" ]; then
                    # Añadir la ip de origen a la regla
                    iptablesCommand="$iptablesCommand -d $iptablesDestinationIp"
                fi

                # Comprobar si existe un puerto de origen asignado por el usuario
                if [ "$iptablesSourcePort" != "" ]; then
                    # Añadir la ip de origen a la regla
                    iptablesCommand="$iptablesCommand --sport $iptablesSourcePort"
                fi

                # Comprobar si existe un puerto de destino asignado por el usuario
                if [ "$iptablesDestinationPort" != "" ]; then
                    # Añadir la ip de origen a la regla
                    iptablesCommand="$iptablesCommand --dport $iptablesDestinationPort"
                fi

                # Terminar de poner en el comando iptables la accion introducida por el usuario
                iptablesCommand="$iptablesCommand -j $iptablesAction"

                $iptablesCommand

                if [ $? -eq 0 ]; then
                    echo "Regla creada correctamente..."
                else
                    echo "Ocurrio un problema creando la regla..."
                fi

            else
                echo "Tabla seleccionada invalida"
                read -p "Pulsa cualquier tecla para continuar..." pausa
                continue
            fi
        ;;
        2)
            # Funcion que muestra las reglas, pide un input del numero de linea que queremos borrar y se ejecuta
            eliminarRegla() {
                echo ""
                iptables -t filter -L
                echo ""
                
                read -p "Observa encima las reglas de la tabla $iptablesTable, elige el numero de linea que deseas eliminar --> " iptablesLine
                
                
                # Terminar de poner en el comando iptables la accion introducida por el usuario
                iptables -t $iptablesTable -v -L $iptablesChain -n $iptablesLine

                echo "Regla eliminada correctamente..."
            }

            # Si el usuario introduce la opcion 2 le ayudamos a eliminar una regla iptables
            read -p "De que table deseas eliminar una regla? opciones: (filter, nat, mangle) --> " iptablesTable

            # Comprobar si el usuario ha introducido la opcion filter
            if [ "$iptablesTable" == "filter" ]; then
                getFilterChain()

                eliminarRegla()


            # Comprobar si el usuario ha introducido la opcion nat
            elif [ "$iptablesTable" == "nat" ]; then
                getNatChain()

                eliminarRegla()

            # Comprobar si el usuario ha introducido la opcion mangle
            elif [ "$iptablesTable" == "mangle" ]; then
                getMangleChain()

                eliminarRegla()

            else
                tablaInvalida()
            fi

        ;;
        3)
            # Si el usuario introduce la opcion 2 le mostramos las reglas de la tabla que nos introduzca a continuacion.
            # Funcion que muestra las opciones del menu
            getTableOptions() {
                echo "1) Visualizar tabla NAT"
                echo "2) Visualizar tabla filter"
                echo "3) Visualizar tabla mangle"
                echo "4) Salir"
            }

            # Ejecucion de la funcion para que muestre las opciones del menu
            getTableOptions

            # Leer la opcion introducida por el usuario
            read -p "Introduce una opcion --> " optionTable

            clear
            # Bucle de permanecer en el menu hasta que el usuario introduzca la opcion 4
            while [[ ${optionTable} != 4 ]]
            do
            clear
                # Comprobar que ha introducido el usuario
                case ${optionTable} in
                    1)
                        # Si el usuario introduce la opcion 1 le mostramos la tabla NAT
                        iptables -t nat -L
                        
                    ;;
                    2)
                        # Si el usuario introduce la opcion 2 le mostramos la tabla FILTER
                        iptables -t filter -L

                    ;;
                    3)
                        # Si el usuario introduce la opcion 2 le mostramos la tabla FILTER
                        iptables -t mangle -L

                    ;;
                    *)
                        # En caso de q el usuario introduzca una opcion no valida se mostrara lo siguiente
                        echo "Opcion no valida"
                    ;;
                esac
                # Al final de cada opcion se pide que el usuario teclee cualquier tecla para continuar
                echo ""
                read -p "Pulsa cualquier tecla para continuar..." pausa

                clear

                # Volvemos a mostrar las opciones del menu
                getTableOptions
                read -p "Introduce una nueva opcion --> " optionTable    
            done
            clear
            echo "Has salido de las visualizaciones de las reglas :)"
            echo ""
        ;;
        4)
            # Si el usuario introduce la opcion 3 reseteamos las reglas del iptables
            echo "Reseteando reglas..."
            iptables -F
            echo "Reglas del iptables reseteadas."
        ;;
        *)
            # En caso de q el usuario introduzca una opcion no valida se mostrara lo siguiente
            echo "Opcion no valida"
        ;;
    esac
    # Al final de cada opcion se pide que el usuario teclee cualquier tecla para continuar
    echo ""
    read -p "Pulsa cualquier tecla para continuar..." pausa

    clear

    # Volvemos a mostrar las opciones del menu
    getOptions
    read -p "Introduce una nueva opcion --> " option    
done
clear
echo "Has cerrado el programa :)"
echo ""