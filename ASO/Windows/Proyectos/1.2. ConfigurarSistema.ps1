<# SCRIPT PARTE 2

--> 1. Realizar la instalación y configuración inicial de un Windows Server utilizando PowerShell, 
       teniendo en cuenta los siguientes requisitos del sistema:
        --> 1.1 El nombre del servidor será cajal (En honor al premio nobel de medicina Santiago Ramón y Cajal)
        --> 1.2 La red privada de la empresa es la 172.16.0.0 / 16.
        --> 1.3 La dirección IP del servidor debe ser la 172.16.0.10
        --> 1.4 Dar de alta a los siguientes usuarios locales pertenecientes al departamento de sistemas:
            --> 1.4.1 Sara Castillo (Administradora del sistema)
            --> 1.4.2 Sergio Torres (Operador de copias de seguridad)
        --> 1.5 Crear una carpeta compartida para guardar la documentación generada por el departamento de sistemas. 
        Sólo los miembros del departamento de sistemas tendrán acceso a esta carpeta.
        --> 1.6 Realizar una copia de seguridad automáticamente todos los días fuera del horario laboral de la carpeta
        con la documentación del departamento de sistemas.
#>
<# VARIABLES #>
$Usuario1="SaraCastillo"
$Usuario1Pass="P@ssword"
$Usuario2="SergioTorres"
$Usuario2Pass="P@ssword"

<# 1.4.1 - Alta usuario Sara Castillo (Administradora del sistema) #>
$Usuario1PassSecure=ConvertTo-SecureString $Usuario1Pass -asplaintext -force
New-LocalUser $Usuario1 -Password $Usuario1PassSecure
# Añadir al usuario al groupo Administradores 
Add-LocalGroupMember -Group "Administradores" -Member $Usuario1
Write-Output " ##### ESTOS SON LOS MIEMBROS DEL GRUPO Administradores ##### "
Get-LocalGroupMember -Group "Administradores"

<# 1.4.2 - Sergio Torres (Operador de copias de seguridad) #>
$Usuario2SecurePass=ConvertTo-SecureString $Usuario2Pass -asplaintext -force
New-LocalUser $Usuario2 -Password $Usuario2SecurePass
# Añadir al usuario al groupo Operadores de copia de seguridad
Add-LocalGroupMember -Group "Operadores de copia de seguridad" -Member $Usuario2
Write-Output " ##### ESTOS SON LOS MIEMBROS DEL GRUPO Operadores de copia de seguridad ##### "
Get-LocalGroupMember -Group "Operadores de copia de seguridad"

<# 1.5. Compartir Carpeta para los administradores #>
#Crear un directorio
New-Item C:\Shared -type directory
#Compartir un directorio
New-SmbShare -Name SharedAdmin -Path C:\Shared -FullAccess Administradores
#Verificar los permisos de un directorio compartido.
Write-Output " ## ESTOS SON LOS PERMISOS DEL DIRECTORIO COMPARTIDO SharedAdmin ##"
Get-SmbShareAccess SharedAdmin

<# 1.6. Copia de seguridad diaria de la carpeta SharedAdmin #>
# Script copia de seguridad
Write-Output "xcopy /i /e /y /d c:\Shared c:\backups\administradores" > C:\scripts\Backup.ps1
# Crear la acción.
$accion = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "C:\scripts\Backup.ps1"

# Creamos el desencadenante.
$disparador = New-ScheduledTaskTrigger -Daily -At 23pm

Write-Host
# Registrar tarea para que se ejecute.
Register-ScheduledTask -Action $accion -Trigger $disparador -TaskName "Copia" -Description "Copia de seguridad"