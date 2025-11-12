# A03 - Injection

**Objetivo:** Mostrar una inyección por concatenación en bash y una inyección SQL simple en SQLite.

**Ejecución (dentro del contenedor):**

1. Navegar al directorio

    ```bash
        cd /lab/A03_Injection
    ```

1. Inicializar el entorno

    ```bash
        ./setup_db.sh
    ```

1. Demuestra inyección en script vulnerable

    ```bash
        ./exploit_bash.sh
    ```

1. Versión segura

    ```bash
        ./mitigate_bash.sh
    ```

1. Inyección SQL en consulta concatenada

    ```bash
        ./exploit_sql.sh
    ```

1. Uso de consulta parametrizada en python

```bash
    ./mitigate_sql.sh
```
