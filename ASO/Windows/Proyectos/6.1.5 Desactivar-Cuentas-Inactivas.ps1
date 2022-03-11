<# 
.SYNOPSIS
	Desactivar las cuentas inactivas en AD
#>

try {
    $StopWatch = [system.diagnostics.stopwatch]::startNew()

    Search-ADAccount -AccountInactive -TimeSpan 90.00:00:00 | Where-Object{$_.enabled -eq $true} | ForEach-Object{Get-ADUser $_.ObjectGuid} | Select-Object name, givenname, surname | export-csv c:\report\unusedaccounts.csv -NoTypeInformation
    
	[int]$Elapsed = $StopWatch.Elapsed.TotalSeconds
	"✔️ Desactivadas todas las cuentas de AD inactivas en $Elapsed seg"
    exit 0
}
catch {
    "⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
    exit 1
}