# A03:2025 - Software Supply Chain Failures

**Objetivo:** mostrar cómo un repositorio de paquetes (mirror) comprometido permite
distribuir código malicioso a quien instala sin verificar, y cómo lo evitan la
**fijación de hashes** (*pinning*) y la **firma digital** del publicador.

**Conceptos:** integridad y procedencia del software, hash criptográfico, firma GPG,
canal confiable para distribuir claves, archivos de bloqueo (*lockfiles*).

## Ejecución (dentro del contenedor)

1. Ir al directorio

    ```bash
    cd /lab/A03_Software_Supply_Chain_Failures
    ```

1. El publicador crea y firma la versión 1.0; el consumidor fija su hash

    ```bash
    ./publish_release.sh
    ./start_mirror.sh
    ```

1. Instalación con el paquete legítimo (ambos métodos funcionan)

    ```bash
    ./install_insecure.sh
    ./install_secure.sh
    ```

1. El atacante compromete el mirror

    ```bash
    ./attack_mirror.sh
    ```

1. Instalación insegura: el "control" de hash pasa y se ejecuta el código del atacante

    ```bash
    ./install_insecure.sh
    cat /tmp/COMPROMETIDO.txt
    ```

1. Instalación segura: se rechaza el paquete

    ```bash
    ./install_secure.sh
    ```

1. Limpiar

    ```bash
    ./reset.sh
    ```

## Qué observar

* Un hash descargado del **mismo** lugar que el archivo no protege: si el atacante
  controla el mirror, cambia ambos.
* El hash de `requirements.lock` lo guarda el consumidor; la clave pública del
  publicador se obtiene por otro canal. El atacante no puede falsificar ninguno.
* La verificación se hace sobre el **mismo archivo** que después se ejecuta.
* Equivalentes en herramientas reales: `pip install --require-hashes`,
  `package-lock.json` / `npm ci`, firmas de paquetes `apt`, Sigstore.

**Notas de seguridad:** la carga útil del "atacante" solo crea `/tmp/COMPROMETIDO.txt`.
Ejecutar solo dentro del contenedor provisto para el laboratorio.
