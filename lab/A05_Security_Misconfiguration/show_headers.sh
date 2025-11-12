#!/bin/bash
PORT=${1:-8003}
curl -I http://127.0.0.1:${PORT}/ || echo 'No server?'
