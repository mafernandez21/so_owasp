#!/bin/bash
# Prueba qué puede hacer cada rol. Se ejecuta como root y usa "su" para actuar como
# los usuarios sin privilegios "alumno" y "docente" (creados en la imagen).
APP=/srv/lab_a06
como() {  # $1 = usuario, $2 = descripción, $3 = comando
    printf '%-8s %-45s ' "$1" "$2"
    if su -s /bin/bash "$1" -c "$3" >/dev/null 2>&1; then echo "PERMITIDO"; else echo "denegado"; fi
}
como alumno  "leer notas.csv"                    "cat $APP/notas.csv"
como alumno  "cambiar su propia nota a 10"        "sed -i 's/^alumno,Sistemas Operativos,4$/alumno,Sistemas Operativos,10/' $APP/notas.csv"
como alumno  "nombrarse administrador"            "echo administrador=alumno >> $APP/system.conf"
como docente "cargar una nota"                    "echo nuevo,Sistemas Operativos,7 >> $APP/notas.csv"
como docente "abrir las inscripciones (config)"   "sed -i s/inscripciones_abiertas=no/inscripciones_abiertas=si/ $APP/system.conf"
echo
echo "Estado actual de los archivos:"
for f in "$APP"/system.conf "$APP"/notas.csv; do echo "--- $f"; cat "$f"; done
