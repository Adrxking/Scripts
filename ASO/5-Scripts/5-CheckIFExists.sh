# * EJEMPLO 1 * #

###################################################
####-----Comprobar si existe un fichero-----#######
###################################################
#!/bin/bash
if [ -f fichero ]
then
    echo "El fichero existe"
else
    echo "El fichero existe"
fi
exit 0


###################################################
####-----Comprobar si adivinan mi edad------#######
###################################################
#!/bin/bash

echo "Introduce cuál crees que es mi edad:"
read edad

if [ $edad -eq 19 ]
then
    echo "Has acertado mi edad: $edad"

else
    echo "Has fallado, vuelve a intentarlo"

fi
exit 0

###################################################
####---Comprobar si el numero es positivo---#######
###################################################
#!/bin/bash


echo "Introduce un número"
read numero

re='^[+-]?[0-9]+([.][0-9]+)?$'

while ! [[ $numero =~ $re ]]
do
    echo "Introduce un número entero"
    read numero
done

if [ $numero -lt 0 ]
then
    echo "El número: $numero es negativo"

elif [ $numero -gt 0 ]
then
    echo "El número: $numero es positivo"

else
    echo "El número es 0"

fi
exit 0