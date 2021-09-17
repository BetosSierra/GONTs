#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

if [ -z "$1" ]; 
   then
   echo "El numero de serie no puede ser nulo, No se realiza ninguna accion"
elif [ -z "$2" ]; 
   then
   echo "El segundo parametro no puede ser nulo, No se realiza ninguna accion"   
elif [ -z "$3" ]; 
   then
   echo "El tercer parametro no puede ser nulo, No se realiza ninguna accion"     
else
  echo ""
  echo "********* INICA ACTUALIZACION DE LA OLT "$1" *************************"
  echo ""  
  sqlup="update monitor_control_onts set objectid ="$2", ontid="$3" where num_serie ='"$1"'"
  echo $sqlup | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;
  echo ""
  echo "********* Se actualizo la ONT *************************"   
  echo ""
  echo "********* TERMINA ACTUALIZACION DE LA OLT "$1" *************************"  
fi