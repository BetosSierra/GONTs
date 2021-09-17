#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"
cd /home/implementacion/operaciones/out/
f=`date +%Y%m%d%H%M%S`
mv consulta_sdwan.csv consulta_sdwan_$f".csv"
touch consulta_sdwan.csv
enca="FOLIO|ID_CLIENTE|CLIENTE|MH_DISPOSITIVO|TIPO_DISPOSITIVO|MAC_ADDRESS|IP_NETWORK|IP_OLT|NUMERO_SERIE|FECHA_ALTA_D|FECHA_ALTA|username|HOST_NAME|COMUNIDAD_SNMP|VERSION_SNMP|ALIAS|NUM_CUENTA_CLIENTE|NUM_CUENTA_SITIO|SEGMENTO_FACTURACION|NOMBRE_SITIO|MENSAJE_CMDB|MENSAJE_SPECTRUM|STATUS_ZABBIX_STORED|MENSAJE_ZABBIX_STORED|STATUS_CMDB|STATUS_SPECTRUM|STATUS_ZABBIX|STATUS_ZABBIX_STORED|STATUS_SNMP|ORIGEN|ACTIVO|SDWAN"
echo $enca >> consulta_sdwan.csv
mysql --skip-column-names -h $PDM_IP -P $PDM_PUERTO -u $PDM_USUARIO -p$PDM_CONTRASENA $PDM_BD </home/implementacion/operaciones/sql/consulta_sdwan.sql >> consulta_sdwan.csv