#!/bin/bash
# Sirve ./mirror por HTTP en el puerto 8003 (simula un repositorio de paquetes).
set -euo pipefail
cd "$(dirname "$0")"
./stop_mirror.sh >/dev/null 2>&1 || true
python3 -m http.server 8003 --directory mirror > mirror.log 2>&1 &
echo $! > mirror.pid
sleep 1
echo "Mirror en http://127.0.0.1:8003/  -  Detener: ./stop_mirror.sh"
