#!/bin/bash
# Mitigación: reemplazar contraseñas en texto plano por bcrypt hashes (usa python)
set -e
cd "$(dirname "$0")"
python3 - <<'PY'
import csv, bcrypt
infile='data/users.csv'
outfile='data/users_hashed.csv'
with open(infile,'r') as f, open(outfile,'w') as o:
    r=csv.DictReader(f)
    o.write('username,password_hash\n')
    for row in r:
        pw=row['password'].encode()
        h=bcrypt.hashpw(pw, bcrypt.gensalt()).decode()
        o.write(f"{row['username']},{h}\n")
print('Hashed file created: data/users_hashed.csv')
PY