1. Utiliza un FTP cliente en modo texto
    1.1. Conecta como anonimo al servidor ftp.rediris.es
    --> ftp
    --> open ftp.rediris.es
    --> anonymous
    --> passive
    1.2. Crea una carpeta local con tu nombre
    --> !mkdir adrian
    1.3. Cambia al directorio sites/apache.org en el equipo remoto
    --> cd sites/apache.org
    1.4. Descarga el archivo README.html
    --> get README.html

2. Instala y configura el servidor FTP filezilla Server en tu windows con las siguientes caracteristicas:
    --> Permitir una aplicacion a traves del firewall de windows: C:/Program Files/filezilla server/ 
    2.1. Maximo 5 conexiones permitidas * NO DISPONIBLE
    2.2. Tiempo de inactividad: * NO DISPONIBLE
    2.3. Mensaje de bienvenida: "Servidor FTP de nombre" * NO DISPONIBLE
    2.4. La direccion 10.33.tu_numero.50 esta prohibida
        --> FTP_SERVER > Filters > disallowed 10.33.6.50
    2.5. Acceso permitido a usuarios anonimos sobre el directorio C:/tunombre/publico solo con permisos de descarga
        --> Crear la carpeta
        --> Users > add > anonymous : Virtual Path / . Native Path C:\adrian\public
    2.6. Crea el usuario capitan con directorio C:/tunombre con todos los permisos
        --> Users > add > capitan
    2.7. Usuarios soldado1 y soldado2 pertenecientes al grupo soldados con sus directorios personales 
    debajo de C:\adrian\soldados con permisos totales
    2.8. Velocidad de subida para soldados 5Kb/s