#!/bin/bash
# Envía al servicio de reportes un pedido válido y dos que provocan excepciones.
URL=http://127.0.0.1:8010/reporte
for q in "alumnos=7" "alumnos=0" "alumnos=muchos"; do
    echo "GET /reporte?$q"
    curl -s -w "\n   -> HTTP %{http_code}\n\n" "$URL?$q" | sed 's/^/   /'
done
