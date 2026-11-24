#!/bin/bash
# Prepara los registros para el visor y una base SQLite. Se puede ejecutar varias veces.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf logs lab.db
mkdir -p logs
echo "2026-03-01 10:00 servicio iniciado" > logs/app.log
echo "2026-03-01 10:05 error de conexión" > logs/errores.log
sqlite3 lab.db <<'SQL'
CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, role TEXT, email TEXT);
INSERT INTO users(name, role, email) VALUES ('alice', 'user',  'alice@lab.local');
INSERT INTO users(name, role, email) VALUES ('bob',   'admin', 'bob@lab.local');
SQL
echo "Listo: logs/ y lab.db creados."
