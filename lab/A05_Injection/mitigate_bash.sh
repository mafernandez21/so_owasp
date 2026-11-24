#!/bin/bash
cd "$(dirname "$0")"
for entrada in 'app.log' 'app.log; id; head -n 3 /etc/passwd' '../../../etc/hostname' '$(id)'; do
    echo "Entrada: $entrada"
    ./safe_viewer.sh "$entrada" || true
    echo
done
