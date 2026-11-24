# A02:2025 - Security Misconfiguration

**Objetivo:** mostrar los riesgos de una configuración por defecto o descuidada en
**Apache**: listado de directorios, archivos de respaldo publicados, exposición de la
versión del software y ausencia de cabeceras HTTP de seguridad. Luego, endurecer la
configuración.

**Conceptos:** configuración segura por defecto, mínima exposición de información,
cabeceras de seguridad, revisión periódica de la configuración.

## Ejecución (dentro del contenedor)

1. Ir al directorio

    ```bash
    cd /lab/A02_Security_Misconfiguration
    ```

1. Configurar y arrancar Apache con la configuración **insegura**

    ```bash
    ./start_vulnerable.sh
    ```

1. Recorrer el sitio como un atacante: listado, respaldo con contraseñas, versión, TRACE

    ```bash
    ./exploit.sh
    ```

1. Aplicar la configuración endurecida

    ```bash
    ./apply_mitigation.sh
    ```

1. Volver a probar: sin listado (403), sin respaldo (403/404), versión oculta y cabeceras presentes

    ```bash
    ./exploit.sh
    ```

1. Detener Apache

    ```bash
    ./stop_server.sh
    ```

## Qué observar

* Comparar `/etc/apache2/conf-available/zz-lab-a02-inseguro.conf` con
  `/etc/apache2/conf-available/zz-lab-a02-hardening.conf`, y el sitio
  `/etc/apache2/sites-available/lab-a02.conf` antes y después de la mitigación.
* El orden importa: Apache aplica las directivas en el orden en que carga los archivos,
  y una sección `<Directory>` del sitio prevalece sobre la configuración global.
* La cabecera `Server:` pasa de mostrar versión y sistema operativo a solo `Apache`.
* Las mitigaciones se aplican en dos capas: la configuración bloquea los respaldos
  **y** además se eliminan del directorio publicado.

**Notas de seguridad:** ejecutar solo dentro del contenedor provisto para el laboratorio.
