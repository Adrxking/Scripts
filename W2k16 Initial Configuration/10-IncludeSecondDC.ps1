clear

# Script que instala los servicios de AD en un nuevo servidor y lo promociona a segundo DC del dominio que tratamos.
# 
# Particulariadades: 
# Partimos de una configuración estable en el segundo servidor de la manera acostumbrada.
# Nombre del dominio: Midominio.local
# IP del servidor principal: 192.168.1.100/24
# IP servidor secundario: 192.168.1.200/24
# IP DNS: 192.168.1.100
# 
# Declaraciones globales del script:
# Función que FUERZA una replicación entre todos los DC's de un dominio. Será invocada al finalizar el proceso.

function Replicate-AllDomainController {
    (Get-ADDomainController -Filter *).Name | Foreach-Object { repadmin /syncall $_ (Get-ADDomain).DistinguishedName /e /A | Out-Null }; Start-Sleep 10; Get-ADReplicationPartnerMetadata -Target "$env:userdnsdomain" -Scope Domain | Select-Object Server, LastReplicationSuccess
}

# Actuación en el servidor secundario
# Instalación ROL AD

Install-WindowsFeature -Name AD-Domain-Services –IncludeManagementTools

# Importar módulos requeridos

Import-module ADDSDeployment

# Instalación de AD 

Install-ADDSDomainController -NoGlobalCatalog:$false -CreateDnsDelegation:$false -CriticalReplicationOnly:$false -DatabasePath “C:\Windows\NTDS”-Credential (Get-Credential "Midominio\Administrador") -DomainName “Midominio.local” -InstallDns:$true -LogPath “C:\Windows\NTDS” -NoRebootOnCompletion:$false -SiteName “Default-First-Site-Name” -SysvolPath “C:\Windows\SYSVOL” -Force:$true

# Replicación de DC's en el Dominio con indicación de servidores, fecha y hora de la replicación

Replicate-AllDomainController