clear
$DIR="c:"
$ServerName="Server16"
$ServerIp="192.168.1.100"
$ServerGateway="192.168.1.1"

write-host -backgroundcolor BLUE -foregroundcolor YELLOW "Configuración inicial. Implica REINICIO del Sistema cuando finalice. "
echo " " 
write-host -BackgroundColor MAGENTA "1.- Desactivación de Windows Defender. "
echo " " 
Uninstall-WindowsFeature -Name Windows-Defender
echo " " 
write-host -foregroundcolor GREEN -nonewline "    Hecho. Reinicio Pendiente. "
echo " " 
write-host -BackgroundColor MAGENTA "2.- Desactivación del UAC. Control de Cuentas de Usuario. "
echo " " 
cd HKLM:\
$RegKey ='HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system'
Set-ItemProperty -Path $RegKey -Name EnableLUA -Value 0 -Confirm:$False
echo " " 
write-host -foregroundcolor GREEN -nonewline "    Hecho. Reinicio Pendiente. "
cd $Dir
echo " " 
write-host -BackgroundColor MAGENTA "3.- Desactivación del FIREWALL. "
echo " " 
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
echo " " 
write-host -foregroundcolor GREEN -nonewline "    Hecho. "
echo " " 
write-host -BackgroundColor MAGENTA "4.- Cambio de nombre al Servidor. "
echo " "  
Rename-Computer -NewName $ServerName -force -Confirm:$False
echo " " 
write-host -foregroundcolor GREEN -nonewline "    Hecho. Reinicio Pendiente. " 
echo " " 
write-host -BackgroundColor MAGENTA "5.- Desactivación protocolo de RED IPv6. "
echo " " 
reg add hklm\system\currentcontrolset\services\tcpip6\parameters /v DisabledComponents /t REG_DWORD /d 0xFF /f
$TErminado=(Get-NetAdapterBinding -ComponentID "ms_tcpip6" | disable-NetAdapterBinding -ComponentID "ms_tcpip6" –PassThru) > $null
if ( !$Terminado.Enabled )
  {
   echo $TErminado
   echo " " 
   write-host -foregroundcolor YELLOW -nonewline "    Hecho. Preferible Reinicio. " 
  } 
echo " "
write-host -BackgroundColor MAGENTA "6.- Establecer Dirección IPv4 Estática. "
echo " " 
Set-ItemProperty -Path “HKLM:\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\$((Get-NetAdapter -InterfaceIndex (Get-NetAdapter).InterfaceIndex ).InterfaceGuid)” -Name EnableDHCP -Value 0 -PassThru -Force -Confirm:$False > $null
Remove-NetIpAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -AddressFamily IPv4 -Confirm:$False -PassThru > $Null
Remove-NetRoute -InterfaceIndex (Get-NetAdapter).InterfaceIndex -AddressFamily IPv4 -Confirm:$False -PassThru > $Null
New-NetIpAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -IpAddress $ServerIp -PrefixLength 24 -DefaultGateway $ServerGateway -AddressFamily IPv4 -Confirm:$False > $Null
Set-DnsClientServerAddress -InterfaceIndex (Get-NetAdapter).InterfaceIndex -ServerAddresses $ServerIp > $Null
echo " " 
write-host -foregroundcolor YELLOW -nonewline "    Hecho. " 
echo " "
write-host -backgroundcolor Blue -foregroundcolor YELLOW "   Configuración inicial. "
echo " " 
write-host -foregroundColor GREEN "    1.- Desactivación de Windows Defender."
echo " " 
write-host -ForegroundColor GREEN "    2.- Desactivación del UAC. Control de Cuentas de Usuario."
echo " " 
write-host -ForegroundColor GREEN "    3.- Desactivación del FIREWALL."
echo " "
write-host -ForegroundColor GREEN "    4.- Cambio de nombre al Servidor."
echo " "
write-host -ForegroundColor GREEN "    5.- Desactivación protocolo de RED IPv6."
echo " "
write-host -foregroundColor GREEN "    6.- Establecer Dirección IPv4 Estática."
echo " "
write-host -ForegroundColor Red "       Se procede al REINICIO DEL SISTEMA " -NoNewline
Start-Sleep -Seconds 5
restart-computer -Confirm:$False