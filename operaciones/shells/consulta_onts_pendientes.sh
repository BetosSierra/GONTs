#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"
cd /home/implementacion/operaciones/out/
f=`date +%Y%m%d%H%M%S`
mv consulta_onts.csv consulta_onts_$f".csv"
touch consulta_onts.csv
enca="Ip_Olt|Num_Serie|Id_Cliente|Nombre_Cliente|Vertical|fecha_registro|Existe_olt"
echo $enca >> consulta_onts.csv
mysql --skip-column-names -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD </home/implementacion/operaciones/sql/onts_pendientes.sql >> consulta_onts.csv