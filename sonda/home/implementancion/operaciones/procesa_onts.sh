#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

mysql --skip-column-names -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD </home/implementacion/operaciones/sql/registra_onts.sql

arr=$(mysql --skip-column-names -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD </home/implementacion/operaciones/sql/onts_pendientes_registro.sql)
IFS=$'\n'
for val in $arr;
  do
    t=$t"'"$val"',"
done
IFS=$Field_Separator
pos=$(echo ${#t})
aux=$(echo ${t:0:$pos-1})
if [ $pos -gt 3 ]; then
   # actualiza Onts en PDM */
   dispo="update tb_dispositivos set MENSAJE_ZABBIX = 'Se integro a Monitoreo', status_Zabbix = '1' where TIPO_DISPOSITIVO = 20 and NUMERO_SERIE in ("$aux")"
   echo $dispo | mysql -h $PDM_IP -P $PDM_PUERTO -u $PDM_USUARIO -p$PDM_CONTRASENA $PDM_BD;
fi
# actualiza Onts en Gestor */
mysql --skip-column-names -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD </home/implementacion/operaciones/sql/actualiza_onts.sql

