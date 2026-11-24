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

## Bloqueo de intentos en el sistema operativo (PAM)

El mismo ataque de fuerza bruta se aplica al inicio de sesión local de Linux. Aquí se
ataca `su alumno` y se mitiga con el módulo PAM `pam_faillock`, que bloquea la cuenta
tras varios intentos fallidos. **Ejecutar como `root` dentro del contenedor.**

1. Modo **vulnerable** (sin límite de intentos) y ataque desde otra cuenta

    ```bash
    ./pam_setup.sh
    su docente -c "python3 pam_attack.py"
    ```

    El diccionario termina encontrando la contraseña débil de `alumno` (`sunshine`).

1. Modo **mitigado** con `pam_faillock` y repetición del ataque

    ```bash
    ./pam_setup.sh --secure
    su docente -c "python3 pam_attack.py"
    faillock --user alumno
    ```

    La cuenta se bloquea tras 3 intentos fallidos y el ataque se detiene. Con
    `faillock --user alumno` se ve el registro de fallos; incluso la contraseña
    correcta queda rechazada ("The account is locked...") hasta que pasa el
    `unlock_time` o se ejecuta `faillock --user alumno --reset`.

1. Restaurar la configuración original de `su`

    ```bash
    ./pam_setup.sh
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
  `pam_faillock` (ver la sección *Bloqueo de intentos en el sistema operativo*).

**Notas de seguridad:** ejecutar solo dentro del contenedor provisto para el laboratorio.
