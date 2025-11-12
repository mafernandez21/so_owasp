# A02 - Cryptographic Failures

**Objetivo:** Ver la diferencia entre contraseñas en texto plano y contraseñas hashed, y observar tráfico no cifrado.

**Ejecución (dentro del contenedor):**

1. Navegar al directorio

    ```bash
        cd /lab/A02_Cryptographic_Failures
    ```

1. Inicializar el entorno

    ```bash
        ./setup.sh
    ```

1. Muestra el archivo con contraseñas en texto plano

    ```bash
        ./demo_plain.sh
    ```

1. Hash de contraseñas con bcrypt via python

    ```bash
        ./apply_mitigation.sh
    ```

1. Mostrar los hashes

    ```bash
        ./show_hashed.sh
    ```
