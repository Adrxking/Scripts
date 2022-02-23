<#
    --> Realizar la instalación y configuración de un Windows Server como controlador de dominio adicional 
       utilizando PowerShell y teniendo en cuenta los siguientes requisitos:

    --> El nombre del controlador de dominio adicional será severo 
    --> La dirección IP del servidor debe ser la 172.16.0.11 / 16

    --> Comprobar que los usuarios pueden acceder correctamente al dominio 
        incluso si uno de los controladores de dominio falla.
#>

# VARIABLES
$dominioFQDN = "farma.lab"

# Añadimos un equipo cliente a nuestro dominio.
Add-Computer -domainname $dominioFQDN

# Instalamos el Rol de Servicios de dominio de active directory
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

Install-ADDSDomainController -DomainName $dominioFQDN -InstallDns -Credential (Get-Credential FARMA\Administrator)