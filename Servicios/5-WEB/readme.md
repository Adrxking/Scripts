HTTP --> Port 80.
HTTPs --> Port 443.

URL --> Universal Resources Localizator.
protocolo://FQDN.del.servidor|IP[:][puerto][/ruta][/documento][parámetros]

Protocolo --> HTTP o HTTPs
FQDN --> Nombre de dominio altamente cualificado
Puerto --> Por defecto puerto 80 para HTTP y 443 para HTTPs (Opcional)
Ruta y Documento --> Ruta y documento donde queremos acceder
Parámetros --> Para enviar parámetros al servidor por el método GET

DocumentRoot --> Donde cuelga la estructura de archivos del servidor web.

** Mensajes de Petición **
Está formado por:

Líneas de Petición:
--> Método: GET, POST...
--> La parte relativa al servidor de la URL o la URL completa si la conexión se establece
con un servidor proxy
--> Versión del protocolo (opcional): actualmente se usa HTTP/1.1

Líneas de cabecera:
--> Si no hay se envía un 0
--> Conjunto de pares nombre/valor denominados cabeceras que determinan cómo será
procesada la petición por parte del servidor.
--> Cada cabecera se muestra en una línea, es decir, las cabeceras se terminan con CRLF.
--> Detrás de la última cabecera se envía una línea en blanco

Cuerpo del mensaje (opcional): Contiene parámetros o ficheros a enviar al servidor

** Mensajes de Respuesta **
Está formado por:

Línea inicial de respuesta (línea de estado):
--> Versión HTTP utilizada.
--> Código de estado o código de error que informa al cliente de cómo ha sido procesada
la petición. Por ejemplo, el código 200 indica que la petición se ha procesado correctamente y que el recurso correspondiente se envía al cliente.
--> Texto explicativo del código del estado.

Línea/s de cabecera
--> Conjunto de pares nombre/valor denominados cabeceras que describen los datos y la
forma en que son enviados al cliente.
--> Si no hay cabeceras se envía un 0.
--> Cada cabecera se muestra en una línea, es decir, las cabeceras se terminan con CRLF.
--> Detrás de la última cabecera se envía una línea en blanco.

Cuerpo del mensaje (opcional). Queda determinado por el tipo de recursos solicitado.

** Métodos de Petición **
--> GET:
    - Se invoca cuando buscamos una URL
    - Permite enviar parámetros al servidor (Query String)
    - No envían cuerpo de mensaje
    - En las peticiones la información es visible
    - No se puede usar para subir archivos o otras peticiones que requieren enviar muchos datos al servidor

--> POST:
    - En las peticiones la información se encuentra en el cuerpo del mensaje
    - No deben ser repetidas
    - No se debe de cachear las respuestas
    - Sin límite de tamaño al enviar archivos al servidor

--> OPTIONS:
    - Para solicitar al servidor información sobre las opciones de comunicación disponibles
    de un recurso determinado.

--> HEAD:
    - Para recuperar las cabeceras de una página web.
    - Similar a GET pero el servidor devuelve cabeceras.
    - Usado para implementar caches de navegadores, informar al usuario del tamaño del
    recurso antes de intentar recuperarlo, etc.


--> PUT:
    - Para subir recursos al servidor.
    - Por seguridad no es habitual que los servidores web permitan subir recursos usando
    el método PUT.

--> DELETE:
    - Para eliminar recursos del servidor.
    - Por seguridad no es habitual que los servidores web permitan subir recursos usando
    el método DELETE

--> TRACE:
    - Para trazar la ruta de una petición a través de proxies y cortafuegos.
    - Usado para depurar errores en redes complejas.

** Códigos devueltos por el servidor **
--> 100-199 (Informativo)
    - Indican que el servidor ha recibido la petición pero no ha finalizado de procesarla
--> 200-299 (Éxito)
--> 300-399 (Redirección)
    - Indican que la petición ha sido procesada y redirigida
--> 400-499 (Errores del cliente)
    - 400 "Bad request" : Error de sintaxis
    - 401 "Unauthorized"
    - 403 "Forbidden"
    - 404 "Not found"

--> 500-599 (Errores del servidor)
    - 500 "Internal Server Error"
    - 503 "Service Unavailable"

** PROXY **
Proxy directo: Cuando se realiza una petición directa al servidor
Proxy inverso: Cuando se realiza una petición al proxy y este reenvia la petición

** COOKIES ** 
Fichero de texto guardado en el cliente.
Se envían en los headeres y pueden incluir:
    - Name: Nombre de la cookie
    - Value: Valor de la cookie
    - Expires: Fecha de expiración de la cookie
    - Path: Lugar donde la cookie será guardada por el navegador.
    - Domain: Nombre del dominio de donde "viene" la cookie.

** Sitios WEB Virtuales **
