#!/bin/bash
cd "$(dirname "$0")"
ls -l data/users_hashed.csv
cat data/users_hashed.csv
echo
echo "-> alice y carol tienen la misma contraseña, pero hashes distintos (sal aleatoria)."
