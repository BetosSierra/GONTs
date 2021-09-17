#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

if [ -z "$1" ]; 
   then
   echo "El numero de serie no puede ser nulo, No se realiza ninguna accion"
else
  sql="select count(*) from monitor_control_onts where tipo = 'E' and num_serie='"$1"'"
  existeOnt=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sql")
  if [ $existeOnt -gt 0 ]; then 
     sqlUp="update monitor_control_onts set Id_Cliente = 0, Nombre_Cliente = null, Vertical = null where tipo = 'E' and Num_Serie = '"$1"'"
     echo $sqlUp | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;
     echo ""
     echo "********* Se actualizo la ONT *************************"   
     echo ""     
  else
     echo ""
     echo "********************* LA ONT "$1" NO SE ENCUENTRA REGISTRADA EN MONITOREO *************************"
     echo ""
  fi
fi