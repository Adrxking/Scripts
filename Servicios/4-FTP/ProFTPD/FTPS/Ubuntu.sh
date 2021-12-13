apt install expect

echo "ModulePath /usr/lib/proftpd" > /etc/proftpd/modules.conf

echo "ModuleControlsACLs insmod,rmmod allow user root" >> /etc/proftpd/modules.conf
echo "ModuleControlsACLs lsmod allow user *" >> /etc/proftpd/modules.conf

echo "LoadModule mod_ctrls_admin.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_radius.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_quotatab.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_quotatab_file.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_quotatab_radius.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_rewrite.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_load.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_ban.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_wrap2.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_wrap2_file.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_dynmasq.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_exec.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_shaper.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_ratio.c" >> /etc/proftpd/modules.conf
echo "LoadModule mod_site_misc.c" >> /etc/proftpd/modules.conf

LoadModule mod_facl.c >> /etc/proftpd/modules.conf
LoadModule mod_unique_id.c >> /etc/proftpd/modules.conf
LoadModule mod_copy.c >> /etc/proftpd/modules.conf
LoadModule mod_deflate.c >> /etc/proftpd/modules.conf
LoadModule mod_ifversion.c >> /etc/proftpd/modules.conf
LoadModule mod_memcache.c >> /etc/proftpd/modules.conf
LoadModule mod_readme.c >> /etc/proftpd/modules.conf

LoadModule mod_ifsession.c >> /etc/proftpd/modules.conf


openssl req -x509 -newkey rsa:2048 -keyout /etc/ssl/private/cert.key -out /etc/ssl/certs/cert.crt -nodes -days 365

echo "<IfModule mod_tls.c>"                                                >  /etc/proftpd/tls.conf
echo "    TLSEngine                           on"                          >> /etc/proftpd/tls.conf
echo "    TLSLog                              /var/log/proftpd/tls.log"    >> /etc/proftpd/tls.conf
echo "    TLSProtocol                         SSLv23"                      >> /etc/proftpd/tls.conf
echo "    TLSRSACertificateFile               /etc/ssl/certs/cert.crt"     >> /etc/proftpd/tls.conf
echo "    TLSRSACertificateKeyFile            /etc/ssl/private/cert.key"   >> /etc/proftpd/tls.conf
echo "    TLSOptions                          AllowClientRenegotiations"   >> /etc/proftpd/tls.conf
echo "    TLSVerifyClient                     off"                         >> /etc/proftpd/tls.conf
echo "    TLSRequired                         on"                          >> /etc/proftpd/tls.conf
echo "    TLSRenegotiate                      required off"                >> /etc/proftpd/tls.conf
echo "</IfModule>"                                                         >> /etc/proftpd/tls.conf

# Habilitar conexiones FTPS
sed -i "s/#Include \/etc\/proftpd\/tls.conf/Include \/etc\/proftpd\/tls.conf/" /etc/proftpd/proftpd.conf

service proftpd restart

