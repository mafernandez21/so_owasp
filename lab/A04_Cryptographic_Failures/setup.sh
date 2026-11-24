#!/bin/bash
# Crea una "base de usuarios" con contraseñas guardadas en TEXTO PLANO.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf data && mkdir -p data
cat > data/users.csv <<'CSV'
username,password
alice,pass123
bob,secret
carol,pass123
CSV
echo "Base creada: data/users.csv (contraseñas en texto plano)"
