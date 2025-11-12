# A05 - Security Misconfiguration

**Objetivo:** Mostrar directorio listado por configuración por defecto y la ausencia de cabeceras HTTP de seguridad.

**Ejecución (dentro del contenedor):**

1. Navegar al directorio

    ```bash
        cd /lab/A05_Security_Misconfiguration
    ```

1. Lanza python http.server que ofrece listado de directorio

    ```bash
        ./start_server.sh
    ```

1. Muestra las cabeceras recibidas con curl

    ```bash
        ./show_headers.sh
    ```

1. Lanza un pequeño servidor que añade cabeceras de seguridad

    ```bash
        ./apply_mitigation.sh
    ```
