#!/bin/bash
# depura los archivos de respaldo (descubrimiento) mayores a 2 dias
find /home/implementacion/scripts-sh/out/descubrimiento_* -mtime +2 -exec rm {} \;