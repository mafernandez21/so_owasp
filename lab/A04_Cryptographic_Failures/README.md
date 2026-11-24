# A04:2025 - Cryptographic Failures

**Objetivo:** mostrar tres fallas criptográficas frecuentes y su corrección:

1. contraseñas guardadas en texto plano;
2. contraseñas "protegidas" con un hash rápido y sin sal (MD5);
3. credenciales transmitidas sin cifrar (HTTP).

**Conceptos:** hash vs. cifrado, sal (*salt*), funciones de hash para contraseñas
(bcrypt, Argon2), cifrado en tránsito (TLS), principio de mínimo privilegio en archivos.

## Ejecución (dentro del contenedor)

1. Ir al directorio

    ```bash
    cd /lab/A04_Cryptographic_Failures
    ```

1. Crear la base con contraseñas en texto plano y mostrarla

    ```bash
    ./setup.sh
    ./demo_plain.sh
    ```

1. Ver por qué MD5 sin sal no alcanza (hashes repetidos y ataque de diccionario)

    ```bash
    ./demo_weak_hash.sh
    ```

1. Migrar a bcrypt, eliminar el texto plano y ver el resultado

    ```bash
    ./apply_mitigation.sh
    ./show_hashed.sh
    ```

1. Probar el inicio de sesión contra los hashes

    ```bash
    ./login.sh alice pass123
    ./login.sh alice incorrecta
    ```

1. Comparar una captura de tráfico HTTP con una HTTPS

    ```bash
    ./sniff_demo.sh
    ```

## Qué observar

* bcrypt incorpora una **sal** distinta por usuario y un **costo** que hace lento
  cada intento: el mismo diccionario que rompió MD5 en milisegundos se vuelve impráctico.
* `shred` sobrescribe el archivo antes de borrarlo; en discos SSD o sistemas con
  copias/respaldos no garantiza el borrado: la mejor práctica es no guardar nunca el texto plano.
* En la captura HTTP la contraseña se lee directamente; con TLS solo se ve tráfico cifrado.

**Notas de seguridad:** ejecutar solo dentro del contenedor provisto para el laboratorio.
