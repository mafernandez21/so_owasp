# A05:2025 - Injection

**Objetivo:** mostrar dos inyecciones: de **comandos del sistema operativo** en un
script Bash y de **SQL** en una consulta a SQLite, y corregir ambas.

**Conceptos:** mezcla de datos con código, intérprete de comandos, consultas
parametrizadas, validación por lista blanca, recorrido de directorios (*path traversal*).

## Ejecución (dentro del contenedor)

1. Ir al directorio y preparar el entorno (se puede repetir sin errores)

    ```bash
    cd /lab/A05_Injection
    ./setup.sh
    ```

1. Inyección de comandos: el visor ejecuta `id` y lee `/etc/passwd`

    ```bash
    ./exploit_bash.sh
    ```

    También se puede probar a mano: `./vuln_viewer.sh` y escribir `app.log; whoami`

1. Visor corregido con las mismas entradas: todas se rechazan salvo la legítima

    ```bash
    ./mitigate_bash.sh
    ```

1. Inyección SQL: `' OR '1'='1` devuelve todos los usuarios

    ```bash
    ./exploit_sql.sh
    ```

1. Consulta parametrizada: la misma entrada no devuelve resultados

    ```bash
    ./mitigate_sql.sh
    ./mitigate_sql.sh alice
    ```

## Qué observar

* En `vuln_viewer.sh` el problema es `bash -c "cat logs/$FILE"`: el texto del
  usuario pasa a formar parte de un comando que interpreta el shell (`;`, `$( )`, `|`).
* La corrección no "limpia" caracteres peligrosos: define qué es válido (lista blanca),
  controla la ruta final y evita usar un intérprete.
* En `mitigate_sql.sh` el dato viaja separado de la consulta (`?`) y también separado
  del código Python (`sys.argv`).

**Notas de seguridad:** ejecutar solo dentro del contenedor provisto para el laboratorio.
