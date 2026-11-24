# A01:2025 - Broken Access Control (IDOR)

**Objetivo:** mostrar una Referencia Directa Insegura a Objetos (IDOR): un usuario
**autenticado** accede a datos de otro usuario cambiando un identificador en la URL,
porque el servidor no verifica la **autorización**. Luego, aplicar la mitigación.

**Conceptos:** autenticación (quién sos) vs. autorización (qué podés hacer);
control de acceso del lado del servidor; denegar por defecto.

## Ejecución (dentro del contenedor)

1. Ir al directorio

    ```bash
    cd /lab/A01_Broken_Access_Control
    ```

1. Iniciar el servidor **vulnerable** (queda en segundo plano)

    ```bash
    ./start_server.sh
    ```

1. Explotar: Alice lee el documento de Bob (paso 2 devuelve HTTP 200)

    ```bash
    ./exploit.sh
    ```

1. Iniciar el servidor **mitigado** (reemplaza al anterior)

    ```bash
    ./start_server.sh --secure
    ```

1. Volver a probar: el paso 2 ahora devuelve HTTP 403

    ```bash
    ./exploit.sh
    ```

1. Detener el servidor

    ```bash
    ./stop_server.sh
    ```

## Qué observar

* El token prueba **quién** es Alice, pero no alcanza: en el modo vulnerable el
  servidor nunca compara el dueño del documento con el usuario del token.
* La corrección está en `server.py`, en la sección "2) Autorización": la decisión
  se toma **en el servidor**, nunca confiando en datos que envía el cliente.
* Ver el registro de pedidos en `server.log`.

**Notas de seguridad:** ejecutar solo dentro del contenedor provisto para el laboratorio.
