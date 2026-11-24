#!/bin/bash
# Informa el rol del usuario que lo ejecuta. Usa "id -un" (la identidad real del
# proceso) y no la variable $USER, que puede estar vacía o ser modificada.
usuario=$(id -un)
if [ "$(id -u)" -eq 0 ]; then echo "$usuario: administrador"
elif id -nG "$usuario" | grep -qw docentes; then echo "$usuario: docente"
else echo "$usuario: alumno (solo consulta)"; fi
