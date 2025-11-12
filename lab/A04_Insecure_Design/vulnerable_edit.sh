#!/bin/bash
set -e
cd "$(dirname "$0")"
mkdir -p labdata
echo "config_version=1" > labdata/system.conf
echo "Solamente por demo: cualquier usuario puede editar este archivo."
read -p "Ingrese línea para agregar a config: " LINE
# vulnerable: no checks
echo "$LINE" >> labdata/system.conf
echo "Nuevo contenido de config:"
cat labdata/system.conf
