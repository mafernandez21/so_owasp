# OWASP Lab Repository (solved exercises)

Contenido: carpetas por tema (A01, A02, A03, A04, A05, A08) con ejercicios resueltos y scripts para correr
dentro de un contenedor Docker provisto.

**Instrucciones rápidas:**

1. Construir imagen Docker (desde el directorio root en el repo):

```bash
   docker build -t owasp_lab_image .
```

1. Ejecutar contenedor interactivo y montar /lab como /lab en el container:

```bash
   docker run --rm -it -v $(pwd)/lab:/lab owasp_lab_image /bin/bash
```

>**NOTA: Si necesita exponer el puerto utilizar el flag `-p<puerto local>:puerto en contenedor`. Si utiliza dos o más instancias del mismo contenedor, recuerde que sólo la primera instancia puede abrir el puerto local seleccionado.**

1. Dentro del contenedor, navegar a `/lab/<TEMA>` y seguir los README de cada carpeta.

>**Advertencia: Todas las vulnerabilidades están intencionalmente activadas para fines educativos. Ejecutar sólo en entornos de laboratorio (contenedores o máquinas virtuales aisladas).**
