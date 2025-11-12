#!/bin/bash
set -e
cd "$(dirname "$0")"
# Simula descarga copiando archivo desde repo to /tmp and ejecutando sin verificar
cp repo/app_v1.sh /tmp/app.sh
chmod +x /tmp/app.sh
echo "Executing update without verification (insecure):"
/tmp/app.sh
