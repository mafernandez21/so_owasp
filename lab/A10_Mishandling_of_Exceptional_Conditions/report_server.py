#!/usr/bin/env python3
"""Servicio de reportes (puerto 8010). GET /reporte?alumnos=N calcula un promedio.

Modo vulnerable (por defecto): quedó activado el "modo depuración" en producción.
Ante una excepción devuelve al cliente la traza completa (stack trace) con los
valores de las variables locales, que exponen código interno, rutas y credenciales.
Modo seguro (--secure): valida la entrada, responde un mensaje genérico con un
identificador de incidente y guarda el detalle solo en el registro del servidor.
"""
import json, sys, traceback, uuid
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs, urlparse

PORT = 8010
SECURE = "--secure" in sys.argv


def conectar(dsn):
    return {"dsn": dsn}  # simula una conexión a la base de datos


def generar_reporte(params):
    conexion = conectar("postgresql://admin:S3cret0_Notas@10.0.0.5:5432/notas")
    total_notas = 70
    alumnos = int(params.get("alumnos", ["0"])[0])
    return {"promedio": total_notas / alumnos, "fuente": "notas"}


class H(BaseHTTPRequestHandler):
    def reply(self, code, payload, ctype="application/json; charset=utf-8"):
        body = payload if isinstance(payload, bytes) else json.dumps(payload, ensure_ascii=False).encode()
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        params = parse_qs(urlparse(self.path).query)
        if SECURE:
            valor = params.get("alumnos", [""])[0]
            # Validación de la entrada: se rechazan valores no numéricos antes de procesar.
            if not valor.isdigit():
                return self.reply(400, {"error": "El parámetro 'alumnos' debe ser un número entero"})
        try:
            return self.reply(200, generar_reporte(params))
        except Exception:
            if not SECURE:
                exc = sys.exc_info()[1]
                detalle = "".join(traceback.TracebackException.from_exception(exc, capture_locals=True).format())
                return self.reply(500, detalle.encode(), "text/plain; charset=utf-8")
            incidente = uuid.uuid4().hex[:8]
            with open("server_errors.log", "a") as f:
                f.write(f"[incidente {incidente}]\n{traceback.format_exc()}\n")
            return self.reply(500, {"error": "Error interno", "incidente": incidente})

    def log_message(self, *a):
        pass


if __name__ == "__main__":
    print(f"Servicio de reportes en http://127.0.0.1:{PORT}/reporte - modo {'SEGURO' if SECURE else 'VULNERABLE'}", flush=True)
    HTTPServer(("0.0.0.0", PORT), H).serve_forever()
