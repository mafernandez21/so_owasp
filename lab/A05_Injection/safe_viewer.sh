#!/bin/bash
# Visor de registros SEGURO:
#  1) lista blanca de caracteres para el nombre (sin ; | & $ espacios ni /)
#  2) la ruta final debe quedar dentro de logs/ (evita ../)
#  3) se ejecuta cat directamente, con la variable entre comillas y "--"
set -euo pipefail
cd "$(dirname "$0")"
FILE="${1-}"
[ -n "$FILE" ] || read -r -p "Archivo de registro a mostrar: " FILE
if [[ ! "$FILE" =~ ^[A-Za-z0-9_.-]+$ ]]; then
    echo "Nombre de archivo no válido: '$FILE'" >&2; exit 1
fi
BASE=$(realpath logs)
TARGET=$(realpath -m -- "logs/$FILE")
if [[ "$TARGET" != "$BASE"/* ]]; then
    echo "Ruta fuera del directorio permitido" >&2; exit 1
fi
cat -- "$TARGET"
