# Laboratorio OWASP Top 10:2025 - Sistemas Operativos (FACET - UNT)

Ejercicios resueltos para el trabajo grupal sobre el
[OWASP Top 10:2025](https://top10.owasp.org/2025/). Cada carpeta de `lab/` contiene
un escenario vulnerable, su explotación y su mitigación, con scripts para ejecutar
dentro del contenedor Docker provisto.

> **Para el trabajo grupal:** estos laboratorios son un **punto de partida**. En la
> demostración práctica cada grupo debe aportar algo propio (una variante del ataque,
> otra mitigación o evidencia del antes y el después), según lo indicado en las consignas.

| Carpeta | Categoría OWASP Top 10:2025 | Demostración |
| --- | --- | --- |
| `A01_Broken_Access_Control` | A01 Broken Access Control | IDOR: un usuario autenticado lee documentos de otro |
| `A02_Security_Misconfiguration` | A02 Security Misconfiguration | Apache con listado de directorios, respaldos expuestos y sin cabeceras de seguridad |
| `A03_Software_Supply_Chain_Failures` | A03 Software Supply Chain Failures | Mirror de paquetes comprometido; verificación con hash fijado y firma GPG |
| `A04_Cryptographic_Failures` | A04 Cryptographic Failures | Contraseñas en texto plano y MD5; bcrypt; captura de tráfico HTTP vs. HTTPS |
| `A05_Injection` | A05 Injection | Inyección de comandos en Bash e inyección SQL |
| `A06_Insecure_Design` | A06 Insecure Design | Sistema sin separación de roles; rediseño con usuarios, grupos y permisos |
| `A07_Authentication_Failures` | A07 Authentication Failures | Enumeración de usuarios y fuerza bruta; bloqueo de intentos en la aplicación y en el sistema operativo (`pam_faillock`) |
| `A10_Mishandling_of_Exceptional_Conditions` | A10 Mishandling of Exceptional Conditions | Control de acceso que falla abierto y trazas de error expuestas |

## Instrucciones rápidas

1. Construir la imagen (desde la raíz del repositorio):

    ```bash
    docker build -t owasp_lab_image .
    ```

1. Ejecutar un contenedor interactivo con nombre:

    ```bash
    docker run --rm -it --name owasp_lab owasp_lab_image
    ```

1. Dentro del contenedor, ir a `/lab/<CARPETA>` y seguir el `README.md` de esa carpeta.

1. Si se necesita una segunda terminal en el **mismo** contenedor, desde otra terminal del equipo:

    ```bash
    docker exec -it owasp_lab bash
    ```

    Los servidores de los laboratorios se inician en segundo plano (`start_server.sh`,
    `stop_server.sh`), por lo que en general alcanza con una sola terminal.

> **NOTA:** los servicios escuchan en los puertos 8001 a 8010 **dentro** del contenedor.
> Para abrirlos desde el navegador del equipo, agregar `-p <puerto local>:<puerto>`
> al `docker run`, por ejemplo `-p 8002:8002`.
>
> **NOTA:** la imagen ya contiene una copia de `lab/`. Montar la carpeta con
> `-v "$(pwd)/lab:/lab"` permite editar los scripts desde el equipo, pero los archivos
> que generan los ejercicios quedarán en el repositorio con dueño `root`.

## Usuarios del contenedor

Los ejercicios se ejecutan como `root`, pero la imagen incluye los usuarios sin
privilegios `alumno` y `docente`, que se usan en A06, A07 y A10 para mostrar controles
basados en permisos (por ejemplo, `su alumno -c "comando"`).

>**Advertencia: todas las vulnerabilidades están intencionalmente activadas para fines educativos. Ejecutar sólo en entornos de laboratorio (contenedores o máquinas virtuales aisladas).**
