#!/bin/bash
# Visor de registros VULNERABLE: arma un comando como texto y lo ejecuta con bash -c.
# Uso: ./vuln_viewer.sh <archivo>   (o sin argumento para ingresarlo por teclado)
cd "$(dirname "$0")"
FILE="${1-}"
[ -n "$FILE" ] || read -r -p "Archivo de registro a mostrar: " FILE
bash -c "cat logs/$FILE"
