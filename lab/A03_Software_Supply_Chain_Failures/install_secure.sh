#!/bin/bash
# Instalación SEGURA:
#  1) compara el hash del archivo descargado con el fijado por el consumidor (requirements.lock)
#  2) verifica la firma con la clave pública del publicador obtenida por un canal confiable
#  3) recién entonces extrae y ejecuta, usando EL MISMO archivo que se verificó
set -euo pipefail
cd "$(dirname "$0")"
URL=http://127.0.0.1:8003
PKG=utilidad-1.0.tar.gz
rm -rf descargas instalado && mkdir -p descargas
curl -sSf -o "descargas/$PKG" "$URL/$PKG"
curl -sSf -o "descargas/$PKG.asc" "$URL/$PKG.asc"

esperado=$(grep "^$PKG " requirements.lock | sed 's/.*sha256=//')
obtenido=$(sha256sum "descargas/$PKG" | cut -d' ' -f1)
echo "Hash esperado (requirements.lock): $esperado"
echo "Hash del archivo descargado:       $obtenido"
if [ "$esperado" != "$obtenido" ]; then
    echo "ERROR: el hash no coincide con la versión auditada. Instalación cancelada." >&2
    exit 1
fi

if ! gpgv --keyring ./gnupg/consumidor/claves_confiables.gpg "descargas/$PKG.asc" "descargas/$PKG" 2>/dev/null; then
    echo "ERROR: la firma no corresponde al publicador confiable. Instalación cancelada." >&2
    exit 1
fi
echo "Hash y firma verificados."
tar -C descargas -xzf "descargas/$PKG"
./descargas/utilidad-1.0/install.sh
