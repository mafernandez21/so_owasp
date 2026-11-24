#!/bin/bash
# Rediseño con separación de privilegios por rol, usando usuarios, grupos y permisos:
#  - root (administrador): único que modifica la configuración
#  - grupo "docentes": lee y modifica las notas
#  - el resto (alumnos): sin acceso directo a los archivos
set -euo pipefail
APP=/srv/lab_a06
./setup_insecure.sh >/dev/null           # partir siempre del mismo estado inicial
groupadd -f docentes
usermod -a -G docentes docente
chown root:docentes "$APP"
chmod 750 "$APP"                          # solo root y docentes entran al directorio
chown root:root "$APP/system.conf"
chmod 644 "$APP/system.conf"              # todos leen, solo root escribe
chown root:docentes "$APP/notas.csv"
chmod 660 "$APP/notas.csv"                # root y docentes leen y escriben
echo "Permisos aplicados:"
ls -ld "$APP"; ls -l "$APP"
