#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"
echo "********* INICIA ACTUALIZACION DE LA ONT *************************"
echo ""
if [ -z "$1" ]; then
   echo "El numero de serie NO puede ser nulo, No se realizo ningun cambio"
elif [ -z "$2" ]; then
   echo "La Ip de la OLT asociada a la ONT NO puede ser nulo, No se realizo ningun cambio"
else
   sqlTotOlt="select count(*) from inventario_olts where ip_olt='"$2"'" 
   existeOlt=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlTotOlt")
   if [ $existeOlt = 0 ]; then
      echo "La OLT proporcionada no se encuentra registrada en el Gestor, se debe realizar el registro antes de aplicar este cambio"
   else
      sqlTotOnt="select count(*) from monitor_control_onts where tipo = 'E' and num_serie='"$1"'" 
      existeOnt=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlTotOnt")
      if [ $existeOnt = 0 ]; then
         echo "La ONT proporcionada NO se encuentra en monitoreo"
      else      
         echo "********* DATOS PREVIOS A LA ACTUALIZACION DE LA OLT *************************"
         echo ""
         sqlAnt="Select Concat('Ip_Olt:',ip_olt,' Num_Serie:',num_Serie,' Nombre_cliente:',nombre_cliente) From monitor_control_onts where tipo = 'E' and num_serie ='"$1"'"
         arrOlt=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlAnt")   
         IFS=$'\n'
         for val in $arrOlt;
            do
               echo $val
         done
         IFS=$Field_Separator
         sqlup="Update monitor_control_onts set ip_olt ='"$2"' Where tipo = 'E' and num_serie='"$1"'"
         echo $sqlup | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;  
         sqlupPdm="Update tb_dispositivos set IP_OLT ='"$2"' Where NUMERO_SERIE='"$1"'"
         echo $sqlupPdm | mysql -h $PDM_IP -P $PDM_PUERTO -u $PDM_USUARIO -p$PDM_CONTRASENA $PDM_BD;
         echo ""
         echo "********* DATOS POSTERIORES A LA ACTUALIZACION DE LA OLT *************************"
         echo ""
         sqlNvo="Select Concat('Ip_Olt:',ip_olt,' Num_Serie:',num_Serie,' Nombre_cliente:',nombre_cliente) From monitor_control_onts where tipo = 'E' and num_serie ='"$1"'"
         arrOlt2=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlNvo")   
         IFS=$'\n'
         for val2 in $arrOlt2;
            do
               echo $val2
         done
         IFS=$Field_Separator                   
      fi
   fi   
fi
echo ""
echo "********* TERMINA ACTUALIZACION DE LA ONT *************************" 
