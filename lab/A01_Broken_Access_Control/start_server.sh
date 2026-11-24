#!/bin/bash
# Inicia el servidor en segundo plano.
#   ./start_server.sh            -> modo vulnerable
#   ./start_server.sh --secure   -> modo mitigado
set -euo pipefail
cd "$(dirname "$0")"
./stop_server.sh >/dev/null 2>&1 || true
python3 server.py "$@" > server.log 2>&1 &
echo $! > server.pid
sleep 1
head -n 1 server.log
echo "Registro del servidor: $(pwd)/server.log  -  Detener: ./stop_server.sh"
