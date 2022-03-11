<# 
.SYNOPSIS
	Crear un reporte de las cuentas inactivas en AD
#>

try {
    $StopWatch = [system.diagnostics.stopwatch]::startNew()

    Search-ADAccount -AccountInactive -TimeSpan -90:00:00:00 | Disable-ADAccount
    
	[int]$Elapsed = $StopWatch.Elapsed.TotalSeconds
	"✔️ Creado un reporte de las cuentas de AD inactivas en $Elapsed seg en el disco C:\"
    exit 0
}
catch {
    "⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
    exit 1
}