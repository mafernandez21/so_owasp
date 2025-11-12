#!/bin/bash
# Mitigation: restrict file permissions and create a minimal token-based check script
set -e
cd "$(dirname "$0")"
# make files readable only by owner
chmod 600 www/user1.txt www/user2.txt || true
# create a tiny "protected" server script using Python that enforces a token
cat > protected_server.py <<'PY'
#!/usr/bin/env python3
from http.server import SimpleHTTPRequestHandler, HTTPServer
import urllib.parse, os
TOKEN='secrettoken'
class H(SimpleHTTPRequestHandler):
    def do_GET(self):
        qs = urllib.parse.urlparse(self.path).query
        params = urllib.parse.parse_qs(qs)
        if params.get('token', [''])[0] != TOKEN:
            self.send_response(403)
            self.end_headers()
            self.wfile.write(b'Forbidden - missing token')
            return
        # strip query before serving
        self.path = urllib.parse.urlparse(self.path).path
        return SimpleHTTPRequestHandler.do_GET(self)

if __name__=='__main__':
    os.chdir('www')
    HTTPServer(('0.0.0.0', 8001), H).serve_forever()
PY
chmod +x protected_server.py
echo "Mitigation applied. Start protected server: python3 protected_server.py"