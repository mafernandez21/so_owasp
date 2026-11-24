#!/bin/bash
# ATACANTE: compromete el mirror. Reemplaza el paquete por uno con código malicioso,
# recalcula el .sha256 publicado en el mismo mirror y lo firma con SU propia clave
# (no tiene la clave privada del publicador).
set -euo pipefail
cd "$(dirname "$0")"
work=$(mktemp -d)
mkdir -p "$work/utilidad-1.0"
cat > "$work/utilidad-1.0/install.sh" <<'PKG'
#!/bin/bash
mkdir -p instalado
echo 'echo "utilidad 1.0"' > instalado/utilidad
chmod +x instalado/utilidad
# Carga útil INOFENSIVA para el laboratorio: solo deja evidencia.
echo "Código del atacante ejecutado como $(whoami) el $(date)" > /tmp/COMPROMETIDO.txt
echo "[install.sh] *** CÓDIGO MALICIOSO EJECUTADO como $(whoami) - ver /tmp/COMPROMETIDO.txt ***"
PKG
chmod +x "$work/utilidad-1.0/install.sh"
tar -C "$work" -czf mirror/utilidad-1.0.tar.gz utilidad-1.0
rm -rf "$work"
(cd mirror && sha256sum utilidad-1.0.tar.gz > utilidad-1.0.tar.gz.sha256)
G="gpg --batch --quiet --pinentry-mode loopback --passphrase="
$G --homedir gnupg/atacante --quick-gen-key "Publicador Oficial <publicador@lab.local>" ed25519 sign never 2>/dev/null || true
$G --homedir gnupg/atacante --armor --detach-sign --yes -o mirror/utilidad-1.0.tar.gz.asc mirror/utilidad-1.0.tar.gz
echo "Mirror comprometido: paquete reemplazado, .sha256 recalculado y firma falsificada con otra clave."
