#!/usr/bin/env python3
"""Servidor de inicio de sesión mínimo. Sin argumentos usa HTTP (puerto 8004);
con --tls usa HTTPS con el certificado de ./certs (puerto 8443)."""
import ssl, sys
from http.server import BaseHTTPRequestHandler, HTTPServer

class H(BaseHTTPRequestHandler):
    def do_POST(self):
        self.rfile.read(int(self.headers.get("Content-Length", 0)))
        self.send_response(200); self.end_headers(); self.wfile.write(b"ok\n")
    def log_message(self, *a): pass

tls = "--tls" in sys.argv
srv = HTTPServer(("127.0.0.1", 8443 if tls else 8004), H)
if tls:
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ctx.load_cert_chain("certs/server.crt", "certs/server.key")
    srv.socket = ctx.wrap_socket(srv.socket, server_side=True)
srv.serve_forever()
