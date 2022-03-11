# 1) Utilizando un fichero LDIF, añade algunos usuarios de ejemplo a nuestro dominio.
Ldifde -i -f Usuarios.ldif

# 2) Exporta todos los usuarios de Active Directory a un fichero LDIF.
Ldifde -r "objectClass=User" -f ldifde.txt

# 3) Mejora el script en PowerShell visto en clase para la importación de usuarios. 
#    Por ejemplo el script puede solicitar el fichero de importación. 
#    Otra mejora puede ser incluir en el fichero de importación otros atributos como el teléfono o 
#    la dirección de correo.
Clear-Host

$Archivo = Read-Host -Prompt 'Introduce la ruta del archivo de importación LDIF'

if ( Test-Path -Path $Archivo -PathType leaf ) {
    Ldifde -i -f $Archivo
} else {
    Write-Host "El archivo no existe, comprueba que la ruta introducida es correcta"
}