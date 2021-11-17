.     --> Permite cualquier caracter
[ ]   --> Permite ese rango de caracteres
[^ ]  --> Permite todos los caracteres excepto los introducidos en los corchetes
*     --> Permite 0 o + del item anterior
+     --> Permite 1 o + del item anterior
?     --> Permite 0 o 1 del item anterior
{n}   --> Permite ‘n’ números del item anterior
{n,}  --> Permite mínimo ‘n’ números del item anterior
{n m} --> Permite entre ‘n’ y ‘m’ números del item anterior
{ ,m} --> Permite máximo ‘m’ números, m incluido del item anterior
\     --> Permite escapar caracteres

Ejemplo filtro de números positivos y negativos con decimales
'^[-+]?[0-9]+\.?[0-9]*$'

Ejemplo filtro de operadores matemáticos
'^[-+*/]{1}$'