#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

if [ -z "$1" ]; 
   then
   echo "El numero de serie de la ONT NO puede ser nula, No se realiza ninguna accion"
else
  echo ""
  echo "********* INICA ACTUALIZACION DE LA OLT "$1" *************************"
  echo ""  
  sqlup=" update monitor_control_onts mon join (select Ip_Olt, Num_Serie, ObjectId, OntId, frame, slot, port from v_inventario_monitoreo where Num_Serie = '"$1"') des on mon.num_serie = des.num_serie set mon.ip_olt = des.ip_olt, mon.ObjectId = des.ObjectId, mon.OntId = des.OntId, mon.frame = des.Frame, mon.slot = des.Slot, mon.port = des.port"
  echo $sqlup | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;
  echo ""
  echo "********* Se actualizo la ONT *************************"   
  echo ""
  echo "********* TERMINA ACTUALIZACION DE LA OLT "$1" *************************"  
fi