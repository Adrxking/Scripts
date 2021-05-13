clear

# instalación de DHCP, su inclusión en DC y posterior eliminación del aviso "Autorizar"

Install-WindowsFeature -name DHCP -IncludeManagementTools
Add-DhcpServerInDC -DnsName server16.midominio.local -IPAddress 192.168.1.100
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2

# ámbitos

Add-DHCPServerv4Scope -Name “Miambito” -StartRange 192.168.1.89 -EndRange 192.168.1.99 -SubnetMask 255.255.255.0 -State Active

# exclusiones

Add-DhcpServerv4ExclusionRange -ScopeId 192.168.1.0 -StartRange 192.168.1.95 -EndRange 192.168.1.97 -Verbose

# tiempo de la concesión e inclusión de direcciones DNS y GW

Set-DhcpServerv4Scope -ScopeId 192.168.1.0 -LeaseDuration 1.00:00:00

Set-DHCPServerv4OptionValue -ScopeID 192.168.1.0 -DnsDomain server16.midominio.local -DnsServer 192.168.1.100 -Router 192.168.1.1

# reiniciar servicio

Restart-service dhcpserver

# Muestra información de lo realizado 

Get-DhcpServerv4Scope | ft 

#Instalar las management tools de DHCP
Install-WindowsFeature -Name RSAT-DHCP

# Para eliminar un ámbito
# Remove-DhcpServerv4Scope -ScopeId 192.168.1.0 -Verbose

# Para desinstalar DHCP
# Uninstall-WindowsFeature dhcp -IncludeManagementTools

# Reiniciar 
Start-Sleep -Seconds 7
Restart-Computer