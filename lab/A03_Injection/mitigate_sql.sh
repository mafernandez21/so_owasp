#!/bin/bash
cd "$(dirname "$0")"

read -p "Ingrese nombre a buscar (ej: alice): " name

python3 - <<PY
import sqlite3
conn = sqlite3.connect('lab.db')
cur = conn.cursor()
cur.execute('SELECT id, name, role FROM users WHERE name = ?', ("$name",))
for row in cur.fetchall():
    print(row)
conn.close()
PY
