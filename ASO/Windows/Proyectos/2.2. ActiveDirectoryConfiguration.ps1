<# PARTE 2
    --> 1. Realizar la instalación y configuración de Active Directory utilizando PowerShell 
        y teniendo en cuenta los siguientes requisitos:

        --> 1.1 - El dominio de la empresa es farma.lab
        --> 1.2 - El controlador de dominio será el servidor cajal.
        --> 1.3 - Crear la unidad organizativa empleados
        --> 1.4 - Crea los siguientes grupos de seguridad:
            --> 1.4.1 - Laboratorio
            --> 1.4.2 - Ventas
            --> 1.4.3 - Contabilidad.
        --> 1.5 - Crear los siguientes usuarios.
            --> 1.5.1 - Luis Tosar (Laboratorio)
            --> 1.5.2 - Victoria Abril (Ventas)
            --> 1.5.3 - Carmen Maura (Contabilidad)
        --> 1.6 - Asigna a los usuarios a sus correspondientes grupos de seguridad.
#>

<# 1.3. - UNIDAD ORGANIZATIVA EMPLEADOS #>
New-ADOrganizationalUnit usuarios -Path "DC=farma,DC=lab"
New-ADOrganizationalUnit empleados -Path "DC=farma,DC=lab"

<# 1.4. - GRUPOS DE SEGURIDAD #>
New-ADGroup Contabilidad -Path "OU=empleados,DC=farma,DC=lab" -GroupScope Global -SamAccountName Contabilidad
New-ADGroup Ventas -Path "OU=empleados,DC=farma,DC=lab" -GroupScope Global -SamAccountName Ventas
New-ADGroup Laboratorio -Path "OU=empleados,DC=farma,DC=lab" -GroupScope Global -SamAccountName Laboratorio

<# 1.5. - USUARIOS #>
New-ADUser "Luis Tosar" -Path "OU=usuarios,DC=farma,DC=lab" -SamAccountName luistosar
New-ADUser "Victoria Abril" -Path "OU=usuarios,DC=farma,DC=lab" -SamAccountName victoriaabril
New-ADUser "Carmen Maura" -Path "OU=usuarios,DC=farma,DC=lab" -SamAccountName carmenmaura

<# 1.6. - ASIGNAR A LOS USUARIOS SUS GRUPOS #>
Add-ADGroupmember Contabilidad -Members carmenmaura
Add-ADGroupmember Ventas -Members victoriaabril
Add-ADGroupmember Laboratorio -Members luistosar

# Establecer contraseñas a los usuarios
Set-ADAccountPassword carmenmaura -NewPassword (ConvertTo-SecureString -AsPlainText "P@ssw0rd" -force)
Set-ADAccountPassword victoriaabril -NewPassword (ConvertTo-SecureString -AsPlainText "P@ssw0rd" -force)
Set-ADAccountPassword luistosar -NewPassword (ConvertTo-SecureString -AsPlainText "P@ssw0rd" -force)
# Obliga al usuario a cambiar la contraseña en el próximo intento de inicio de sesión.
Set-ADUser carmenmaura -ChangePasswordAtLogon $True
Set-ADUser victoriaabril -ChangePasswordAtLogon $True
Set-ADUser luistosar -ChangePasswordAtLogon $True
# Habilitar las cuentas de los usuarios
Enable-ADAccount carmenmaura
Enable-ADAccount victoriaabril
Enable-ADAccount luistosar