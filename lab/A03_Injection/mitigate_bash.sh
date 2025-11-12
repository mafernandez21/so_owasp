#!/bin/bash
cd "$(dirname "$0")"
cat > safe.sh <<'SAFE'
#!/bin/bash
echo "Ingrese nombre de archivo:"
read FILE
# safe: use -- and quote variable
cat -- "$FILE"
SAFE
chmod +x safe.sh
echo "Script seguro creado (safe.sh). Ejecutar ./safe.sh"