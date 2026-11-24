#!/bin/bash
# Endurece la configuración de Apache y elimina los archivos que no deben publicarse.
set -euo pipefail

a2enmod -q headers >/dev/null

# 1) Corregir el sitio: sin listado de directorios y bloqueando respaldos
cat > /etc/apache2/sites-available/lab-a02.conf <<'CONF'
Listen 8002
<VirtualHost *:8002>
    DocumentRoot /var/www/lab_a02
    <Directory /var/www/lab_a02>
        Options -Indexes -FollowSymLinks
        AllowOverride None
        Require all granted
        # Bloquear respaldos y archivos de configuración aunque alguien los deje ahí
        <FilesMatch "\.(bak|old|orig|swp|env|sql|conf)$">
            Require all denied
        </FilesMatch>
    </Directory>
</VirtualHost>
CONF

# 2) Endurecer la configuración global (el prefijo "zz-" la carga después de security.conf)
cat > /etc/apache2/conf-available/zz-lab-a02-hardening.conf <<'CONF'
ServerName localhost
# Ocultar versión y firma del servidor
ServerTokens Prod
ServerSignature Off
TraceEnable Off

# Cabeceras HTTP de seguridad (OWASP Secure Headers Project)
Header always set X-Content-Type-Options "nosniff"
Header always set X-Frame-Options "DENY"
Header always set Content-Security-Policy "default-src 'self'"
Header always set Referrer-Policy "no-referrer"
CONF

a2disconf -q zz-lab-a02-inseguro >/dev/null 2>&1 || true
a2enconf -q zz-lab-a02-hardening >/dev/null
# Buena práctica adicional: los respaldos no deben estar en el directorio publicado
rm -f /var/www/lab_a02/archivos/*.bak

apache2ctl configtest
# ServerTokens solo se aplica al reiniciar Apache por completo
apache2ctl -k stop
sleep 1
apache2ctl start
sleep 1
echo "Mitigación aplicada. Volver a ejecutar ./exploit.sh"
