#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config_operaciones.sh"

olt=$1
protocolo="AES"
pat=".1.3.6.1.4.1.2011.6.128.1.1.2.43.1.3."
oid="1.3.6.1.4.1.2011.6.128.1.1.2.43.1.3"
cmd="snmpwalk -r 1 -t 1 -Onq -v3 -u userAGPON17 -l authPriv -a SHA -A accesskey372 -x "$protocolo" -X securitykey372 "
if [ -z "$olt" ]; then
   echo "La Ip de la OLT no puede ser Nula"
else
   rm inserts_colombia_$olt.csv
   rm Colombia_$olt.csv
   sqlTotOlt="select count(*) from inventario_olts where ip_olt='"$olt"'"
   existeOlt=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlTotOlt")
   if [ $existeOlt = 0 ]; then
        descr=$(snmpget -Oqv -v 3 -u userAGPON17 -l authPriv -a SHA -A accesskey372 -x AES -X securitykey372 -Ir $olt 1.3.6.1.2.1.1.1.0)
        contact=$(snmpget -Oqv -v 3 -u userAGPON17 -l authPriv -a SHA -A accesskey372 -x AES -X securitykey372 -Ir $olt 1.3.6.1.2.1.1.4.0)
        nom=$(snmpget -Oqv -v 3 -u userAGPON17 -l authPriv -a SHA -A accesskey372 -x AES -X securitykey372 -Ir $olt 1.3.6.1.2.1.1.5.0)
        location=$(snmpget -Oqv -v 3 -u userAGPON17 -l authPriv -a SHA -A accesskey372 -x AES -X securitykey372 -Ir $olt 1.3.6.1.2.1.1.6.0)
   
        sqlIns="insert into inventario_olts(Ip_Olt, Name, Contact, Description, Location, Status, Region, Fecha_Registro) values ('"$olt"','"$nom"','"$contact"','"$descr"','"$location"','A', 'REGION_XX', current_timestamp);"
        echo $sqlIns >> inserts_colombia_$olt.csv
        echo $sqlIns | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD; 
        cmd=$cmd$olt" "$oid
        arr=$(eval $cmd )
        echo $arr | sed 's/ " ./"%./g' | sed 's/[[:space:]]*$/\=/' | sed 's/ "=/"/g' | sed 's/ "/|"/g' | tr -d '[[:space:]]' | sed 's/[[:space:]]*$/\n/' | sed 's/".1/"%.1/g' | sed 's/%/\n/g' | sed 's/'"$pat"'/'"$olt"'|/g' | sed 's/"//g' >> Colombia_$olt.csv
      while IFS= read -r line
         do
            pos=$(echo `expr index "$line" \|`) 
            ip=$(echo ${line:0:pos-1})    
            aux=$(echo ${line:pos})
            pos=$(echo `expr index "$aux" \|`)
            value_oid=$(echo ${aux:0:pos-1})
            serial=$(echo ${aux:pos})
            
            pos=$(echo `expr index "$value_oid" \.`)
            objectid=$(echo ${value_oid:0:pos-1})
            aux=$(echo ${value_oid:pos})
            ontid=$(echo `expr index "$aux" \.`)
            
            sqlOnt="select count(*) from monitor_control_onts where num_serie='"$serial"'"
            existeOnt=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sqlOnt")
            if [ $existeOnt = 0 ]; then
               ins="insert into monitor_control_onts(ip_olt, ObjectId, OntId, num_serie, Fecha_Inc, tipo, Status, monitoreo) values ('"$ip"', "$objectid", "$ontid", '"$serial"', current_timestamp, 'E', 'A', 'S');"
               echo $ins >> inserts_colombia_$olt.csv
               echo $ins | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;
            else
               up="update monitor_control_onts set ip_olt = '"$ip"', objectid = "$objectid", ontid = "$ontid", fecha_modif = current_timestamp where num_serie = '"$serial"')"
               echo $up >> inserts_colombia_$olt.csv
               echo $up | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;
            fi
      done < Colombia_$olt.csv
   else
      echo "La OLT proporcionada ya se encuentra registrada en el Gestor"
   fi
fi


