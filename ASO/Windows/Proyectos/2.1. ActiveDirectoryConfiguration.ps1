<# PARTE 1
    --> 1. Realizar la instalación y configuración de Active Directory utilizando PowerShell 
        y teniendo en cuenta los siguientes requisitos:

        --> 1.1 - El dominio de la empresa es farma.lab
        --> 1.2 - El controlador de dominio será el servidor cajal.
        --> 1.3 - Crear la unidad organizativa empleados
        --> 1.4 - Crea los siguientes grupos de seguridad:
            --> 1.4.1 - Laboratorio
            --> 1.4.2 - Ventas
            --> 1.4.3 - Contabilidad.
        --> 1.5 - Crear los siguientes usuarios.
            --> 1.5.1 - Luis Tosar (Laboratorio)
            --> 1.5.2 - Victoria Abril (Ventas)
            --> 1.5.3 - Carmen Maura (Contabilidad)
        --> 1.6 - Asigna a los usuarios a sus correspondientes grupos de seguridad.
#>

# VARIABLES
$dominioFQDN = "farma.lab"

<# 1.1. - INSTALACION ACTIVE DIRECTORY #>
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# Carga del módulo de despliegue
Import-module addsdeployment 

<# 1.2. - CONTROLADOR DE DOMINIO #>
Install-ADDSForest -DomainName $dominioFQDN -SafeModeAdministratorPassword (ConvertTo-SecureString -string "P@ssw0rd" -AsPlainText -Force) -DomainMode WinThreshold -ForestMode WinThreshold -InstallDNS -Confirm:$false

# Reiniciar el PC
write-host -ForegroundColor Red "       Se procede al REINICIO DEL SISTEMA " -NoNewline
Start-Sleep -Seconds 5
restart-computer -Confirm:$False