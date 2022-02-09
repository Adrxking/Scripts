<?php
# Creacion de funcion que hace un console log
function write_to_console($data) {

 $console = 'console.log(' . json_encode($data) . ');';
 $console = sprintf('<script>%s</script>', $console);
 echo $console;
}

# Creacion de una variable que vamos a mostrar en el console log
$days = array("Sun", "Mon", "Tue");

# Ejecutar la funcion con los datos
write_to_console($days);
?>