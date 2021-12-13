# * IP: 10.33.6.2 * #
# * Tratamos de crear un servidor ProFTPD con MariaDB para la gestión de usuarios * #

export PATH="$PATH:/usr/sbin"

apt update
apt install mariadb-server -s
apt install proftpd -s
apt install proftpd-mod-mysql -s

groupadd -g 2001 ftpgroup
useradd -u 2001 -s /bin/false -d /bin/null -g ftpgroup ftpuser

echo "export PATH=$PATH:/home/location/of/mysql/bin/folder" >> .profile

mysql -u root < conf.sql

mkdir /var/ftp
cp /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.original
sed -i "" /etc/proftpd/proftpd.conf