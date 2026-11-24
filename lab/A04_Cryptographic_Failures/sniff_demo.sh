#!/bin/bash
# Captura el tráfico de un inicio de sesión con tcpdump, primero por HTTP y luego por HTTPS.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p certs
[ -f certs/server.crt ] || openssl req -x509 -newkey rsa:2048 -nodes -days 30 \
    -keyout certs/server.key -out certs/server.crt -subj "/CN=localhost" 2>/dev/null

capturar() {  # $1 = puerto, $2 = URL
    timeout 4 tcpdump -i lo -s0 -w captura.pcap "tcp port $1" 2>/dev/null &
    local tcpdump_pid=$!
    sleep 1
    curl -sk -o /dev/null -d "usuario=alice&clave=pass123" "$2"
    wait "$tcpdump_pid" || true
    tcpdump -r captura.pcap -A 2>/dev/null | grep -a -o "usuario=[^ ]*" || echo "   (no se ve ninguna contraseña en la captura)"
    rm -f captura.pcap
}

python3 login_server.py & P1=$!
python3 login_server.py --tls & P2=$!
sleep 1
echo "1) Login por HTTP (puerto 8004). Lo que ve alguien que escucha la red:"
capturar 8004 http://127.0.0.1:8004/login
echo
echo "2) Login por HTTPS (puerto 8443). Lo que ve alguien que escucha la red:"
capturar 8443 https://127.0.0.1:8443/login
kill $P1 $P2 2>/dev/null || true
