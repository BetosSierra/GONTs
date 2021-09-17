#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

if [ -z "$1" ]; 
   then
   echo "La ip de la OLT no puede ser nulo, No se realiza ninguna accion"
else
  sql="select count(*) from inventario_olts where ip_olt='"$1"'"
  existeOlt=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sql")
  if [ $existeOlt -gt 0 ]; then 
     sqlUp="Delete from inventario_olts where ip_olt = '"$1"'"
     echo $sqlUp | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;
     echo ""
     echo "*********************** Se elimino la OLT *************************"   
     echo ""     
  else
     echo ""
     echo "********************* LA OLT "$1" NO SE ENCUENTRA REGISTRADA EN MONITOREO *************************"
     echo ""
  fi
fi