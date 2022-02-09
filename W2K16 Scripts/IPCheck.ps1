 if ([ipaddress]::TryParse((read-host "Dame ip"),[ref][ipaddress]::Loopback)) {
    echo "La IP es Correcta"
  } else {
        echo "La ip es incorrecto"
  }