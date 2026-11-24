#!/bin/bash
# Crea la lista de usuarios autorizados para entrar a la "sala de servidores".
set -euo pipefail
mkdir -p /srv/lab_a10
printf '%s\n' docente root > /srv/lab_a10/autorizados.txt
chmod 644 /srv/lab_a10/autorizados.txt
echo "Usuarios autorizados (/srv/lab_a10/autorizados.txt):"
sed 's/^/   /' /srv/lab_a10/autorizados.txt
