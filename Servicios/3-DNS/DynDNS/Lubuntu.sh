# * IP Router (Ipfire): 10.33.6.1 * #
# * IP DNS Primario Lubuntu: 10.33.6.3 * #

# Configurar las interfaces

#!/bin/bash
# Instalar paquetes
apt update -y
apt install bind9 -y
apt install nmap -y
apt install isc-dhcp-server -y

###################################################
########-----------NAMED.CONF----------############
###################################################
echo "acl mired {"                                          >  /etc/bind/named.conf
echo "    127.0.0.0/8;"                                     >> /etc/bind/named.conf
echo "    10.33.6.0/24;"                                    >> /etc/bind/named.conf # Para que si el DNS o el DHCP está en otro pc
echo "};"                                                   >> /etc/bind/named.conf
echo ""                                                     >> /etc/bind/named.conf
echo "include \"/etc/bind/named.conf.options\";"            >> /etc/bind/named.conf
echo "include \"/etc/bind/named.conf.local\";"              >> /etc/bind/named.conf
echo "include \"/etc/bind/named.conf.default-zones\";"      >> /etc/bind/named.conf


###################################################
###########-----------OPTIONS----------############
###################################################

echo "options {"                                                                  >  /etc/bind/named.conf.options
echo "        directory \"/var/cache/bind\";"                                     >> /etc/bind/named.conf.options
echo ""                                                                           >> /etc/bind/named.conf.options
echo "        //forwarders {"                                                     >> /etc/bind/named.conf.options
echo "        //        8.8.8.8;"                                                 >> /etc/bind/named.conf.options
echo "        //        8.8.4.4;"                                                 >> /etc/bind/named.conf.options
echo "        //};"                                                               >> /etc/bind/named.conf.options
echo ""                                                                           >> /etc/bind/named.conf.options
echo "        dnssec-validation auto;"                                            >> /etc/bind/named.conf.options
echo ""                                                                           >> /etc/bind/named.conf.options
echo "        auth-nxdomain no;"                                                  >> /etc/bind/named.conf.options
echo "        allow-query { mired; };"                                            >> /etc/bind/named.conf.options
echo ""                                                                           >> /etc/bind/named.conf.options
echo "        listen-on-v6 { any; };"                                             >> /etc/bind/named.conf.options
echo "};"                                                                         >> /etc/bind/named.conf.options
echo ""                                                                           >> /etc/bind/named.conf.options
echo ""                                                                           >> /etc/bind/named.conf.options
echo "include \"/etc/bind/rndc.key\";"                                            >> /etc/bind/named.conf.options
echo ""                                                                           >> /etc/bind/named.conf.options
echo ""                                                                           >> /etc/bind/named.conf.options
echo "controls {"                                                                 >> /etc/bind/named.conf.options
echo "        inet 127.0.0.1 allow { localhost; 10.33.6.3; } keys { rndc-key; };" >> /etc/bind/named.conf.options
echo "};"                                                                         >> /etc/bind/named.conf.options

###################################################
######-------ZONAS DIRECTAS E INVERSAS------#######
###################################################
echo "zone \"cicloasir.icv\" {"              >  /etc/bind/named.conf.local
echo "  type master;"                        >> /etc/bind/named.conf.local
echo "  file \"db.cicloasir.icv\";"          >> /etc/bind/named.conf.local
echo "  allow-update { key \"rndc-key\"; };" >> /etc/bind/named.conf.local
echo "};"                                    >> /etc/bind/named.conf.local
echo ""                                      >> /etc/bind/named.conf.local
echo "zone \"6.33.10.in-addr.arpa\" {"       >> /etc/bind/named.conf.local
echo "  type master;"                        >> /etc/bind/named.conf.local
echo "  file \"db.10.33.6\";"                >> /etc/bind/named.conf.local
echo "  allow-update { key \"rndc-key\"; };" >> /etc/bind/named.conf.local
echo "};"                                    >> /etc/bind/named.conf.local

###################################################
######-------ZONAS ESTÁTICAS PARA ZONAS------######
###################################################
echo ";"                                                                    >  /var/cache/bind/db.cicloasir.icv 
echo '"$TTL"    86400'                                                      >> /var/cache/bind/db.cicloasir.icv
echo "@     IN  SOA  lubuntu.cicloasir.icv.  adrian.cicloasir.icv.  ("      >> /var/cache/bind/db.cicloasir.icv
echo "                       1   ; Serial"                                  >> /var/cache/bind/db.cicloasir.icv
echo "                  604800   ; Refresh"                                 >> /var/cache/bind/db.cicloasir.icv
echo "                   86400   ; Retry"                                   >> /var/cache/bind/db.cicloasir.icv
echo "                 2419200   ; Expire"                                  >> /var/cache/bind/db.cicloasir.icv
echo "                   86400 ) ; Negative Cache TTL"                      >> /var/cache/bind/db.cicloasir.icv
echo ";"                                                                    >> /var/cache/bind/db.cicloasir.icv
echo "@         IN  NS       lubuntu.cicloasir.icv."                        >> /var/cache/bind/db.cicloasir.icv
echo "lubuntu   IN  A        10.33.6.3"                                     >> /var/cache/bind/db.cicloasir.icv
echo "www       IN  A        10.33.6.2"                                     >> /var/cache/bind/db.cicloasir.icv
echo "correo    IN  A        10.33.6.2"                                     >> /var/cache/bind/db.cicloasir.icv
echo "@         IN  MX 10    correo.cicloasir.icv."                         >> /var/cache/bind/db.cicloasir.icv

echo ";"                                                                    >  /var/cache/bind/db.10.33.6 
echo '"$TTL"    86400'                                                      >> /var/cache/bind/db.10.33.6
echo "@     IN  SOA  lubuntu.cicloasir.icv.  adrian.cicloasir.icv.  ("      >> /var/cache/bind/db.10.33.6
echo "                       1   ; Serial"                                  >> /var/cache/bind/db.10.33.6
echo "                  604800   ; Refresh"                                 >> /var/cache/bind/db.10.33.6
echo "                   86400   ; Retry"                                   >> /var/cache/bind/db.10.33.6
echo "                 2419200   ; Expire"                                  >> /var/cache/bind/db.10.33.6
echo "                   86400 ) ; Negative Cache TTL"                      >> /var/cache/bind/db.10.33.6
echo ";"                                                                    >> /var/cache/bind/db.10.33.6
echo "@         IN  NS       lubuntu.cicloasir.icv."                        >> /var/cache/bind/db.10.33.6
echo "3         IN  PTR      lubuntu.cicloasir.icv."                        >> /var/cache/bind/db.10.33.6
echo "2         IN  PTR      correo.cicloasir.icv."                         >> /var/cache/bind/db.10.33.6
echo "2         IN  PTR      www.cicloasir.icv."                            >> /var/cache/bind/db.10.33.6

sleep 2;

service bind9 restart

sleep 2;

echo "Ahora se debe usar el modo interactivo"

###################################################
#####-----MODIFICAR REGISTROS PARA ZONAS------#####
###################################################
nsupdate -k /etc/bind/rndc.key
    #1. server lubuntu.cicloasir.icv
    #2. zone cicloasir.icv
    #3. update add prueba.cicloasir.icv. 86400 IN A 10.33.6.99
    #4. send
    #5. quit

# Ejemplo para zona inversa
    #1. server lubuntu.cicloasir.icv
    #2. zone 6.33.10.in-addr.arpa
    #3. update add 4.6.33.10.in-addr.arpa 86400 IN PTR prueba.cicloasir.icv
    #4. send
    #5. quit

# Se guarda en /var/cache/bind/(nombre).jnl

# Para forzar que se envíen los cambios al archivo original
# rndc freeze
# rndc unfreeze

###################################################
#####---INTERFACES POR LAS QUE ESCUCHA DHCP---#####
###################################################
echo "INTERFACESv4=\"ens33\"" >  /etc/default/isc-dhcp-server
echo "INTERFACESv6=\"\""      >> /etc/default/isc-dhcp-server


###################################################
#####-----CONFIGURACIÓN DHCP DEL SERVIDOR-----#####
###################################################
echo "key \"rndc-key\" {"                                                   >  /etc/dhcp/dhcpd.conf
echo "	algorithm hmac-sha256;"                                             >> /etc/dhcp/dhcpd.conf
echo "	secret \"S37TVrPE75L79ZE/a/iU8XSP8FdKecvXj5muzH9Bvjc=\";"           >> /etc/dhcp/dhcpd.conf
echo "};"                                                                   >> /etc/dhcp/dhcpd.conf

echo "server-identifier lubuntu.cicloasir.icv;"                             >> /etc/dhcp/dhcpd.conf
echo "ddns-update-style interim;"                                           >> /etc/dhcp/dhcpd.conf
echo "ddns-updates on;"                                                     >> /etc/dhcp/dhcpd.conf
echo "ddns-domainname \"cicloasir.icv.\";"                                  >> /etc/dhcp/dhcpd.conf
echo "ddns-rev-domainname \"in-addr.arpa.\";"                               >> /etc/dhcp/dhcpd.conf
# Por si el cliente envía no solo su nombre
# sino también el dominio (su fqdn)
echo "ignore client-updates;"                                               >> /etc/dhcp/dhcpd.conf
echo "authoritative;"                                                       >> /etc/dhcp/dhcpd.conf
echo "option domain-name \"cicloasir.icv\";"                                >> /etc/dhcp/dhcpd.conf

echo "ddns-hostname =  pick-first-value("                                   >> /etc/dhcp/dhcpd.conf
echo "     option host-name,"                                               >> /etc/dhcp/dhcpd.conf
echo "     concat(\"host-\",binary-to-ascii(10,8, \"-\", leased-address))"  >> /etc/dhcp/dhcpd.conf
echo ");"                                                                   >> /etc/dhcp/dhcpd.conf

echo "zone cicloasir.icv. {"                                                >> /etc/dhcp/dhcpd.conf
echo "        primary 10.33.6.3;"                                           >> /etc/dhcp/dhcpd.conf
echo "        key rndc-key;"                                                >> /etc/dhcp/dhcpd.conf
echo "}"                                                                    >> /etc/dhcp/dhcpd.conf
echo "zone 6.33.10.in-addr.arpa. {"                                         >> /etc/dhcp/dhcpd.conf
echo "        primary 10.33.6.3;"                                           >> /etc/dhcp/dhcpd.conf
echo "        key rndc-key;"                                                >> /etc/dhcp/dhcpd.conf
echo "}"                                                                    >> /etc/dhcp/dhcpd.conf

echo "subnet 10.33.6.0 netmask 255.255.255.0 {"                             >> /etc/dhcp/dhcpd.conf
echo "        option domain-name-servers 10.33.6.3;"                        >> /etc/dhcp/dhcpd.conf
echo "        option routers 10.33.6.1;"                                    >> /etc/dhcp/dhcpd.conf
echo "        range 10.33.6.101 10.33.6.150;"                               >> /etc/dhcp/dhcpd.conf
echo "}"                                                                    >> /etc/dhcp/dhcpd.conf