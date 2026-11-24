#!/bin/bash
# ./start_server.sh            -> modo vulnerable
# ./start_server.sh --secure   -> modo mitigado
set -euo pipefail
cd "$(dirname "$0")"
./stop_server.sh >/dev/null 2>&1 || true
rm -f auth.log
python3 auth_server.py "$@" > server.log 2>&1 &
echo $! > server.pid
sleep 1
head -n 1 server.log
