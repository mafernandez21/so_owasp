#!/bin/bash
# Sistema de notas diseñado SIN separación de roles: un único directorio compartido
# donde cualquier usuario del sistema puede leer y modificar todo.
# Requiere ejecutarse como root (lo es por defecto dentro del contenedor).
set -euo pipefail
APP=/srv/lab_a06
rm -rf "$APP" && mkdir -p "$APP"
cat > "$APP/system.conf" <<'CONF'
inscripciones_abiertas=no
administrador=root
CONF
cat > "$APP/notas.csv" <<'CSV'
alumno,materia,nota
alumno,Sistemas Operativos,4
otro_alumno,Sistemas Operativos,9
CSV
chmod 777 "$APP"
chmod 666 "$APP"/system.conf "$APP"/notas.csv
echo "Sistema de notas instalado en $APP con permisos para todos:"
ls -l "$APP"
