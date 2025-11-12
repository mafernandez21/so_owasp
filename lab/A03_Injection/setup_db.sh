#!/bin/bash
set -e
cd "$(dirname "$0")"
# Crear DB simple
sqlite3 lab.db <<'SQL'
CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, role TEXT);
INSERT INTO users(name,role) VALUES('alice','user');
INSERT INTO users(name,role) VALUES('bob','admin');
SQL
echo 'lab.db creado.'
