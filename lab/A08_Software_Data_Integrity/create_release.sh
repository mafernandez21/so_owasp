#!/bin/bash
set -e
cd "$(dirname "$0")"
mkdir -p repo
cat > repo/app_v1.sh <<'APP'
#!/bin/bash
echo "App v1 - benign"
APP
chmod +x repo/app_v1.sh
sha256sum repo/app_v1.sh > repo/app_v1.sh.sha256
echo "Local release and checksum created in repo/"
