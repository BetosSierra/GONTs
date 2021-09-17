#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"
echo "********* INICIA REGISTRO DE LA OLT *************************"
echo ""
if [ -z "$1" ]; then
   echo "La Ip de la OLT NO puede ser nula, No se registro la OLT"
elif [ -z "$2" ]; then
   echo "El dato HostName de la OLT NO puede ser nulo, No se registro la OLT"
elif [ -z "$3" ]; then
   echo "El dato Contact de la OLT NO puede ser nulo, No se registro la OLT"
elif [ -z "$4" ]; then
   echo "El dato Location de la OLT NO puede ser nulo, No se registro la OLT"
elif [ -z "$5" ]; then
   echo "El dato Topology de la OLT NO puede ser nulo, No se registro la OLT"         
else
   vtopology=$5
   sqlTotOlts="select count(*) from inventario_olts where ip_olt='"$1"'" 
   existeOlt=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlTotOlts")
   if [ $existeOlt -gt 0 ]; then 
      echo "Ya existe una OLT registrada en el Gestor de ONTs con la Ip:"$1
   else
      if [[ $vtopology == *R1* ]]; then
         vRegion="REGION_01"
         vsigue="S"
      elif [[ $vtopology == *R2* ]]; then
         vRegion="REGION_02"
         vsigue="S"
      elif [[ $vtopology == *R3* ]]; then
         vRegion="REGION_03"
         vsigue="S"
      elif [[ $vtopology == *R4* ]]; then
         vRegion="REGION_04"
         vsigue="S"
      elif [[ $vtopology == *R5* ]]; then
         vRegion="REGION_05"
         vsigue="S"
      elif [[ $vtopology == *R6* ]]; then
         vRegion="REGION_06"
         vsigue="S"
      elif [[ $vtopology == *R7* ]]; then
         vRegion="REGION_07"
         vsigue="S"
      elif [[ $vtopology == *R8* ]]; then
         vRegion="REGION_08"
         vsigue="S"
      elif [[ $vtopology == *R9-1* ]]; then
         vRegion="REGION_09DF01"
         vsigue="S"
      elif [[ $vtopology == *R9-2* ]]; then
         vRegion="REGION_09DF02"
         vsigue="S"
      elif [[ $vtopology == *R9-3* ]]; then
         vRegion="REGION_09DF03"
         vsigue="S"
      else
         vsigue="N"
      fi
      if [ "$vsigue" == "S" ]; then
         echo ""
         echo "Los datos de la OLT que se registrara son:"
         echo ""
         echo "Ip:"$1
         echo "HostName:"$2
         echo "Contact:"$3
         echo "Location:"$4
         echo "Topology:"$5
         echo "Region:"$vRegion
         echo ""
         
         sqlIns="Insert Into inventario_olts (Ip_Olt,Name,Contact,Location,Description,Status,Region,Fecha_Registro) values ('"$1"','"$2"','"$3"','"$4"','"$5"','A','"$vRegion"',current_timestamp)"
         echo $sqlIns | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;
         echo ""
         echo "Se registro la OLT con exito en el Gestor de ONTs"
         sqlInsPdm="Insert Into tb_dispositivos (folio,area,NOMBRE_DISPOSITIVO,TIPO_DISPOSITIVO,IP_OLT,USUARIO_ALTA,TOPOLOGY,REGION) select max(folio)+1, (select id_origen from tb_origen where nombre='ONT'),'"$2"',(select ID_DISPOSITIVO from cat_dispositivos where NOMBRE_DISPOSITIVO like 'OLT%'),'"$1"',(select id from tb_user where username='onts'),'"$5"','"$vRegion"' from tb_dispositivos"
         echo $sqlInsPdm | mysql -h $PDM_IP -P $PDM_PUERTO -u $PDM_USUARIO -p$PDM_CONTRASENA $PDM_BD;
         echo ""
         echo "Se registro la OLT con exito en PDM"         
         sqlNvo="Select Concat('Ip_Olt:',ip_olt,' Name_Olt:',Name) From inventario_olts where ip_olt ='"$1"'"
         arrOlt2=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlNvo")   
         IFS=$'\n'
         for val2 in $arrOlt2;
            do
               echo $val2
         done
         IFS=$Field_Separator                 
      else
         echo "El dato Topology no contiene la nomenclatura correcta para definir la region, No se registro la OLT"
      fi
   fi
fi
echo ""
echo "********* TERMINA REGISTRO DE LA OLT *************************"