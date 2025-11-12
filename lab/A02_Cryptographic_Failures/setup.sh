#!/bin/bash
cd "$(dirname "$0")"
mkdir -p data
cat > data/users.csv <<'CSV'
username,password
alice,pass123
bob,secret
CSV
echo "Setup complete: data/users.csv created."