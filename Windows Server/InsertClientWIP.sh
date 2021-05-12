Clear

$IP = Read-Host "Dame IP: "

if ( Test-Connection -computer $IP -Quiet )
  { Write-Host -ForegroundColor Green " $IP Ping Ok!"
    write-host " "
    write-host " Incluimos al cliente con IP $IP en el dominio . . ."
    # Add-Computer -ComputerName "W10" -DomainName "midominio.local" -Credential Midominio\Administrador -Restart -Force
    Add-Computer -ComputerName W10 -LocalCredential W10\Administrador -DomainName MIDOMINIO.LOCAL -Credential "MIDOMINIO\Administrador" -Restart -Force

  }
else 
  { Write-Host -ForegroundColor Red " $IP Ping no OK!" }

# Ejecutar en remoto comandos desde server

# Invoke-Command -ComputerName Equip1, Equip2 -FilePath c:\Ruta_De_Scripts\script.ps1