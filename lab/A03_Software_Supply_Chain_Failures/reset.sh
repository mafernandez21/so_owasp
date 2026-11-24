#!/bin/bash
cd "$(dirname "$0")"
./stop_mirror.sh >/dev/null 2>&1
rm -rf mirror descargas gnupg instalado requirements.lock mirror.log /tmp/COMPROMETIDO.txt
echo "Laboratorio reiniciado."
