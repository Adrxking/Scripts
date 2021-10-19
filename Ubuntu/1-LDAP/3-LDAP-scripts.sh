###################################################
#########-----Modificar el conf-----###############
###################################################
SERVER=localhost
BINDDN='dn=admin, dc=ies, dc=local'
BINDPWDFILE="/etc/ldapscripts/ldapscripts.passwd"
UIDSTART=10001
LDAPSEARCHBIN="/usr/bin/ldapsearch"
LDAPADDBIN="/usr/bin/ldapadd"
LDAPDELETEBIN="/usr/bin/ldapdelete"
UTEMPLATE=""

###################################################
#######-----Darle la contraseña sudo-----##########
###################################################
echo -n '<mi contraseña>' > /etc/ldapscripts/ldapscripts.passwd

chmod 400 /etc/ldapscripts/ldapscripts.passwd


