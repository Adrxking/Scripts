^     --> Representa el comienzo de una cadena
$     --> Representa el final de una cadena
.     --> Permite cualquier caracter
[ ]   --> Permite ese rango de caracteres si se expresa con (-) o esos caracteres si no lleva guión
[^ ]  --> Permite todos los caracteres excepto los introducidos en los corchetes
*     --> Permite 0 o + del item anterior
+     --> Permite 1 o + del item anterior
?     --> Permite 0 o 1 del item anterior
{n}   --> Permite ‘n’ números del item anterior
{n,}  --> Permite mínimo ‘n’ números del item anterior
{n m} --> Permite entre ‘n’ y ‘m’ números del item anterior
{ ,m} --> Permite máximo ‘m’ números, m incluido del item anterior
\     --> Permite escapar caracteres
|     --> Permite que aparezca una opción u otra Ej: "uno|dos"
()    --> Permite representar conjuntos Ej: "(ab)+" --> Solo muestra lo que tenga ab si o sí

Ejemplo filtro de números positivos y negativos con decimales
'^[-+]?[0-9]+\.?[0-9]*$'

Ejemplo filtro de operadores matemáticos
'^[-+*/]{1}$'