#!/bin/bash
# "Mejora" ingenua: guardar MD5 sin sal. Mostramos por qué no alcanza.
set -euo pipefail
cd "$(dirname "$0")"
python3 - <<'PY'
import csv, hashlib
users = list(csv.DictReader(open("data/users.csv")))
print("Hashes MD5 sin sal:")
hashes = {}
for u in users:
    h = hashlib.md5(u["password"].encode()).hexdigest()
    hashes[u["username"]] = h
    print(f"   {u['username']:6} {h}")
print("\n-> alice y carol tienen el MISMO hash: se nota que comparten contraseña.\n")

diccionario = ["123456", "password", "qwerty", "secret", "pass123", "admin"]
print(f"Ataque de diccionario con {len(diccionario)} palabras comunes:")
for user, h in hashes.items():
    for palabra in diccionario:
        if hashlib.md5(palabra.encode()).hexdigest() == h:
            print(f"   {user:6} -> contraseña recuperada: {palabra}")
            break
PY
