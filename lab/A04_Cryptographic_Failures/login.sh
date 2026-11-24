#!/bin/bash
# Verifica un inicio de sesión contra los hashes bcrypt.
# Uso: ./login.sh <usuario> <contraseña>
set -euo pipefail
cd "$(dirname "$0")"
if [ $# -ne 2 ]; then echo "Uso: $0 <usuario> <contraseña>"; exit 2; fi
# Los datos se pasan como argumentos al intérprete, nunca se insertan en el código.
python3 - "$1" "$2" <<'PY'
import csv, sys, bcrypt
user, password = sys.argv[1], sys.argv[2]
for row in csv.DictReader(open("data/users_hashed.csv")):
    if row["username"] == user and bcrypt.checkpw(password.encode(), row["password_hash"].encode()):
        print("Acceso concedido"); sys.exit(0)
print("Usuario o contraseña incorrectos"); sys.exit(1)
PY
