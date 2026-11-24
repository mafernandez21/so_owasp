#!/bin/bash
# Cualquiera que lea el archivo (un respaldo, un empleado, un atacante) ve todas las contraseñas.
cd "$(dirname "$0")"
echo "Contenido de data/users.csv:"
cat data/users.csv 2>/dev/null || echo "No existe data/users.csv (¿se ejecutó ./setup.sh o ya se aplicó la mitigación?)"
