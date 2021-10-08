clear
$DIR = "c:"
$ClientName = "server16Replica"

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
$RegKey = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system'
Set-ItemProperty -Path $RegKey -Name EnableLUA -Value 0 -Confirm:$False
echo " " 
write-host -foregroundcolor GREEN -nonewline "    Hecho. Reinicio Pendiente. "
cd $Dir
echo " "
write-host -BackgroundColor MAGENTA "3.- Establecer Dirección IPv4 192.168.1.200 "
echo " " 
netsh interface ipv4 set address name="Ethernet0" static 192.168.1.200 255.255.255.0 
netsh interface ipv4 set dns name="Ethernet0" static 192.168.1.100
echo " " 
write-host -BackgroundColor MAGENTA "4.- Establecer nombre al equipo "
echo " " 
Rename-Computer -NewName $ClientName -force -Confirm:$False
echo " " 
write-host -foregroundcolor YELLOW -nonewline "    Hecho. " 
echo " "
write-host -backgroundcolor Blue -foregroundcolor YELLOW "   Configuración inicial. "
echo " " 
write-host -foregroundColor GREEN "    1.- Desactivación de Windows Defender."
echo " " 
write-host -ForegroundColor GREEN "    2.- Desactivación del UAC. Control de Cuentas de Usuario."
echo " " 
write-host -foregroundColor GREEN "    3.- Establecer Dirección IPv4 Automática por DHCP."
echo " "
write-host -foregroundColor GREEN "    4.- Establecer nombre al equipo."
echo " "
write-host -ForegroundColor Red "       Se procede al REINICIO DEL SISTEMA " -NoNewline
Start-Sleep -Seconds 5
restart-computer -Confirm:$False