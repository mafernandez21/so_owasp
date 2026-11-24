#!/bin/bash
# Control de acceso SEGURO ("fail closed"): ante cualquier situación inesperada se niega.
set -euo pipefail
LISTA=/srv/lab_a10/autorizados.txt
denegar() { echo "Acceso denegado a ${USUARIO:-?}${1:+ ($1)}"; exit 1; }
# Si cualquier comando falla de forma inesperada, se niega el acceso.
trap 'denegar "error inesperado en la línea $LINENO"' ERR

USUARIO="${1:-$(id -un)}"
if [ ! -r "$LISTA" ]; then
    logger -t lab_a10 "ERROR: no se puede leer $LISTA" 2>/dev/null || true
    echo "ERROR: no se puede leer la lista de autorizados; se registra el incidente." >&2
    denegar "configuración no disponible"
fi
# -F: texto literal, -x: línea completa, --: fin de opciones (el usuario no puede inyectar opciones)
if grep -qxF -- "$USUARIO" "$LISTA"; then
    echo "ACCESO CONCEDIDO a $USUARIO"
else
    denegar
fi
