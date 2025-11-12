#!/bin/bash
set -e
cd "$(dirname "$0")"
echo "Contenido en claro de users.csv:"
cat data/users.csv || true