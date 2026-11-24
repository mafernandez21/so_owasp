#!/bin/bash
# PUBLICADOR: crea la versión 1.0 del paquete "utilidad", la firma con su clave GPG
# y la sube al mirror (repositorio de descargas).
# CONSUMIDOR: audita esa versión una sola vez y fija su hash en requirements.lock.
set -euo pipefail
cd "$(dirname "$0")"
rm -rf mirror descargas gnupg requirements.lock instalado
mkdir -p mirror descargas gnupg/publicador gnupg/atacante gnupg/consumidor
chmod 700 gnupg/*

# --- Paquete legítimo ---
work=$(mktemp -d)
mkdir -p "$work/utilidad-1.0"
cat > "$work/utilidad-1.0/install.sh" <<'PKG'
#!/bin/bash
mkdir -p instalado
echo 'echo "utilidad 1.0 - herramienta legítima"' > instalado/utilidad
chmod +x instalado/utilidad
echo "[install.sh] utilidad 1.0 instalada en ./instalado/"
PKG
chmod +x "$work/utilidad-1.0/install.sh"
tar -C "$work" -czf mirror/utilidad-1.0.tar.gz utilidad-1.0
rm -rf "$work"

# --- Clave del publicador y firma del paquete ---
G="gpg --batch --quiet --pinentry-mode loopback --passphrase="
$G --homedir gnupg/publicador --quick-gen-key "Publicador Oficial <publicador@lab.local>" ed25519 sign never
$G --homedir gnupg/publicador --armor --detach-sign -o mirror/utilidad-1.0.tar.gz.asc mirror/utilidad-1.0.tar.gz
(cd mirror && sha256sum utilidad-1.0.tar.gz > utilidad-1.0.tar.gz.sha256)

# --- El consumidor obtiene la clave pública por un canal confiable y fija el hash ---
gpg --batch --quiet --homedir gnupg/publicador --export > gnupg/consumidor/claves_confiables.gpg
cut -d' ' -f1 mirror/utilidad-1.0.tar.gz.sha256 | sed 's/^/utilidad-1.0.tar.gz sha256=/' > requirements.lock

echo "Versión 1.0 publicada y firmada en ./mirror/"
echo "Hash fijado por el consumidor en requirements.lock:"
sed 's/^/   /' requirements.lock
