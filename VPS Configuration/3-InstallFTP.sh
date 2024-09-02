#!/bin/bash
apt-get install vsftpd -y

#/etc/vsftpd.conf
echo "listen=YES"                               >  /etc/vsftpd.conf
echo "listen_ipv6=NO"                           >> /etc/vsftpd.conf
echo "anonymous_enable=NO"                      >> /etc/vsftpd.conf
echo "local_enable=YES"                         >> /etc/vsftpd.conf
echo "write_enable=YES"                         >> /etc/vsftpd.conf
echo "local_umask=003"                          >> /etc/vsftpd.conf
echo "dirmessage_enable=YES"                    >> /etc/vsftpd.conf
echo "use_localtime=YES"                        >> /etc/vsftpd.conf
echo "xferlog_enable=YES"                       >> /etc/vsftpd.conf
echo "connect_from_port_20=YES"                 >> /etc/vsftpd.conf
echo "xferlog_file=/var/log/vsftpd.log"         >> /etc/vsftpd.conf
echo "xferlog_std_format=YES"                   >> /etc/vsftpd.conf
echo "chroot_local_user=YES"                    >> /etc/vsftpd.conf
echo "chroot_list_file=/etc/vsftpd.chroot_list" >> /etc/vsftpd.conf
echo "pam_service_name=vsftpd"                  >> /etc/vsftpd.conf
echo "userlist_enable=YES"                      >> /etc/vsftpd.conf
echo "tcp_wrappers=YES"                         >> /etc/vsftpd.conf
echo "pasv_min_port=40000"                      >> /etc/vsftpd.conf
echo "pasv_max_port=50000"                      >> /etc/vsftpd.conf
echo "userlist_deny=NO"                         >> /etc/vsftpd.conf


# Agregar aquí los usuarios que no queremos que tengan acceso por ftp
cat /etc/passwd | awk -F: '{ print $1 }' > /etc/vsftpd.chroot_list

# Agregar aquí los usuarios que si queremos que tengan acceso por ftp
touch /etc/vsftpd.user_list
