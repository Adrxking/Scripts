<# 
.SYNOPSIS
	Comprobar la temperatura de la CPU
#>

try {
	if (test-path "/sys/class/thermal/thermal_zone0/temp" -pathType leaf) {
		<# Obtener los grados de la CPU #>
		[int]$IntTemp = get-content "/sys/class/thermal/thermal_zone0/temp"
		$Temp = [math]::round($IntTemp / 1000.0, 1)
	} else {
		<# Obtener los grados de la CPU #>
		$data = Get-WMIObject -Query "SELECT * FROM Win32_PerfFormattedData_Counters_ThermalZoneInformation" -Namespace "root/CIMV2"
		$Temp = @($data)[0].HighPrecisionTemperature
		$Temp = [math]::round($Temp / 100.0, 1)
	}

	<# Dependiendo de los grados añadir una respuesta u otra #>
	if ($Temp -gt 80) {
		$Reply = "La CPU esta a $($Temp)°Celsius, esta muy caliente!"
	} elseif ($Temp -gt 50) {
		$Reply = "La CPU esta a $($Temp)°Celsius, esta caliente"
	} elseif ($Temp -gt 0) {
		$Reply = "La CPU esta a $($Temp)°Celsius, esta templado"
	} elseif ($Temp -gt -20) {
		$Reply = "La CPU esta a $($Temp)°Celsius, esta frio"
	} else {
		$Reply = "La CPU esta a $($Temp)°Celsius, esta muy frio!"
	}

	<# Mandar al script la respuesta que debe ejecutar con voz #>
	& "$PSScriptRoot/6.1.3 Give-Reply.ps1" "$Reply"

	exit 0
} catch {
	"⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
	exit 1
}