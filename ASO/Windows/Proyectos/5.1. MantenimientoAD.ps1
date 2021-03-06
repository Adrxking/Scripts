<#
1) Verifica el estado del controlador severo, comprobando que se ejecutan los servicios esenciales 
   y que están compartidas las carpetas necesarias.

2) Comprueba cómo están asignados los roles FSMO en los controladores de dominio.

3) Desfragmenta y realiza una copia de seguridad de la base de datos de Active Directory en 
   la carpeta C:\BackupNTDS.
#>

<# 1. VERIFICACION DEL CONTROLADOR SEVERO, SCRIPT QUE EJECUTA UN SERVICIO SI ESTÁ PARADO 
   Y COMPRUEBA LAS CARPETAS COMPARTIDA #>

# Obtener los servicios que queremos comprobar
[Array] $Services = 'NTDS','ADWS','DNS','DNScache','KDC', 'W32time', 'Netlogon', 'DHCP';
# Loop por cada servicio
foreach($ServiceName in $Services)
{
    $arrService = Get-Service -Name $ServiceName
    # Comprobar que el servicio esta parado
    if ($arrService.Status -eq 'Stopped')
    {
        Start-Service $ServiceName
        write-host $arrService.status
        write-host "$ServiceName Starting"
        Start-Sleep -seconds 60
        $arrService.Refresh()
        if ($arrService.Status -eq 'Running')
            {
              Write-Host 'Service is now Running'
            }
    } else {
        write-host "$ServiceName ya estaba en estado Running"
    }
}

# Obtener las carpetas que queremos comprobar
[Array] $Folders = 'NETLOGON','SYSVOL';
# Loop por cada carpeta
foreach($Folder in $Folders)
{
    $arrFolder = Get-FileShare -Name $Folder
    # Comprobar que la carpeta esta online
    if ($arrFolder.OperationalStatus -eq 'Online')
    {
        write-host "$arrFolder Operativo"
    } else {
        write-host "WARNING! $arrFolder No operativo!!!"
    }
}

<# 2. COMPROBAR ROLES FSMO EN LOS CONTROLADORES DE DOMINIO #>
Clear-Host
write-host "Comprobando los roles FSMO en los controladores de dominio..."
write-host "Resultado:"
write-host ""
netdom query fsmo

<# 3. DEFRAGMENTACION Y BACKUP DE LA BD DE AD EN C:\BackupNTDS #>
Clear-Host
write-host "Deteniendo el servicio NTDS..."
Stop-Service NTDS -Force
write-host "Comenzando la defragmentacion de la BD de Active Directory"
ntdsutil.exe "activate instance ntds" files "compact to c:\BackupNTDS" quit quit
write-host "Fin de la defragmentacion de la BD de Active Directory"

write-host "Sustituyendo la BD original por la defragmentada..."
Copy-Item C:\BackupNTDS\ntds.* C:\Windows\NTDS
write-host "Reiniciando los logs de la BD..."
Remove-Item C:\Windows\NTDS\*.log

write-host "Comenzando el servicio NTDS..."
Start-Service NTDS