# * IP Debian: 10.33.6.2 * #
# * IP DNS Primario (Lubuntu): 10.33.6.3 * #
# * IP Router (Ipfire): 10.33.6.1 * #
# * IP WServer 2019: 10.33.6.4 * #

# Configurar las interfaces

#!/bin/bash
# Instalar paquetes
apt update -y
apt install bind9 -y
apt install nmap -y

###################################################
###-----Crear zonas secundarias y delegación-----##
###################################################

# * Aquí no hay que hacer nada para las delegaciones * #
echo "zone \"barriosesamo.edu\" {"                            >  /etc/bind/named.conf.local
echo "      type master;"                                     >> /etc/bind/named.conf.local
echo "      file \"/etc/bind/db.barriosesamo.edu\"; "         >> /etc/bind/named.conf.local
echo "      notify yes; "                                     >> /etc/bind/named.conf.local
echo "};"                                                     >> /etc/bind/named.conf.local

echo ""                                                       >> /etc/bind/named.conf.local

# Forma 2 de Crear un subdominio (Creando zona), no es necesario si hemos hecho la forma 1
echo "zone \"quiosco.barriosesamo.edu\" {"                    >> /etc/bind/named.conf.local
echo "      type master;"                                     >> /etc/bind/named.conf.local
echo "      file \"/etc/bind/db.quiosco.barriosesamo.edu\"; " >> /etc/bind/named.conf.local
echo "      notify yes; "                                     >> /etc/bind/named.conf.local
echo "};"                                                     >> /etc/bind/named.conf.local

echo ""                                                       >> /etc/bind/named.conf.local

# Zona inversa
echo "zone \"6.192.in-addr.arpa\" {"                          >> /etc/bind/named.conf.local
echo "      type master;"                                     >> /etc/bind/named.conf.local
echo "      file \"/etc/bind/db.192.6\"; "                    >> /etc/bind/named.conf.local
echo "      notify yes; "                                     >> /etc/bind/named.conf.local
echo "};"                                                     >> /etc/bind/named.conf.local


###################################################
###---Crear configuracion de la DB de la zona----##
###################################################

echo ";"                                                                       >  /etc/bind/db.barriosesamo.edu 
echo '"$TTL"    86400'                                                         >> /etc/bind/db.barriosesamo.edu
echo "@     IN  SOA  ns1.barriosesamo.edu.  adrian.barriosesamo.edu.  ("       >> /etc/bind/db.barriosesamo.edu
echo "                       3   ; Serial"                                     >> /etc/bind/db.barriosesamo.edu
echo "                  604800   ; Refresh"                                    >> /etc/bind/db.barriosesamo.edu
echo "                   86400   ; Retry"                                      >> /etc/bind/db.barriosesamo.edu
echo "                 2419200   ; Expire"                                     >> /etc/bind/db.barriosesamo.edu
echo "                    7200 ) ; Negative Cache TTL"                         >> /etc/bind/db.barriosesamo.edu
echo ";"                                                                       >> /etc/bind/db.barriosesamo.edu
echo "@         IN  NS       ns1.barriosesamo.edu."                            >> /etc/bind/db.barriosesamo.edu
echo "@         IN  NS       ns2.barriosesamo.edu."                            >> /etc/bind/db.barriosesamo.edu
echo "ns1       IN  A        10.33.6.3"                                        >> /etc/bind/db.barriosesamo.edu
echo "ns2       IN  A        10.33.6.2"                                        >> /etc/bind/db.barriosesamo.edu
echo "espinete  IN  A        192.6.0.101"                                      >> /etc/bind/db.barriosesamo.edu
echo "gustavo   IN  A        192.6.0.102"                                      >> /etc/bind/db.barriosesamo.edu
echo "www       IN  CNAME    espinete.barriosesamo.edu."                       >> /etc/bind/db.barriosesamo.edu
echo "mail      IN  CNAME    gustavo.barriosesamo.edu."                        >> /etc/bind/db.barriosesamo.edu
echo "@         IN  MX 10    gustavo.barriosesamo.edu."                        >> /etc/bind/db.barriosesamo.edu
echo ";"                                                                       >> /etc/bind/db.barriosesamo.edu # Subdominio delegado
echo "; subdominio laplaza delegado en W2k19"                                  >> /etc/bind/db.barriosesamo.edu # Subdominio delegado
echo ";"                                                                       >> /etc/bind/db.barriosesamo.edu # Subdominio delegado
echo "laplaza.barriosesamo.edu.      IN  NS    ns.laplaza.barriosesamo.edu."   >> /etc/bind/db.barriosesamo.edu # Subdominio delegado
echo "laplaza.barriosesamo.edu.      IN  NS    nsd.laplaza.barriosesamo.edu."  >> /etc/bind/db.barriosesamo.edu # Subdominio delegado
echo "nsd.laplaza.barriosesamo.edu.  IN  A     10.33.6.2"                      >> /etc/bind/db.barriosesamo.edu # Subdominio delegado
echo "ns.laplaza                     IN  A     10.33.13.4"                     >> /etc/bind/db.barriosesamo.edu # Subdominio delegado
#echo ";"                                                                      >> /etc/bind/db.barriosesamo.edu # Subdominio Forma 1 (Sin crear zona)
#echo "; subdominio quisko sin delegacion y sin zona nueva"                    >> /etc/bind/db.barriosesamo.edu # Subdominio Forma 1 (Sin crear zona)
#echo ";"                                                                      >> /etc/bind/db.barriosesamo.edu # Subdominio Forma 1 (Sin crear zona)
#echo "juan.quiosco  IN  A    192.6.0.151"                                     >> /etc/bind/db.barriosesamo.edu # Subdominio Forma 1 (Sin crear zona)
#echo "loli.quiosco  IN  A    192.6.0.152"                                     >> /etc/bind/db.barriosesamo.edu # Subdominio Forma 1 (Sin crear zona)


###################################################
#####-----Crear DB del subdominio (Forma 2)---#####
###################################################
echo ";"                                                                    >  /etc/bind/db.quiosco.barriosesamo.edu 
echo '"$TTL"    86400'                                                      >> /etc/bind/db.quiosco.barriosesamo.edu
echo "@     IN  SOA  ns1.barriosesamo.edu.  adrian.barriosesamo.edu.  ("    >> /etc/bind/db.quiosco.barriosesamo.edu
echo "                       3   ; Serial"                                  >> /etc/bind/db.quiosco.barriosesamo.edu
echo "                  604800   ; Refresh"                                 >> /etc/bind/db.quiosco.barriosesamo.edu
echo "                   86400   ; Retry"                                   >> /etc/bind/db.quiosco.barriosesamo.edu
echo "                 2419200   ; Expire"                                  >> /etc/bind/db.quiosco.barriosesamo.edu
echo "                    7200 ) ; Negative Cache TTL"                      >> /etc/bind/db.quiosco.barriosesamo.edu
echo ";"                                                                    >> /etc/bind/db.quiosco.barriosesamo.edu
echo "@         IN  NS       ns1.barriosesamo.edu."                         >> /etc/bind/db.quiosco.barriosesamo.edu
echo "@         IN  NS       ns2.barriosesamo.edu."                         >> /etc/bind/db.quiosco.barriosesamo.edu
echo "juan  IN  A    192.6.0.151"                                           >> /etc/bind/db.quiosco.barriosesamo.edu
echo "loli  IN  A    192.6.0.152"                                           >> /etc/bind/db.quiosco.barriosesamo.edu

###################################################
#####--------Crear DB de la zona inversa------#####
###################################################
echo ";"                                                                    >  /etc/bind/db.192.6 
echo '"$TTL"    86400'                                                      >> /etc/bind/db.192.6
echo "@     IN  SOA  ns1.barriosesamo.edu.  adrian.barriosesamo.edu.  ("    >> /etc/bind/db.192.6
echo "                       3   ; Serial"                                  >> /etc/bind/db.192.6
echo "                  604800   ; Refresh"                                 >> /etc/bind/db.192.6
echo "                   86400   ; Retry"                                   >> /etc/bind/db.192.6
echo "                 2419200   ; Expire"                                  >> /etc/bind/db.192.6
echo "                    7200 ) ; Negative Cache TTL"                      >> /etc/bind/db.192.6
echo ";"                                                                    >> /etc/bind/db.192.6
echo "@         IN  NS       ns1.barriosesamo.edu."                         >> /etc/bind/db.192.6
echo "@         IN  NS       ns2.barriosesamo.edu."                         >> /etc/bind/db.192.6
echo "101.0     IN  PTR      espinete.barriosesamo.edu."                    >> /etc/bind/db.192.6
echo "102.0     IN  PTR      gustavo.barriosesamo.edu."                     >> /etc/bind/db.192.6
echo "151.0     IN  PTR      juan.quiosco.barriosesamo.edu."                >> /etc/bind/db.192.6
echo "152.0     IN  PTR      loli.quiosco.barriosesamo.edu."                >> /etc/bind/db.192.6
echo "251.0     IN  PTR      farola.laplaza.barriosesamo.edu."              >> /etc/bind/db.192.6
echo "252.0     IN  PTR      papelera.laplaza.barriosesamo.edu."            >> /etc/bind/db.192.6

###################################################
#######-----------REENVIADORES-------------########
###################################################
# * Descomentar reenviadores porque lo pide el ejercicio * #
# * Comentamos para cuando tenemos que delegar en el server w2k19 * #

echo "options {"                              >  /etc/bind/named.conf.options
echo "        directory \"/var/cache/bind\";" >> /etc/bind/named.conf.options
echo ""                                       >> /etc/bind/named.conf.options
echo "        //forwarders {"                 >> /etc/bind/named.conf.options
echo "        //        8.8.8.8;"             >> /etc/bind/named.conf.options
echo "        //        8.8.4.4;"             >> /etc/bind/named.conf.options
echo "        //};"                           >> /etc/bind/named.conf.options
echo ""                                       >> /etc/bind/named.conf.options
echo "        dnssec-validation auto;"        >> /etc/bind/named.conf.options
echo ""                                       >> /etc/bind/named.conf.options
echo "        listen-on-v6 { any; };"         >> /etc/bind/named.conf.options
echo "};"                                     >> /etc/bind/named.conf.options



###################################################
#######------------Comprobar-------------##########
###################################################
named-checkconf
echo "named-checkconf checked"

service bind9 restart

sleep 3

# Vaciar cachés
#systemd-resolve --flush-caches

named-checkzone barriosesamo.edu /etc/bind/db.barriosesamo.edu

# Comprobar que correos existen en un servidor
dig barriosesamo.edu MX

# Forma 2 de comprobar correos
#nslookup 
#   --> set type=MX 
#   --> barriosesamo.edu
#   --> exit