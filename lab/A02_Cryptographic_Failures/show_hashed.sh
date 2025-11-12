#!/bin/bash
set -e
cd "$(dirname "$0")"
cat data/users_hashed.csv || true
