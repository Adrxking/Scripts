#!/bin/bash
clear

if [ $# = 2 ]
 then
   if [[ $1 -gt 0 ]] && [[ $1 -lt 13 ]]
    then
     case $1 in 
     1)
     	if [ $2 = 31 ]
     	 then 
     	  echo "El mes de enero tiene 31 dias"
     	else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi 
     	;;
     2)
     	if [ $2 -eq 28 ]
     	 then 
     	  echo "El mes de febrero tiene 28 dias"
     	 else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
     3)
     	if [ $2 -eq 31 ]
     	 then 
     	  echo "El mes de marzo tiene 31 dias"
     	 else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
     4)
     	if [ $2 -eq 30 ]
     	 then 
     	  echo "El mes de abril tiene 30 dias"
     	 else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
     5)
     	if [ $2 -eq 31 ]
     	 then 
     	  echo "El mes de mayo tiene 31 dias"
     	 else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
     6)
     	if [ $2 -eq 30 ]
     	 then 
     	  echo "El mes de junio tiene 30 dias"
     	 else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
     7)
     	if [ $2 -eq 31 ]
     	 then 
     	  echo "El mes de julio tiene 31 dias"
     	 else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
     8)
     	if [ $2 -eq 31 ]
     	 then 
     	  echo "El mes de agosto tiene 31 dias"
     	 else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
     9)
     	if [ $2 -eq 30 ]
     	 then 
     	  echo "El mes de septiembre tiene 30 dias"
     	 else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
     10)
     	if [ $2 -eq 31 ]
     	 then 
     	  echo "El mes de octubre tiene 31 dias"
     	 else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
     11)
     	if [ $2 -eq 30 ]
     	 then 
     	  echo "El mes de noviembre tiene 30 dias"
     	 else
     	 echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
     12)
     	if [ $2 -eq 31 ]
     	 then 
     	  echo "El mes de diciembre tiene 31 dias"
     	 else
     	  echo "El mes introducido no se corresponse con el numero de dias introducido"
     	fi
     ;;
    esac
   else
    echo "El parametro 1 debe estar entre 1 y 12"
   fi
  else
   echo "Numero de parametros incorrecto, introduzca 2 parámetros"
fi
