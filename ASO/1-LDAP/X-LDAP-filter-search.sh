#!/bin/bash

ldapsearch -xLLL -b "dc=ies,dc=local" "(objectClass=Person)" mobile

ldapsearch -xLLL -b "dc=ies,dc=local" "(uid=aresines)" homePhone mail

ldapsearch -xLLL -b "dc=ies,dc=local" "(uid=*res*)" dn cn

ldapsearch -xLLL -b "dc=ies,dc=local" "(uidNumber>=10000)" dn cn

ldapsearch -xLLL -b "dc=ies,dc=local" "(mobile=*)" dn cn

# Operador and
ldapsearch -xLLL -b "dc=ies,dc=local" "(&(objectClass=Person)(cn=a*))" dn cn

# Operador or
ldapsearch -xLLL -b "dc=ies,dc=local" "(|(objectClass=Person)(cn=a*))" dn cn

# Operador not
ldapsearch -xLLL -b "dc=ies,dc=local" '(!(objectClass=Person))' dn cn

# Operadores multiples
ldapsearch -xLLL -b "dc=ies,dc=local" "(&(objectClass=Person)(|(objectClass=Person)(cn=a*)))" dn cn

