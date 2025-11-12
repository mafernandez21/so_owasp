# A01 - Broken Access Control (IDOR)

**Objetivo:** Mostrar un caso sencillo de acceso directo a recursos (IDOR) y cómo mitigarlo.

**Ejecución (dentro del contenedor):**

1. Navegar al directorio

    ```bash
        cd /lab/A01_Broken_Access
    ```

1. Lanzar servidor HTTP simple que sirve archivos de usuarios

    ```bash
        ./start_server.sh 
    ```

1. En otra terminal dentro de la misma instancia, mostrar acceso a user2.txt sin autenticación

    ```bash
        ./exploit.sh 
    ```

1. Aplica control simple y cambia permisos

    ```bash
        ./mitigate.sh
    ```

1. Volver a probar

    ```bash
        ./exploit.sh
    ```

**Notas de seguridad:** Ejecutar solo dentro del contenedor provisto para laboratorio.
