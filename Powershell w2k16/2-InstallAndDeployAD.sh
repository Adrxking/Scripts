#Variables
$dominioFQDN = "midominio.local"
$dominioNETBIOS = "midominio"

#Instalar característica AD Y DNS
Install-WindowsFeature AD-Domain-Services,DNS -IncludeManagementTools

#Carga el módulo de despliegue
Import-module addsdeployment 

#Desplegar dominio WS2016
Install-ADDSForest -DomainName $dominioFQDN -DomainNetBiosName $dominioNETBIOS -SafeModeAdministratorPassword (ConvertTo-SecureString -string "P@ssw0rd" -AsPlainText -Force) -DomainMode WinThreshold -ForestMode WinThreshold -InstallDNS -Confirm:$false
