#!/bin/bash
set -e
cd "$(dirname "$0")"
mkdir -p www
echo "index not present, file listing will be shown" > www/readme.txt
python3 -m http.server 8003 --directory www &
PID=$!
echo "Server started (PID $PID)"
