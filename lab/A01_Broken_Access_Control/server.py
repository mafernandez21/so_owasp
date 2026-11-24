#!/usr/bin/env python3
"""Servicio de documentos de usuarios para el laboratorio A01 (IDOR).

Modo vulnerable (por defecto): exige un token (autenticación) pero NO controla
que el documento pedido pertenezca al usuario del token (falta autorización).
Modo seguro (--secure): además verifica que el usuario sea el dueño del documento.
"""
import json
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse

PORT = 8001
SECURE = "--secure" in sys.argv

# Tokens de sesión -> usuario autenticado
TOKENS = {"token-alice-7f3a": "alice", "token-bob-91c2": "bob"}

# Documentos: id -> (dueño, contenido)
DOCS = {
    "1": ("alice", "Resumen médico de alice: alergia a la penicilina"),
    "2": ("bob", "Recibo de sueldo de bob: $ 1.250.000"),
}


class Handler(BaseHTTPRequestHandler):
    def reply(self, code, payload):
        body = json.dumps(payload, ensure_ascii=False).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        path = urlparse(self.path).path
        # 1) Autenticación: ¿quién hace el pedido?
        auth = self.headers.get("Authorization", "")
        user = TOKENS.get(auth.removeprefix("Bearer "))
        if user is None:
            return self.reply(401, {"error": "no autenticado"})

        if not path.startswith("/documentos/"):
            return self.reply(404, {"error": "no encontrado"})
        doc_id = path.rsplit("/", 1)[-1]
        if doc_id not in DOCS:
            return self.reply(404, {"error": "no encontrado"})
        owner, content = DOCS[doc_id]

        # 2) Autorización: ¿el usuario puede ver ESTE documento?
        if SECURE and owner != user:
            return self.reply(403, {"error": "acceso denegado"})

        return self.reply(200, {"id": doc_id, "dueño": owner, "contenido": content})

    def log_message(self, fmt, *args):
        sys.stderr.write("[servidor] " + fmt % args + "\n")


if __name__ == "__main__":
    mode = "SEGURO (con control de autorización)" if SECURE else "VULNERABLE (sin control de autorización)"
    print(f"Servidor en http://127.0.0.1:{PORT} - modo {mode}", flush=True)
    HTTPServer(("0.0.0.0", PORT), Handler).serve_forever()
