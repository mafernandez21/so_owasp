# A07:2025 - Authentication Failures

**Objetivo:** mostrar un ataque de **enumeración de usuarios** seguido de **fuerza
bruta** contra un servicio de inicio de sesión sin protecciones, y mitigarlo.

**Conceptos:** autenticación, contraseñas débiles, enumeración de cuentas, limitación
de intentos y bloqueo, almacenamiento seguro de contraseñas, registro de eventos de
seguridad, fail2ban.

## Ejecución (dentro del contenedor)

1. Ir al directorio

    ```bash
    cd /lab/A07_Authentication_Failures
    ```

1. Iniciar el servicio **vulnerable** y atacarlo

    ```bash
    ./start_server.sh
    python3 attack.py
    ```

    Los mensajes de error revelan qué usuarios existen y la contraseña de `admin`
    aparece en el diccionario.

1. Iniciar el servicio **mitigado** y repetir el ataque

    ```bash
    ./start_server.sh --secure
    python3 attack.py
    cat auth.log
    ```

    No se puede saber qué usuarios existen y cada cuenta se bloquea tras 5 intentos.

1. Detener el servicio

    ```bash
    ./stop_server.sh
    ```

## Qué observar

* Un mensaje genérico ("Usuario o contraseña incorrectos") y un tiempo de respuesta
  similar impiden distinguir usuarios existentes.
* El bloqueo hace inviable recorrer un diccionario; en un sistema real se combina con
  autenticación multifactor (MFA) y con políticas de contraseñas (NIST SP 800-63B).
* `auth.log` registra cada intento fallido con la IP de origen. Con ese registro,
  **fail2ban** puede bloquear la IP a nivel del firewall del sistema operativo: ver
  los archivos de ejemplo en `fail2ban/`. En el contenedor no se ejecuta porque
  necesita privilegios de red (`--cap-add=NET_ADMIN`); queda como extensión.
* El mismo principio se aplica en Linux al inicio de sesión local con el módulo PAM
  `pam_faillock`.

**Notas de seguridad:** ejecutar solo dentro del contenedor provisto para el laboratorio.
