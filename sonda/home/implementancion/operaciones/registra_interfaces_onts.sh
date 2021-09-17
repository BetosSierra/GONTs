#!/bin/sh  
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

rutain="/home/implementacion/operaciones/"
rutaout="/home/implementacion/operaciones/out/"
dtarch=`date +%Y%m%d%H%M%S`

fileOnts="registry_onts.txt"
salidaOnts="registry_onts"$dtarch".out"
if test -f "$rutain$fileOnts"; then
   if [ -s "$rutain$fileOnts" ]; then
      jsonIn=`cat $rutain$fileOnts`
      fn="call Sp_Registry_Config_Onts('"$jsonIn"');"
      jsonOut=$($MA_CONEXION --skip-column-names -e "$fn")
      echo 
      echo $jsonOut >> $rutaout$salidaOnts
      msgOut="Se proceso la peticion, el resultado se genero en "$rutaout$salidaOnts
      echo -e "\e[1;94m$msgOut\e[0m"             
      echo
   else
      echo
      echo -e "\e[91mEl archivo $fileOnts no contiene informacion\e[0m"
      echo         
   fi
else
   echo
   echo -e "\e[91mEl archivo $fileOnts no existe o no se encuentra en la carpeta $rutain\e[0m"
   echo
fi