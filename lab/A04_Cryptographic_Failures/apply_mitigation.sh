#!/bin/bash
# Mitigación: reemplazar las contraseñas por hashes bcrypt (con sal y costo ajustable),
# eliminar el archivo en texto plano y restringir los permisos del nuevo archivo.
set -euo pipefail
cd "$(dirname "$0")"
python3 - <<'PY'
import csv, bcrypt
with open("data/users.csv") as f, open("data/users_hashed.csv", "w") as o:
    o.write("username,password_hash\n")
    for row in csv.DictReader(f):
        h = bcrypt.hashpw(row["password"].encode(), bcrypt.gensalt(rounds=12)).decode()
        o.write(f"{row['username']},{h}\n")
PY
shred -u data/users.csv
chmod 600 data/users_hashed.csv
echo "Hashes creados en data/users_hashed.csv (permisos 600); data/users.csv eliminado con shred."
