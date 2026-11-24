#!/bin/bash
# Control de acceso VULNERABLE: interpreta mal los códigos de salida de grep.
#   grep devuelve 0 = encontrado, 1 = no encontrado, 2 = ERROR (p. ej., archivo inexistente)
# El script solo niega cuando el código es 1, así que ante un ERROR concede el acceso.
LISTA=/srv/lab_a10/autorizados.txt
USUARIO="${1:-$(id -un)}"
grep -qx "$USUARIO" "$LISTA"
if [ $? -ne 1 ]; then
    echo "ACCESO CONCEDIDO a $USUARIO"
else
    echo "Acceso denegado a $USUARIO"
fi
