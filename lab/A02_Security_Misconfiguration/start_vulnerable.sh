#!/bin/bash
# Configura y arranca Apache en el puerto 8002 con una configuración insegura:
#  - listado de directorios activado (Options Indexes)
#  - versión del servidor y del sistema operativo expuestas (ServerTokens Full)
#  - firma en las páginas de error (ServerSignature On), método TRACE habilitado
#  - sin cabeceras HTTP de seguridad
#  - archivos de respaldo olvidados dentro del directorio publicado
set -euo pipefail

DOCROOT=/var/www/lab_a02
mkdir -p "$DOCROOT/archivos"
echo "<h1>Portal de la empresa</h1>" > "$DOCROOT/inicio.html"
echo "Informe trimestral" > "$DOCROOT/archivos/informe.txt"
cat > "$DOCROOT/archivos/config.php.bak" <<'BAK'
<?php
// Respaldo olvidado por un administrador
$db_host = "10.0.0.5";
$db_user = "admin";
$db_pass = "Pr0duccion2026!";
BAK

cat > /etc/apache2/sites-available/lab-a02.conf <<'CONF'
Listen 8002
<VirtualHost *:8002>
    DocumentRoot /var/www/lab_a02
    <Directory /var/www/lab_a02>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>
</VirtualHost>
CONF

# El prefijo "zz-" hace que se cargue después de security.conf de Ubuntu
cat > /etc/apache2/conf-available/zz-lab-a02-inseguro.conf <<'CONF'
ServerName localhost
ServerTokens Full
ServerSignature On
TraceEnable On
CONF

a2dissite -q 000-default >/dev/null 2>&1 || true
a2disconf -q zz-lab-a02-hardening >/dev/null 2>&1 || true
a2enconf -q zz-lab-a02-inseguro >/dev/null
a2ensite -q lab-a02 >/dev/null
apache2ctl -k stop >/dev/null 2>&1 || true
sleep 1
apache2ctl start
sleep 1
echo "Apache (configuración INSEGURA) escuchando en http://127.0.0.1:8002/"
