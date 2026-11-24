# A06:2025 - Insecure Design

**Objetivo:** mostrar que un sistema **diseñado** sin separación de roles es inseguro
aunque el código no tenga errores, y rediseñarlo aplicando mínimo privilegio con los
mecanismos del sistema operativo (usuarios, grupos y permisos).

**Conceptos:** *security by design*, modelado de amenazas, separación de privilegios,
mínimo privilegio, permisos UNIX (propietario, grupo, otros).

## Ejecución (dentro del contenedor, como root)

1. Ir al directorio

    ```bash
    cd /lab/A06_Insecure_Design
    ```

1. Instalar el sistema de notas con el diseño inseguro y probar cada rol

    ```bash
    ./setup_insecure.sh
    ./demo.sh
    ```

    El alumno puede cambiar su nota y nombrarse administrador.

1. Aplicar el rediseño por roles y repetir las mismas pruebas

    ```bash
    ./apply_mitigation.sh
    ./demo.sh
    ```

    Ahora el alumno no tiene acceso, el docente carga notas pero no cambia la configuración.

1. Consultar el rol de cada usuario

    ```bash
    ./check_role.sh
    su docente -c ./check_role.sh
    su alumno -c ./check_role.sh
    ```

## Qué observar

* El problema no es un error de programación: es una **decisión de diseño** (un único
  rol con acceso total). Por eso no se corrige con un "parche", sino rediseñando.
* La protección la aplica el **sistema operativo** (permisos), no un script que el
  usuario podría saltear.
* Para pensar: ¿cómo consultaría un alumno **solo su propia nota**? (pista: un
  programa intermediario con privilegios acotados, o una base de datos con control de acceso por fila).

**Notas de seguridad:** ejecutar solo dentro del contenedor provisto para el laboratorio.
