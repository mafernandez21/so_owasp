#!/bin/bash
# Compara ambos controles en funcionamiento normal y cuando falta la configuración.
cd "$(dirname "$0")"
probar() {
    for u in docente alumno; do
        printf '   vulnerable: '; ./acceso_vulnerable.sh "$u"
        printf '   seguro:     '; ./acceso_seguro.sh "$u" 2>/dev/null || true
    done
}
./setup.sh >/dev/null
echo "1) Funcionamiento normal (la lista existe):"
probar
echo
echo "2) Condición excepcional: un despliegue fallido borró la lista de autorizados"
mv /srv/lab_a10/autorizados.txt /srv/lab_a10/autorizados.txt.perdido
probar
mv /srv/lab_a10/autorizados.txt.perdido /srv/lab_a10/autorizados.txt
