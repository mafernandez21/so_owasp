# A10:2025 - Mishandling of Exceptional Conditions

**Objetivo:** mostrar dos consecuencias de manejar mal los errores y situaciones
inesperadas, y corregirlas:

1. un control de acceso que **falla abierto** (*fail open*): cuando falta su archivo
   de configuración, deja pasar a todos;
2. un servicio que quedó en **modo depuración** y, ante una excepción, **expone su traza
   interna** con los valores de las variables, credenciales incluidas.

**Conceptos:** códigos de salida de los procesos, *fail open* vs. *fail closed*
("fail securely"), `set -euo pipefail` y `trap` en Bash, manejo de excepciones,
mensajes de error genéricos y registro del detalle del lado del servidor.

## Ejecución (dentro del contenedor)

1. Ir al directorio

    ```bash
    cd /lab/A10_Mishandling_of_Exceptional_Conditions
    ```

1. Control de acceso: comparar ambas versiones con y sin archivo de configuración

    ```bash
    ./demo_acceso.sh
    ```

    Sin la lista de autorizados, la versión vulnerable concede el acceso a `alumno`.

1. Servicio de reportes **vulnerable**: los errores devuelven la traza completa

    ```bash
    ./start_server.sh
    ./demo_errores.sh
    ```

1. Servicio de reportes **mitigado**: validación de la entrada y mensaje genérico

    ```bash
    ./start_server.sh --secure
    ./demo_errores.sh
    cat server_errors.log
    ./stop_server.sh
    ```

## Qué observar

* `grep` distingue "no encontrado" (código 1) de "error" (código 2). Tratar todo lo
  que no sea 1 como éxito convierte un error en un permiso. La versión segura solo
  concede ante un éxito explícito (código 0) y niega ante cualquier otra situación.
* La traza expone la cadena de conexión con usuario y contraseña de la base de datos,
  nombres de funciones y rutas internas: información valiosa para un atacante.
* La versión segura devuelve un identificador de incidente que permite al personal
  técnico encontrar el detalle en `server_errors.log` sin mostrárselo al cliente.

**Notas de seguridad:** ejecutar solo dentro del contenedor provisto para el laboratorio.
