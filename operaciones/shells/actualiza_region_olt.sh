#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

if [ -z "$1" ]; 
   then
   echo "La Ip de la OLT NO puede ser nula, No se realiza ninguna accion"
elif [ -z "$2" ]; 
   then
   echo "La region de la OLT NO puede ser nula, No se realiza ninguna accion"
else
   echo "********* INICIA ACTUALIZACION DE REGION PARA LA OLT "$1" *************************"
   echo ""
   sqlRegion="select count(*) from inventario_olts where REGION='"$2"'" 
   existeRegion=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlRegion")
   if [ $existeRegion = 0 ]; then
      echo "La nomenclatura de la region proporcionada no corresponde a las establecidas"
   else
      sqlup="Update inventario_olts set region ='"$2"' Where ip_olt ='"$1"'"
      echo $sqlup | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;  
      sqlupPdm="Update tb_dispositivos set region ='"$2"' Where ip_olt ='"$1"'"
      echo $sqlupPdm | mysql -h $PDM_IP -P $PDM_PUERTO -u $PDM_USUARIO -p$PDM_CONTRASENA $PDM_BD;      
      echo "Se actualizo la region para la OLT: "$1  
   fi
   echo ""
   echo "********* TERMINA ACTUALIZACION DE REGION PARA LA OLT "$1" *************************"
fi   