$archivo = "C:\Users\adria\Downloads\wsl_update_x64"

dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

msiexec /i $archivo

wsl --set-default-version 2