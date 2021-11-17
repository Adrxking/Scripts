#!/bin/bash
set -e
###################################################
######-------Declarate variables--------###########
###################################################
NOMCLIENTE=''
USUARIO=''
PASSWD=''
PATH=''

###################################################
######-------Create false shell---------###########
###################################################
make_shell() {
    if ! [ -d /bin/ftp2 ]
    then
        /usr/sbin/mkdir /bin/ftp2
        echo "/bin/ftp2" >> /etc/shells
    fi
}

###################################################
######----------Create new user---------###########
###################################################
create_user() {
    /usr/sbin/useradd -g ftp -d "${PATH}" -s /bin/ftp2 -c "Cliente ${NOMCLIENTE}" "${USUARIO}"
    echo "${USUARIO}:${PASSWD}" | /usr/sbin/chpasswd
    echo "$USUARIO" >> /etc/vsftpd.user_list
}

main() {
    make_shell
    create_user
}

main