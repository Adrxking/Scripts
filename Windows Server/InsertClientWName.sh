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
# -Confirm:$false obtendría el mismo resultado que -Force

Get-NetConnectionProfile
Enable-PSRemoting
Enable-PSRemoting -SkipNetworkProfileCheck

Add-Computer -ComputerName win10 -LocalCredential Win10\usuario -DomainName midominio.local -Credential midominio\administrador -Restart