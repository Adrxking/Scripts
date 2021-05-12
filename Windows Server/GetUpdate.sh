#Instalar módulo de windows update
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

#Obtener las actualizaciones
Get-WindowsUpdate

#Instalar las actualizaciones
Install-WindowsUpdate

#Listar las actualizaciones instaladas
Get-Hotfix