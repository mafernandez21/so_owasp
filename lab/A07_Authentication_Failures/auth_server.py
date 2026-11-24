#!/usr/bin/env python3
"""Servicio de inicio de sesión para el laboratorio A07 (puerto 8007).

Modo vulnerable (por defecto):
  - mensajes de error distintos para "usuario inexistente" y "contraseña incorrecta"
    (permite enumerar usuarios)
  - sin límite de intentos (permite fuerza bruta)
  - contraseñas guardadas en texto plano y una contraseña débil
Modo seguro (--secure):
  - mensaje genérico
  - bloqueo de la cuenta durante 60 s tras 5 intentos fallidos
  - contraseñas con bcrypt
  - registro de intentos fallidos en auth.log (apto para fail2ban)
"""
import json, sys, time
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs

import bcrypt

PORT = 8007
SECURE = "--secure" in sys.argv
MAX_FALLOS, BLOQUEO_SEG = 5, 60

USERS_PLAIN = {"admin": "dragon", "operador": "Op3r4d0r#2026!"}
USERS_HASH = {u: bcrypt.hashpw(p.encode(), bcrypt.gensalt()) for u, p in USERS_PLAIN.items()}
fallos = {}  # usuario -> [cantidad, instante_del_bloqueo]


def registrar(msg):
    with open("auth.log", "a") as f:
        f.write(time.strftime("%Y-%m-%d %H:%M:%S ") + msg + "\n")


def login_vulnerable(user, pw):
    if user not in USERS_PLAIN:
        return 401, "El usuario no existe"
    if USERS_PLAIN[user] != pw:
        return 401, "Contraseña incorrecta"
    return 200, f"Bienvenido, {user}"


def login_seguro(user, pw, ip):
    cant, desde = fallos.get(user, [0, 0.0])
    if cant >= MAX_FALLOS and time.time() - desde < BLOQUEO_SEG:
        registrar(f"BLOQUEADO usuario={user} ip={ip}")
        return 429, "Demasiados intentos. Intente más tarde."
    # Se calcula bcrypt también para usuarios inexistentes: así el tiempo de
    # respuesta no revela si el usuario existe.
    h = USERS_HASH.get(user, USERS_HASH["admin"])
    ok = bcrypt.checkpw(pw.encode(), h) and user in USERS_HASH
    if ok:
        fallos.pop(user, None)
        return 200, f"Bienvenido, {user}"
    cant = 0 if cant >= MAX_FALLOS else cant
    fallos[user] = [cant + 1, time.time()]
    registrar(f"FALLO usuario={user} ip={ip}")
    return 401, "Usuario o contraseña incorrectos"


class H(BaseHTTPRequestHandler):
    def do_POST(self):
        data = parse_qs(self.rfile.read(int(self.headers.get("Content-Length", 0))).decode())
        user, pw = data.get("usuario", [""])[0], data.get("clave", [""])[0]
        ip = self.client_address[0]
        code, msg = login_seguro(user, pw, ip) if SECURE else login_vulnerable(user, pw)
        body = json.dumps({"mensaje": msg}, ensure_ascii=False).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *a):
        pass


if __name__ == "__main__":
    print(f"Servicio de login en http://127.0.0.1:{PORT}/login - modo {'SEGURO' if SECURE else 'VULNERABLE'}", flush=True)
    HTTPServer(("0.0.0.0", PORT), H).serve_forever()
