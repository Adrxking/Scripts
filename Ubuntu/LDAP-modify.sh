###################################################
########-----Estructura modificar-----#############
###################################################
touch /home/modify.ldif

echo dn: uid=pvega,ou=usuarios,dc=ies,dc=local > /home/modify.ldif
echo changetype: modify >> /home/modify.ldif
echo add: homePhone >> /home/modify.ldif
echo homePhone: +34 922 541 978 >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=pvega,ou=usuarios,dc=ies,dc=local >> /home/modify.ldif
echo changetype: modify >> /home/modify.ldif
echo delete: mail >> /home/modify.ldif

echo '' >> /home/modify.ldif

echo dn: uid=pvega,ou=usuarios,dc=ies,dc=local >> /home/modify.ldif
echo changetype: modify >> /home/modify.ldif
echo replace: mail >> /home/modify.ldif
echo mail: hola@ies.local >> /home/modify.ldif

ldapmodify -x -W -D "cn=admin,dc=ies,dc=local" -f /home/modify.ldif