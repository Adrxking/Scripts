clear
$DIR="c:"
write-host -backgroundcolor BLUE -foregroundcolor YELLOW "Configuración inicial. Implica REINICIO del Sistema cuando finalice. "
echo " " 
write-host -BackgroundColor RED "1.- Descativación de Windows Defender. "
echo " " 
Read-Host -Prompt "    Presiona una tecla para continuar o CTRL+C para salir." 
Uninstall-WindowsFeature -Name Windows-Defender
echo " " 
write-host -foregroundcolor YELLOW -nonewline "    Hecho. Reinicio Pendiente. "
read-host -prompt "Presiona una tecla para continuar o CTRL+C para salir."
clear
echo " " 
write-host -BackgroundColor RED "2.- Descativación del UAC. Control de Cuentas de Usuario. "
echo " " 
Read-Host -Prompt "    Presiona una tecla para continuar o CTRL+C para salir." 
cd HKLM:\
$RegKey ='HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system'
Set-ItemProperty -Path $RegKey -Name EnableLUA -Value 0 -Confirm:$False
echo " " 
write-host -foregroundcolor YELLOW -nonewline "    Hecho. Reinicio Pendiente. "
read-host -prompt "Presiona una tecla para continuar o CTRL+C para salir."
cd $Dir
clear
echo " " 
write-host -BackgroundColor RED "3.- Descativación del FIREWALL. "
echo " " 
Read-Host -Prompt "    Presiona una tecla para continuar o CTRL+C para salir." 
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
echo " " 
write-host -foregroundcolor YELLOW -nonewline "    Hecho. "
read-host -prompt "Presiona una tecla para continuar o CTRL+C para salir."
clear
echo " " 
write-host -BackgroundColor RED "4.- Cambio de nombre al Servidor. "
echo " " 
Read-Host -Prompt "    Presiona una tecla para continuar o CTRL+C para salir." 
Rename-Computer -NewName Server16 -force -Confirm:$False
echo " " 
write-host -foregroundcolor YELLOW -nonewline "    Hecho. Reinicio Pendiente. " 
read-host -prompt "Presiona una tecla para continuar o CTRL+C para salir."
clear
echo " " 
write-host -BackgroundColor RED "5.- Desactivación protocolo de RED IPv6. "
echo " " 
Read-Host -Prompt "    Presiona una tecla para continuar o CTRL+C para salir." 
reg add hklm\system\currentcontrolset\services\tcpip6\parameters /v DisabledComponents /t REG_DWORD /d 0xFF /f
$TErminado=(Get-NetAdapterBinding -ComponentID "ms_tcpip6" | disable-NetAdapterBinding -ComponentID "ms_tcpip6" –PassThru) > $null
if ( !$Terminado.Enabled )
  {
   echo $TErminado
   echo " " 
   write-host -foregroundcolor YELLOW -nonewline "    Hecho. Preferible Reinicio. " 
   read-host -prompt "Presiona una tecla para continuar o CTRL+C para salir."
  } 
clear
echo " "
write-host -BackgroundColor RED "5.- Establecer Dirección IPv4 Estática. "
echo " " 
Read-Host -Prompt "    Presiona una tecla para continuar o CTRL+C para salir." 
Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$((Get-NetAdapter -InterfaceIndex (Get-NetAdapter).InterfaceIndex ).InterfaceGuid)” -Name EnableDHCP -Value 0 -PassThru -Force -Confirm:$False > $null
Remove-NetIpAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -AddressFamily IPv4 -Confirm:$False -PassThru > $Null
Remove-NetRoute -InterfaceIndex (Get-NetAdapter).InterfaceIndex -AddressFamily IPv4 -Confirm:$False -PassThru > $Null
New-NetIpAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -IpAddress 192.168.1.130 -PrefixLength 24 -DefaultGateway 192.168.1.1 -AddressFamily IPv4 -Confirm:$False > $Null
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses "192.168.1.130" > $Null
echo " " 
write-host -foregroundcolor YELLOW -nonewline "    Hecho. " 
read-host -prompt "Presiona una tecla para continuar o CTRL+C para salir." 
clear
clear
echo " "
write-host -backgroundcolor Blue -foregroundcolor YELLOW "   Configuración inicial. "
echo " " 
write-host -foregroundColor GREEN "    1.- Descativación de Windows Defender."
echo " " 
write-host -ForegroundColor GREEN "    2.- Descativación del UAC. Control de Cuentas de Usuario."
echo " " 
write-host -ForegroundColor GREEN "    3.- Descativación del FIREWALL."
echo " "
write-host -ForegroundColor GREEN "    4.- Cambio de nombre al Servidor."
echo " "
write-host -ForegroundColor GREEN "    5.- Desactivación protocolo de RED IPv6."
echo " "
write-host -foregroundColor GREEN "    6.- Establecer Dirección IPv4 Estática."
echo " "
write-host -ForegroundColor Red "       Se procede al REINICIO DEL SISTEMA " -NoNewline
read-host -Prompt " "
restart-computer -Confirm:$False