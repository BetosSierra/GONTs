#!/bin/sh  
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

rutain="/home/implementacion/operaciones/"
rutaout="/home/implementacion/operaciones/out/"
valcero="0"
dtarch=`date +%Y%m%d%H%M%S`
f=`date +%Y%m%d%H%M%S`


registraClienteInterfaces()
   {
      echo -e "\e[92mProporcione el Id del Cliente a registrar:\e[0m"
      read idcliente
      if [ ! -z "$idcliente" ]; then
         if [[ "$idcliente" = "$valcero" ]]; then
            echo -e "\e[91mEl Identificador NO puede igual a cero\e[0m"
         else
            sql="select count(*) FROM admin_client_monitoring WHERE id_client = "$idcliente
            existeIdCliente=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sql")
            if [ $existeIdCliente = 0 ]; then
               echo -e "\e[92mProporcione el Nombre del Cliente a registrar:\e[0m"
               read namecliente
               if [ ! -z "$namecliente" ]; then
                  sql2="select count(*) FROM admin_client_monitoring WHERE name_client like '%"$namecliente"%'"
                  existeCliente=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sql2")
                  if [ $existeCliente = 0 ]; then
                     ins="Insert Into admin_client_monitoring (id_client,name_client) values ("$idcliente",'"$namecliente"');"
                     echo $ins | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;   
                     echo
                     msgOut="Se registro con exito el Cliente"
                     echo -e "\e[1;94m$msgOut\e[0m"                                       
                  else 
                     echo -e "\e[91mExiste un Cliente registrado con un nombre similar, por favor valide\e[0m"
                  fi
               else
                  echo -e "\e[91mEl Nombre del Cliente NO puede ser nulo\e[0m"
               fi
            else 
               echo -e "\e[91mEl Cliente ya se encuentra registrado\e[0m"
            fi         
           fi
      else
         echo -e "\e[91mEl Identificador del Cliente NO puede ser nulo\e[0m" 
      fi
   }

actualizaClienteInterfaces()
   {
      echo -e "\e[92mProporcione el Id del Cliente que desea actualizar :\e[0m"
      read idcliente
      if [ ! -z "$idcliente" ]; then
         sql="select count(*) FROM admin_client_monitoring WHERE id_client = "$idcliente
         existeIdCliente=$(mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sql")
         if [ $existeIdCliente = 0 ]; then
            echo -e "\e[91mEl Cliente NO se encuentra registrado\e[0m"
         else
            up="Update admin_client_monitoring set status = 'I', date_modify = current_timestamp where id_client = "$idcliente
            echo $up | mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD;   
            echo
            msgOut="Se actualizo con exito el Cliente"
            echo -e "\e[1;94m$msgOut\e[0m"              
         fi      
      else
         echo -e "\e[91mEl Identificador del Cliente NO puede ser nulo\e[0m"       
      fi   
   }
reporteClienteInterfaces()
   {
      find $rutaout -type f -name "clientes_monitoreo_*.csv" -mtime +7 -exec rm -f {} \;
      f=`date +%Y%m%d%H%M%S`
      arch="clientes_monitoreo_$f.csv"
      touch $rutaout$arch 
      chmod 777 $rutaout$arch

      echo "Id_registry_client|id_client|name_client|status|date_registry|date_modify" >> $rutaout$arch

      sql="select concat(ifnull(Id_registry_client,''),'|',ifnull(id_client,''),'|',ifnull(name_client,''),'|',ifnull(status,''),'|',ifnull(date_registry,''),'|',ifnull(date_modify,'')) from admin_client_monitoring"

      mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD --skip-column-names -e "$sql" >> $rutaout$arch
      echo
      msgOut="Se genero el archivo en la ruta "$rutaout" con el nombre "$arch
      echo -e "\e[1;94m$msgOut\e[0m"
      #_menu()
   }

menu_principal()
   {
       clear
       echo
       echo -e "\e[1;94m****************************************************************\e[0m"
       echo -e "\e[1;94m*           MENU DE OPCIONES PARA LA OPERACION DE ONTs         *\e[0m"
       echo -e "\e[1;94m****************************************************************\e[0m"
       echo "*                                                              *"        
       echo "* 1) Registra Cliente para Monitoreo de Interfaces             *"
       echo "* 2) Elimina Cliente del Monitoreo de Interfaces               *"
       echo "*                                                              *"
       echo -e "\e[91m****************************************************************\e[0m"
       echo -e "\e[91m*                           REPORTES                           *\e[0m"
       echo -e "\e[91m****************************************************************\e[0m"
       echo "*                                                              *"              
       echo "* 60) Reporte de Clientes en Monitore de Interfaces            *"
       echo "*                                                              *"
       echo "*                                                              *"          
       echo -e "\e[96m****************************************************************\e[0m"
       echo -e "\e[96m* 99) Salir                                                    *\e[0m"
       echo -e "\e[96m****************************************************************\e[0m"
       echo
       echo -n "Elija una opcion: "
   }
   
mantenimiento()
   {
      echo ""
      echo "------------------------------------"
      echo "       Proceso en Mantenimiento     "
      echo "------------------------------------"
      echo ""
      echo " Presione Enter para Continuar "
   } 
   
construccion()
   {
      echo ""
      echo "------------------------------------"
      echo "       Proceso en Construccion     "
      echo "------------------------------------"
      echo ""
      echo " Presione Enter para Continuar "
   }    
   
ejecutaOpcion()
   {
      if [ "$1" == "1" ]; then
         registraClienteInterfaces
      elif [ "$1" == "2" ]; then
         actualizaClienteInterfaces
      elif [ "$1" == "60" ]; then
         reporteClienteInterfaces
      fi
   }    
opc="0"
until [ "$opc" -eq "99" ];
do
    case $op in  
        "1")
            ejecutaOpcion $op
            ;;
        "2")
            ejecutaOpcion $op
            ;;
        "60")
            ejecutaOpcion $op
            ;;            
        *)
            # Esta opcion se ejecuta si no es ninguna de las anteriores
            menu_principal
            ;;
    esac
    read opc
    op=$(echo ${opc^^})
done
