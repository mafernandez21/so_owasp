#!/bin/bash
# Búsqueda SEGURA: consulta parametrizada. La entrada se pasa como ARGUMENTO al
# programa Python (sys.argv); nunca se inserta en el código ni en el texto SQL.
# Uso: ./mitigate_sql.sh [nombre]   (por defecto: ' OR '1'='1)
cd "$(dirname "$0")"
INPUT="${1-' OR '1'='1}"
echo "Entrada: $INPUT"
python3 - "$INPUT" <<'PY'
import sqlite3, sys
conn = sqlite3.connect("lab.db")
rows = conn.execute("SELECT id, name, role, email FROM users WHERE name = ?", (sys.argv[1],)).fetchall()
print(rows if rows else "Sin resultados")
PY
