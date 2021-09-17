#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

ip=$1 
existe=false
snmp="snmpbulkwalk -r1 -t1 -Ir -v3 -u userAGPON17 -l authPriv -a SHA -A accesskey372 -x AES -X securitykey372 "$ip" HUAWEI-XPON-MIB::hwGponDeviceOntSn"
snmp2="snmpbulkwalk -r1 -t1 -Ir -v3 -u userAGPON17 -l authPriv -a SHA -A accesskey372 -x AES -X securitykey372 "$ip" IF-MIB::ifName."

if [ -z "$1" ]; then 
   echo ""
   echo "La Ip de la OLT NO puede ser nula"
   echo ""
elif [ -z "$2" ]; then
   echo ""
   echo "El Numero de Serie NO puede ser nulo"
   echo ""
elif [ -z "$3" ]; then
   echo ""
   echo "El Id_Cliente NO puede ser nulo"
   echo ""   
elif [ -z "$4" ]; then
   echo ""
   echo "El Nombre del Cliente NO puede ser nulo"
   echo ""   
elif [ -z "$5" ]; then
   echo ""
   echo "La Unidad de Negocio NO puede ser nulo"
   echo ""   
else
   arr=$(eval $snmp)
   IFS=$'\n'
   for val in $arr;
      do
         aux=""
         oid=""
         serie=""
         if [[ $val == *Hex-STRING* ]]; then
            aux=$(echo ${val} | sed -e 's/ = Hex-STRING: /=/g')
            pos=$(echo `expr index "$aux" .`)
            aux2=$(echo ${aux:$pos})
            pos=$(echo `expr index "$aux2" =`)
            oid=$(echo ${aux2:0:$pos-1})
            y=$(echo ${aux2:$pos})
            serie=$(echo $y | tr -d '[[:space:]]')
    
            pos=$(echo `expr index "$oid" .`)
            objectid=$(echo ${oid:0:$pos-1})
            ontid=$(echo ${oid:$pos})
            if [[ $serie == $2 ]]; then
               gpon=$(eval $snmp2$objectid)
               aux2=$(echo ${gpon} | sed -e 's/ = STRING: GPON /=/g')
               pos=$(echo `expr index "$aux2" =`)
               pos1=$(echo `expr index "$aux2" /`)
               d=$(echo ${aux2:$pos:$pos1-1})
               pos=$(echo `expr index "$d" /`)
               frame=$(echo ${d:0:$pos-1})
               r=$(echo ${d:$pos})
               pos=$(echo `expr index "$r" /`)
               slot=$(echo ${r:0:$pos-1})
               port=$(echo ${r:$pos})
               existe=true
               break
            else
               existe=false
            fi
         fi
   done
   IFS=$Field_Separator
   if $existe; then
      echo "******************* Dispositivo localizado ******************"
      echo ""
         ins="Insert into monitor_control_onts (Ip_Olt,Num_Serie,ObjectId,OntId,Frame,Slot,Port,Monitoreo,tipo,Status,Id_Cliente,Nombre_Cliente,Vertical,Fecha_Inc) values ('"$1"','"$2"',"$objectid","$ontid","$frame","$slot","$port",'S','E','A',"$3",'"$4"','"$5"',current_timestamp)"
         echo $ins | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;
      echo ""
      echo "******************* Dispositivo Registrado ******************"
      echo ""
      echo "Se regisro el dispositivo con numero de serie:"$serie" con Oid:"$oid" Frame:"$frame" Slot:"$slot" Puerto:"$port
      echo ""         
      echo "******************* Dispositivo Registrado ******************"
   else
      echo "******************* Dispositivo no localizado ******************"
   fi 
fi