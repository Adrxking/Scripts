#-------CLIENTE-------#

#Cambiar nombre al cliente
$ClientName="win10"
Rename-Computer -NewName $ClientName -force -Confirm:$False

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

netsh interface ipv4 set address name="Ethernet0" static 192.168.1.101 255.255.255.0 
netsh interface ipv4 set dns name="Ethernet0" static 192.168.1.100

Set-NetConnectionProfile -InterfaceAlias Ethernet0 -NetworkCategory Private

#Permitir el acceso remoto al no estar dentro del dominio.
Get-NetConnectionProfile
Enable-PSRemoting -SkipNetworkProfileCheck

set-ExecutionPolicy Unrestricted -Confirm:$False -Force

Start-Sleep -Seconds 7
Restart-Computer

#-------SERVIDOR-------#

clear

# script para incluir un cliente en el dominio

# Consideraciones previas:
# Nuestro equipo cliente se llama Win10
# Las credenciales locales son Win10\Usuario
# El nombre del Dominio es Midominio.local
# Las credenciales del dominio son MIDOMINIO\administrador

# Sobre FireWall:
# El uso del SkipNetworkProfileCheck abree el firewall de Windows para la comunicación remota de PowerShell en su perfil de red actual,
# pero solo permitirá conexiones remotas desde máquinas en la misma subred.

# Dos parámetros que se pueden utilizar con Enable-PSRemoting son -Force y -Confirm.
# -Force para omitir todas las indicaciones que Enable-PSRemoting normalmente le daría al ejecutar el comando.
# -Confirm:$false obtendría el mismo resultado que -Forece



Get-NetConnectionProfile
Enable-PSRemoting -SkipNetworkProfileCheck

set-ExecutionPolicy Unrestricted

Enter-PSSession -ComputerName server16

Add-Computer -ComputerName win10 -LocalCredential win10\adria -DomainName midominio.local -Credential midominio\Administrador -Restart
