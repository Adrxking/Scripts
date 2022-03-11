<# 
.SYNOPSIS
	Script que abre el navegador por defecto
#>

param([string]$URL = "https://www.adrianstudio.es")

try {
	Start-Process $URL
	exit 0
} catch {
	"⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
	exit 1
}