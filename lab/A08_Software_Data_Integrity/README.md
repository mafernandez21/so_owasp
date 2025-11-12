# A08 - Software and Data Integrity Failures

**Objetivo:** Mostrar riesgos de ejecutar actualizaciones/descargas sin verificar firma/hashes.

**Ejecución (dentro del contenedor):**

1. Navegar al directorio

    ```bash
        cd /lab/A08_Software_Data_Integrity
    ```

1. Crear un 'release' local y su hash

    ```bash
        ./create_release.sh
    ```

1. Simula download + ejecución sin comprobar hash

    ```bash
        ./insecure_update.sh
    ```

1. Verifica sha256 antes de ejecutar

    ```bash
        ./secure_update.sh
    ```
