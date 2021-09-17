#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

if [ -z "$1" ]; then
   echo "La Ip de la OLT actual NO puede ser nula, No se realiza ninguna accion"
elif [ -z "$2" ]; then
   echo "La Ip de la OLT nueva NO puede ser nula, No se realiza ninguna accion"
else
   echo "********* INICIA ACTUALIZACION DE LA OLT *************************"
   echo ""
   sqlTotOlts="select count(*) from inventario_olts where ip_olt='"$1"'" 
   existeOlt=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlTotOlts")
   if [ $existeOlt = 0 ]; then
      echo "La OLT no se encuentra registrada"
   elif [ $existeOlt -gt 1 ]; then 
      echo "Existe mas de una OLT registrada "
   else
      #echo "********* DATOS PREVIOS A LA ACTUALIZACION DE LA OLT *************************"
      #echo ""
      #sqlAnt="Select Concat('Ip_Olt:',ip_olt,' Name_Olt:',Name) From inventario_olts where ip_olt ='"$1"'"
      #arrOlt=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlAnt")   
      #IFS=$'\n'
      #for val in $arrOlt;
      #   do
      #      echo $val
      #done
      #IFS=$Field_Separator
      sqlup="Update inventario_olts set ip_olt ='"$2"' Where ip_olt ='"$1"'"
      echo $sqlup | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;
      sqlupPdm="Update tb_dispositivos set ip_olt ='"$2"' Where ip_olt ='"$1"'"  
      echo $sqlupPdm | mysql -h $PDM_IP -P $PDM_PUERTO -u $PDM_USUARIO -p$PDM_CONTRASENA $PDM_BD;
      sqlMon="update monitor_control_onts set ip_olt = '"$2"' where tipo = 'E' and Ip_Olt = '"$1"'"
      echo $sqlMon | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;
      echo ""  
      #echo "********* DATOS POSTERIORES A LA ACTUALIZACION DE LA OLT *************************"
      #echo ""
      #sqlNvo="Select Concat('Ip_Olt:',ip_olt,' Name_Olt:',Name) From inventario_olts where ip_olt ='"$2"'"
      #arrOlt2=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlNvo")   
      #IFS=$'\n'
      #for val2 in $arrOlt2;
      #  do
      #     echo $val2
      #done
      #IFS=$Field_Separator 
   fi
   echo ""
   echo "********* TERMINA ACTUALIZACION DE LA OLT *************************"
fi   

