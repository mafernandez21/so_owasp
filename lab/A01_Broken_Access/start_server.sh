#!/bin/bash
# Inicia un simple servidor que sirve la carpeta 'www' en el puerto 8001
set -e
cd "$(dirname "$0")"
mkdir -p www
echo "User 1 secret" > www/user1.txt
echo "User 2 secret" > www/user2.txt
# server without any auth -> vulnerable by design for the lab
python3 -m http.server 8001 --directory www &
SERVER_PID=$!
echo "Server started (pid $SERVER_PID). Press Ctrl+C to stop."
wait $SERVER_PID
