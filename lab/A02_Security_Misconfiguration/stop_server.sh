#!/bin/bash
apache2ctl stop 2>/dev/null && echo "Apache detenido." || echo "Apache no estaba en ejecución."
