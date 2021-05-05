cd HKLM:\
$RegKey ='HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system'
Set-ItemProperty -Path $RegKey -Name EnableLUA -Value 0 -Confirm:$False