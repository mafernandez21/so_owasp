#!/bin/bash
set -e
cd "$(dirname "$0")"
cp repo/app_v1.sh /tmp/app.sh
sha256sum -c repo/app_v1.sh.sha256 || { echo 'Checksum mismatch - aborting'; exit 1; }
chmod +x /tmp/app.sh
echo "Checksum OK. Executing verified update:"
/tmp/app.sh
