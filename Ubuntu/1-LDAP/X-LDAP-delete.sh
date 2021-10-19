#!/bin/bash

###################################################
########-----Estructura Eliminar-----#############
###################################################
ldapdelete -x -W -D "cn=admin,dc=ies,dc=local" "uid=pvega,ou=usuarios,dc=ies,dc=local"
