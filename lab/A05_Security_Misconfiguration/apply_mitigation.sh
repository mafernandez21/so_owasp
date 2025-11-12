#!/bin/bash
# Mitigation: simple server that adds secure headers
cd "$(dirname "$0")"
cat > secure_server.py <<'PY'
from http.server import SimpleHTTPRequestHandler, HTTPServer
class H(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('X-Frame-Options','DENY')
        self.send_header('X-Content-Type-Options','nosniff')
        self.send_header('Content-Security-Policy',"default-src 'self'")
        SimpleHTTPRequestHandler.end_headers(self)
if __name__=='__main__':
    HTTPServer(('0.0.0.0',8004), H).serve_forever()
PY
chmod +x secure_server.py
echo "Run: python3 secure_server.py (serves current dir with security headers)"
