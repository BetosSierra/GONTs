#!/bin/sh  
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

rutain="/home/implementacion/operaciones/"
rutaout="/home/implementacion/operaciones/out/"
dtarch=`date +%Y%m%d%H%M%S`

find $rutaout -type f -name "config_onts_x_metrics_*.csv" -mtime +7 -exec rm -f {} \;
arch="config_onts_x_metrics_$dtarch.csv"
touch $rutaout$arch 
chmod 777 $rutaout$arch

echo "Id_registry|origin|num_serial|name_metric|status|usr_registry|date_registry_ont|usr_reactivate|date_reactivate_ont|usr_disabled|date_disabled_ont|message" >> $rutaout$arch

sql="select Concat(ifNull(Id_registry, ''),'|',ifNull(origin, ''),'|', ifNull(num_serial, ''),'|', ifNull(name_metric, ''),'|', ifNull(status, ''),'|', ifNull(usr_registry, ''),'|', ifNull(date_registry_ont, ''),'|', ifNull(usr_reactivate, ''),'|', ifNull(date_reactivate_ont, ''),'|', ifNull(usr_disabled, ''),'|', ifNull(date_disabled_ont, ''),'|', ifNull(message, '')) from config_metrics_ont_monitoring"

$MA_CONEXION --skip-column-names -e "$sql" >> $rutaout$arch
echo
msgOut="Se genero el archivo en la ruta "$rutaout" con el nombre "$arch
echo -e "\e[1;94m$msgOut\e[0m"
echo
