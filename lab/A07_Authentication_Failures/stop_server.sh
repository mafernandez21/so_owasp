#!/bin/bash
cd "$(dirname "$0")"
if [ -f server.pid ]; then kill "$(cat server.pid)" 2>/dev/null && echo "Servidor detenido."; rm -f server.pid; else echo "No hay servidor en ejecución."; fi
