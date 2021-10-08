###################################################
##########-----Requisitos -----####################
###################################################
#Es servidor tiene asignado una IP estática.
#El archivo /etc/hostname contiene el nombre correcto del servidor.
#El archivo /etc/hosts contienen los nombres adecuados para el servidor.

###################################################
######-----Instalar ldap y slap-----###############
###################################################
apt install slapd ldap-utils -y

###################################################
######-----Iniciar instalacion-----################
###################################################
dpkg-reconfigure slapd

#* LANZAR DESDE ESTE PUNTO *#

#!/bin/bash

###################################################
######-----Comprobar que se ha instalado-----######
###################################################
sudo service slapd status
ldapsearch -x -LLL -b dc=ies,dc=local dn

###################################################
######-----Crear archivo plantillas-----###########
###################################################
touch /home/ldapPlantilla.ldif

###################################################
############-----Estructura-----###################
###################################################
echo dn: ou=usuarios,dc=ies,dc=local > /home/ldapPlantilla.ldif
echo objectclass: organizationalUnit >> /home/ldapPlantilla.ldif
echo ou: usuarios >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: ou=grupos,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: organizationalUnit >> /home/ldapPlantilla.ldif
echo ou: grupos >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: cn=alumnos,ou=grupos,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: posixGroup >> /home/ldapPlantilla.ldif
echo cn: alumnos >> /home/ldapPlantilla.ldif
echo gidNumber: 5002 >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: cn=profesores,ou=grupos,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectclass: posixGroup >> /home/ldapPlantilla.ldif
echo cn: profesores >> /home/ldapPlantilla.ldif
echo gidNumber: 5001 >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: uid=aresines,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectClass: inetOrgPerson >> /home/ldapPlantilla.ldif
echo objectClass: posixAccount >> /home/ldapPlantilla.ldif
echo uid: aresines >> /home/ldapPlantilla.ldif
echo sn: Resines >> /home/ldapPlantilla.ldif
echo cn: Antonio Resines >> /home/ldapPlantilla.ldif
echo uidNumber: 10001 >> /home/ldapPlantilla.ldif
echo gidNumber: 5001 >> /home/ldapPlantilla.ldif
echo userPassword: usuario >> /home/ldapPlantilla.ldif
echo loginShell: /bin/bash >> /home/ldapPlantilla.ldif
echo homeDirectory: /home/aresines >> /home/ldapPlantilla.ldif 
echo mail: aresines@ies.local >> /home/ldapPlantilla.ldif

echo '' >> /home/ldapPlantilla.ldif

echo dn: uid=pvega,ou=usuarios,dc=ies,dc=local >> /home/ldapPlantilla.ldif
echo objectClass: inetOrgPerson >> /home/ldapPlantilla.ldif
echo objectClass: posixAccount >> /home/ldapPlantilla.ldif
echo uid: pvega >> /home/ldapPlantilla.ldif
echo sn: Vega >> /home/ldapPlantilla.ldif
echo cn: Paz Vega >> /home/ldapPlantilla.ldif
echo uidNumber: 10002 >> /home/ldapPlantilla.ldif
echo gidNumber: 5002 >> /home/ldapPlantilla.ldif
echo userPassword: usuario >> /home/ldapPlantilla.ldif
echo loginShell: /bin/bash >> /home/ldapPlantilla.ldif
echo homeDirectory: /home/pvega >> /home/ldapPlantilla.ldif 
echo mail: pvega@ies.local >> /home/ldapPlantilla.ldif

ldapadd -x -W -D “cn=admin,dc=ies,dc=local” -f /home/ldapPlantilla.ldif 