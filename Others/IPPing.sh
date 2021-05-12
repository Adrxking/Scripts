$IP = Read-Host "Dame IP: "
    if ( Test-Connection -computer $IP -Quiet )

      { Write-Host -ForegroundColor Green " $IP Ping Ok!" }
   else 
     { Write-Host -ForegroundColor Red " $IP Ping no OK!" }