<# SCRIPT PARTE 1 

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
$ServerName="cajal"
$ServerIp="172.16.0.10"
$ServerGateway="172.16.0.1"
$ServerMask=16

<# 1.1 - Establecer el nombre del servidor #>
write-host -BackgroundColor MAGENTA "1.- Cambio de nombre al Servidor. "
Write-Output " "  
Rename-Computer -NewName $ServerName -force -Confirm:$False
Write-Output " " 
write-host -foregroundcolor GREEN -nonewline "    Hecho. Reinicio Pendiente. " 
Write-Output " " 

<# 1.2 (EXTRA: Desactivar IPv6) #>
write-host -BackgroundColor MAGENTA "2.- Desactivación protocolo de RED IPv6. "
Write-Output " " 
reg add hklm\system\currentcontrolset\services\tcpip6\parameters /v DisabledComponents /t REG_DWORD /d 0xFF /f
$Terminado=(Get-NetAdapterBinding -ComponentID "ms_tcpip6" | disable-NetAdapterBinding -ComponentID "ms_tcpip6" –PassThru) > $null
if ( !$Terminado.Enabled )
  {
   Write-Output $TErminado
   Write-Output " " 
   write-host -foregroundcolor YELLOW -nonewline "    Hecho. Preferible Reinicio. " 
  } 
Write-Output " "

<# 1.3 Establecer la red 172.16.0.10 / 16 #>
write-host -BackgroundColor MAGENTA "3.- Establecer Dirección IPv4 Estática. "
Write-Output " " 
Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$((Get-NetAdapter -InterfaceIndex (Get-NetAdapter).InterfaceIndex ).InterfaceGuid)” -Name EnableDHCP -Value 0 -PassThru -Force -Confirm:$False > $null
Remove-NetIpAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -AddressFamily IPv4 -Confirm:$False -PassThru > $Null
Remove-NetRoute -InterfaceIndex (Get-NetAdapter).InterfaceIndex -AddressFamily IPv4 -Confirm:$False -PassThru > $Null
New-NetIpAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -IpAddress $ServerIp -PrefixLength $ServerMask -DefaultGateway $ServerGateway -AddressFamily IPv4 -Confirm:$False > $Null
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses $ServerIp > $Null
Write-Output " " 
write-host -foregroundcolor YELLOW -nonewline "    Hecho. " 
Write-Output " "

<# Reiniciar el Sistema #>
write-host -ForegroundColor Red "       Se procede al REINICIO DEL SISTEMA " -NoNewline
Start-Sleep -Seconds 5
restart-computer -Confirm:$False