# Limpiar DNS
ipconfig /flushdns
Clear-DnsClientCache
Remove-DnsServerZone -name midominio.local -force > $Null

#Nuevas variables tras reinicio
$dominioFQDN = "midominio.local"
$dominioLDAP = ",DC=midominio,DC=local"


#Habilitar la papelera de reciclaje
Enable-ADOptionalFeature -Identity ("cn=Recycle Bin Feature,cn=Optional Features,CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration" + $dominioLDAP) -Scope ForestOrConfigurationSet -target $dominioFQDN -Confirm:$false

#DNS Env
$ReenviaDNS1 = "8.8.8.8"
$ReenviaDNS2 = "8.8.4.4"
$RedInversa = "192.168.1.0/24"

#Configurar DNS
Set-DNSServerForwarder -IPAddress $ReenviaDNS1,$ReenviaDNS2

#Solo errores en el registro de DNS
Set-DnsServerDiagnostics -EventLogLevel 1


#Borrar Zonas
Clear-DnsClientCache
Update-DnsServerTrustPoint -force
If ([string]::IsNullOrEmpty((get-dnsserverzone -name "midominio.local" -ErrorAction Ignore).Zonename))
  { 
   echo "Creando zona directa"
   Add-DnsServerPrimaryZone -name midominio.local -Zonefile midominio.local.dns
   if ([string]::IsNullOrEmpty((get-dnsserverzone -name "1.168.192.in-addr.arpa" -ErrorAction Ignore).Zonename)) 
     {
      echo "Creando zona indirecta"
      Add-DnsServerPrimaryZone -NetworkId 192.168.1.0/24 -ZoneFile 1.168.192.in-addr.arpa.dns    
     }
   else 
     {
      echo "Borrando zona inversa"
      Remove-DnsServerZone -name 1.168.192.in-addr.arpa -force
     }
  }
else { echo "Borrando zonas directa e inversa"
       Remove-DnsServerZone -name midominio.local -force
       Remove-DnsServerZone -name 1.168.192.in-addr.arpa -force
     }
Update-DnsServerTrustPoint -force

#Crear Registros y CNAMES
Add-DnsServerResourceRecordA -IPv4Address 192.168.1.110 -name nr1 -ZoneName midominio.local -CreatePtr
Add-DnsServerResourceRecordA -IPv4Address 192.168.1.130 -name server19 -ZoneName midominio.local -CreatePtr
Add-DnsServerResourceRecordCName -HostNameAlias www.midominio.local -Name ftp -ZoneName midominio.local
Add-DnsServerResourceRecordCName -HostNameAlias www.google.es -Name google -ZoneName midominio.local

#Cambiar propiedades de registro SOA
$NuevoSOA = Get-DnsServerResourceRecord -ZoneName midominio.local -RRType SOA
$AntiguoSOA = Get-DnsServerResourceRecord -ZoneName midominio.local -RRType SOA
$NuevoSOA.Recorddata.primaryserver = "server19.midominio.local"
$NuevoSOA.RecordData.serialNumber = "2021050601" 
set-dnsserverresourcerecord -NewInputObject $NuevoSOA -OldInputObject $AntiguoSOA -ZoneName midominio.local

# Establecer reenviadores
Add-DnsServerForwarder -IPAddress 8.8.8.8, 8.8.4.4, 1.1.1.1 -PassThru > $Null

# Reestablecer dir DNS en IP del Servidor
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses "192.168.1.130"

#Forzar el registro del servidor en el DNS
Register-DNSClient