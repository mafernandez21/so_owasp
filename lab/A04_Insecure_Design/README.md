# A04 - Insecure Design

**Objetivo:** Demostrar consecuencias de un diseño que no separa roles ni valida flujos lógicos.

**Ejecución (dentro del contenedor):**

1. Navegar al directorio

    ```bash
        cd /lab/A04_Insecure_Design
    ```

1. Permitir editar /lab/system.conf sin controles

    ```bash
        ./vulnerable_edit.sh
    ```

1. Cambiar permisos y crear control de acceso por grupo

    ```bash
        ./apply_mitigation.sh
    ```

1. Comprobar el acceso

    ```bash
        ./access_check.sh
    ```
