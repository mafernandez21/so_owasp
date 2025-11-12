#!/bin/bash
set -e
cd "$(dirname "$0")"
mkdir -p labdata
echo "config_version=1" > labdata/system.conf
# create admin group and restrict file
groupadd -f labadmins
chown root:labadmins labdata/system.conf
chmod 0640 labdata/system.conf
cat > access_check.sh <<'AC'
#!/bin/bash
if id -nG "$USER" | grep -qw labadmins; then
  echo "Acceso permitido"
  cat labdata/system.conf
else
  echo "Acceso denegado: no pertenece a labadmins"
fi
AC
chmod +x access_check.sh
echo "Mitigación aplicada: archivo restringido a grupo 'labadmins'. Use 'usermod -a -G labadmins <user>' para añadir."