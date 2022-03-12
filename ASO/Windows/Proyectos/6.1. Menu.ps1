<# 
.SYNOPSIS
	Menu para ejecutar diferentes scripts
#>

using namespace System.Management.Automation.Host

function New-Menu {
	<# DECLARACION DE LOS PARAMETROS DEL MENU #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Question
    )
    
	<# VARIABLES CON LAS OPCIONES DEL MENU #>
    $reportInactiveUsers = [ChoiceDescription]::new('&Log Usuarios Inactivos', 'Crea un report de los usuarios que llevan inactivos mas de 90 dias')
    $disableInactiveUsers = [ChoiceDescription]::new('&Desactivar Usuarios Inactivos', 'Desactivar los usuarios que llevan inactivos mas de 90 dias')
    $checkCPUTemp = [ChoiceDescription]::new('&VOZ: Comprobar Temperatura CPU', 'Comprobar la temperatura de tu CPU asistido con una voz')
    $openStackOverflow = [ChoiceDescription]::new('&NECESITAS AYUDA? Abre StackOverflow', 'Abre StackOverFlow para recibir ayuda')
    $restartNetworkInterfaces = [ChoiceDescription]::new('&Reiniciar Interfaces de Red', 'Reinicia todas las interfaces de tu red local')
    $checkCryptos = [ChoiceDescription]::new('&Comprobar Criptos', 'Comprueba el valor en tiempo real de las criptos mas vendidas')

	<# Variable con un array de las opciones del menu #>
    $options = [ChoiceDescription[]]($reportInactiveUsers, $disableInactiveUsers, $checkCPUTemp, $openStackOverflow, $restartNetworkInterfaces, $checkCryptos)

	<# Variable donde se almacena la respuesta del usuario #>
    $result = $host.ui.PromptForChoice($Title, $Question, $options, 0)

	<# Ejecutar el script adecuado a la respuesta #>
    switch ($result) {
        <# Desactivar las cuentas que llevan inactivas 90 días o más #>
        0 { & "$PSScriptRoot\6.1.6 Crear-Reporte-Cuentas-Inactivas.ps1" }
        <# Desactivar las cuentas que llevan inactivas 90 días o más #>
        1 { & "$PSScriptRoot\6.1.5 Desactivar-Cuentas-Inactivas.ps1" }	
	    <# Comprobar la temperatura de la CPU #>
        2 { & "$PSScriptRoot\6.1.1 Check-CPU-Temp.ps1" }
        <# Abrir StackOverflow #>
        3 { & "$PSScriptRoot\6.1.4 Open-Stack-Overflow.ps1" }
        <# Reiniciar las interfaces de red de la red local #>
        4 { & "$PSScriptRoot\6.1.7 Restart-Network-Interfaces.ps1" }	
	    <# Comprobar las criptomonedas #>
        5 { & "$PSScriptRoot\6.1.8 List-Crypto.ps1" }
    }

}

New-Menu -Title '===== MENU ADRIAN =====' -Question '¿Que opcion deseas seleccionar?'