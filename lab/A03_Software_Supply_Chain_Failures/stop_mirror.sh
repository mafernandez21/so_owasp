#!/bin/bash
cd "$(dirname "$0")"
if [ -f mirror.pid ]; then kill "$(cat mirror.pid)" 2>/dev/null && echo "Mirror detenido."; rm -f mirror.pid; else echo "No hay mirror en ejecución."; fi
