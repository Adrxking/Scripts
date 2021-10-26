#!/bin/bash
# * SCRIPT PARA LISTAR USUARIOS CON NOMBRE, APELLIDOS, TELÉFONO Y CORREO  * #

dominio=' "dc=ies,dc=local" '
filtro=' "(objectClass=Person)" '
filtroRespuesta="telephoneNumber mail sn givenName"
nombre="Nombre"
apellido="Apellidos"


echo ""

original=`ldapsearch -xLLL -b $dominio $filtro $filtroRespuesta`
echo $original

echo ""