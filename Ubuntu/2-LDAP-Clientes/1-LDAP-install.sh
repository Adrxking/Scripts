###################################################
######-----Instalar ldap en clientes-----##########
###################################################
apt install libnss-ldap
    1) ldap://Ip del servidor
    2) nombre del dominio --> dc=ies,dc=local
    3) Version 3
    4) Yes
    5) No
    6) cn=admin,dc=ies,dc=local
    7) <contraseña>

###################################################
####--En caso de que necesitemos reconfigurar--####
###################################################
dpkg-reconfigure ldap-auth-config

#!/bin/bash

###################################################
####-------Configurar el nsswitch.conf---------####
###################################################
passwd:         files systemd ldap > /etc/nsswitch.conf
group:          files systemd ldap
shadow:         files ldap
gshadow:        files
echo '' >> /etc/nsswitch.conf
hosts:          files mdns4_minimal [NOTFOUND=return] dns
networks:       files
echo '' >> /etc/nsswitch.conf
protocols:      db files
services:       db files
ethers:         db files
rpc:            db files
echo '' >> /etc/nsswitch.conf
netgroup:       nis >> /etc/nsswitch.conf

###################################################
####-------Configurar el common-password---------##
###################################################
password        [success=2 default=ignore]      pam_unix.so obscure sha512 > /etc/pam.d/common-password
password        [success=1 user_unknown=ignore default=die]     pam_ldap.so try_first_pass
echo '' >> /etc/pam.d/common-password
password        requisite                       pam_deny.so
echo '' >> /etc/pam.d/common-password
password        required                        pam_permit.so
echo '' >> /etc/pam.d/common-password
password        optional        pam_gnome_keyring.so >> /etc/pam.d/common-password