<# 
.SYNOPSIS
	Script que pasa el texto enviado por parametro a voz
#>

param([string]$text = "")

function GetTempDir {
	if ("$env:TEMP" -ne "")	{ return "$env:TEMP" }
	if ("$env:TMP" -ne "")	{ return "$env:TMP" }
	if ($IsLinux) { return "/tmp" }
	return "C:\Temp"
}

try {
	# Mandar el reply a la consola:
	" ← $text"

	# Codigo para que el texto lo pase a voz (TTS):
	if (!$IsLinux) {
		$TTSVoice = New-Object -ComObject SAPI.SPVoice
		foreach ($Voice in $TTSVoice.GetVoices()) {
			if ($Voice.GetDescription() -like "*- Spanish*") { $TTSVoice.Voice = $Voice }
		}
		[void]$TTSVoice.Speak($text)
	}

	# Recordar la ultima:
	"$text" > "$(GetTempDir)/last_reply_given.txt"
	exit 0
} catch {
	"⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
	exit 1
}