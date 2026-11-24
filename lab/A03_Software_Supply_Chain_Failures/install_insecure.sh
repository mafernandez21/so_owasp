#!/bin/bash
# Instalación INSEGURA: descarga, "verifica" con el hash que publica el MISMO mirror
# y ejecuta el instalador del paquete.
set -euo pipefail
cd "$(dirname "$0")"
URL=http://127.0.0.1:8003
rm -rf descargas instalado && mkdir -p descargas
curl -sSf -o descargas/utilidad-1.0.tar.gz "$URL/utilidad-1.0.tar.gz"
curl -sSf -o descargas/utilidad-1.0.tar.gz.sha256 "$URL/utilidad-1.0.tar.gz.sha256"
(cd descargas && sha256sum -c utilidad-1.0.tar.gz.sha256)
echo "El hash coincide con el que publica el mirror... pero ambos vienen del mismo lugar."
tar -C descargas -xzf descargas/utilidad-1.0.tar.gz
./descargas/utilidad-1.0/install.sh
