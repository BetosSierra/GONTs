#!/bin/bash
# Conexion a la BD
for LINEA in `cat  /home/implementacion/scripts-sh/con_descubre.txt `
do
    host=`echo $LINEA | cut -d ":" -f1`
    usr=`echo $LINEA | cut -d ":" -f2`
    pass=`echo $LINEA | cut -d ":" -f3`
    port=`echo $LINEA | cut -d ":" -f4`
    bd=`echo $LINEA | cut -d ":" -f5`
    #echo "Host: $host usuario: $usr Pasw: $pass Puerto: $port BD: $bd"
done 
dtarch=`date +%Y%m%d%H%M%S`
cd /home/implementacion/scripts-sh/out/
# Empaqueta y Comprime los archivos mas recientes 
tar -czvf descubrimiento_$dtarch.tar.gz descubrimiento.csv descubrimiento.log indexonts.csv inventarioOlts.csv
# Borra archivos logs
rm descubrimiento.log
# Crea nuevos archivos log
touch descubrimiento.log
# Borra archivos de descubrimiento
rm descubrimiento.csv indexonts.csv inventarioOlts.csv
# Crea nuevos archivos de descubrimiento
touch descubrimiento.csv indexonts.csv inventarioOlts.csv
echo "["`date +%d/%m/%Y%n%H:%M:%S`"]********************* INICIA DESCUBRIMIENTO **********************" >> descubrimiento.log  
echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Obtiene inventario de OLTS" >> descubrimiento.log
php -f /home/implementacion/scripts-sh/lib/extrae_olts.php
sleep 10
tamOlts=$(stat -c %s  /home/implementacion/scripts-sh/out/inventarioOlts.csv)
if  [ $tamOlts -gt 0 ]; then
   x1=$(stat -c %s  /home/implementacion/scripts-sh/out/inventarioOlts.csv)
   x2=$(stat -c %s  /home/implementacion/scripts-sh/out/inventarioOlts.csv)
   x2=$((x2+1))
   while [ $x1 != $x2 ]; do
      x1=$(stat -c %s  /home/implementacion/scripts-sh/out/inventarioOlts.csv)
      sleep 10
      x2=$(stat -c %s  /home/implementacion/scripts-sh/out/inventarioOlts.csv)
   done
   echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Se genero archivo con inventario de OLTS" >> descubrimiento.log
   echo "*****************************************************************************************************" >> descubrimiento.log
   
   
   #totOnts=$(mysql -h $host -u$usr -p$pass -P$port $bd --skip-column-names </home/implementacion/scripts-sh/in/CuentaOnts.sql)
   #echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] La tabla inventario_onts, contiene "$totOnts" Registros" >> descubrimiento.log 
   #totIndex=$(mysql -h $host -u$usr -p$pass -P$port $bd --skip-column-names </home/implementacion/scripts-sh/in/CuentaIndex.sql)
   #echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] La tabla inventario_ifindex, contiene "$totIndex" Registros" >> descubrimiento.log    
   #echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Se procede a truncar las tablas " >> descubrimiento.log
   
   #mysql -h $host -u$usr -p$pass -P$port $bd < /home/implementacion/scripts-sh/in/truncaDescOnts.sql
   #mysql -h $host -u$usr -p$pass -P$port $bd < /home/implementacion/scripts-sh/in/truncaIndex.sql
   
   #totOnts=$(mysql -h $host -u$usr -p$pass -P$port $bd --skip-column-names </home/implementacion/scripts-sh/in/CuentaOnts.sql) 
   #totIndex=$(mysql -h $host -u$usr -p$pass -P$port $bd --skip-column-names </home/implementacion/scripts-sh/in/CuentaIndex.sql)
      
   #if [ $totOnts -gt 0 ] || [ $totIndex -gt 0 ]; then
   #   echo "["`date +%d/%m/%Y%n%H:%M:%S`"][ERROR] No fue posible truncar las tablas invetario_onts contiene:"$totOnts" e inventario_ifindex contiene:"$totIndex" registros" >> descubrimiento.log
   #else
      let sigue=0
      while [ $sigue -eq 0 ]; do
         #totOnts=$(mysql -h $host -u$usr -p$pass -P$port $bd --skip-column-names </home/implementacion/scripts-sh/in/CuentaOnts.sql)
         #if [ $totOnts -eq 0 ]; then
            #echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] La tabla inventario_onts fue truncada con exito" >> descubrimiento.log
            echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Inicia descubrimiento de Num_Serie y ObjectId de cada ONT " >> descubrimiento.log     
            let "sigue=sigue+1"
            while IFS='' read -r line || [[ -n "$line" ]]; do
               php  -f /home/implementacion/scripts-sh/lib/aplica_descubrimiento.php $line &
            done < "$1"
            #sleep 10
			wait
            tamIni=$(stat -c %s  /home/implementacion/scripts-sh/out/descubrimiento.csv)
            if  [ $tamIni -gt 0 ]; then
               t1=$(stat -c %s  /home/implementacion/scripts-sh/out/descubrimiento.csv)
               t2=$(stat -c %s  /home/implementacion/scripts-sh/out/descubrimiento.csv)
               t2=$((t2+1))
               echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Esperando la finalizacion de escritura en el archivo descubrimiento.csv" >> descubrimiento.log
               while [ $t1 != $t2 ]; do
                  t1=$(stat -c %s  /home/implementacion/scripts-sh/out/descubrimiento.csv)
                  sleep 10
                  t2=$(stat -c %s  /home/implementacion/scripts-sh/out/descubrimiento.csv)
               done   
               echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] El archivo descubrimiento.csv se genero con exito" >> descubrimiento.log
               echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Inicia persistencia de datos en la tabla inventario_onts" >> descubrimiento.log
               mysql -h $host -u$usr -p$pass -P$port $bd < /home/implementacion/scripts-sh/in/subeOnts.sql
               totOnts=$(mysql -h $host -u$usr -p$pass -P$port $bd --skip-column-names </home/implementacion/scripts-sh/in/CuentaOnts.sql)
               echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Se registraron: "$totOnts" Onts" >> descubrimiento.log
               echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] La persitencia termino con exito" >> descubrimiento.log
               echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Termina descubrimiento de Num_Serie y ObjectId de cada ONT " >> descubrimiento.log
               echo "*****************************************************************************************************" >> descubrimiento.log
            
               echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Inicia Proceso Descubrimiento de Frame/Slot/Port " >> descubrimiento.log

               let sigue=0
               while [ $sigue -eq 0 ]; do
                  #totIndex=$(mysql -h $host -u$usr -p$pass -P$port $bd --skip-column-names </home/implementacion/scripts-sh/in/CuentaIndex.sql)
                  #if [ $totIndex -eq 0 ]; then
                  #   echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] La tabla inventario_ifindex fue truncada con exito" >> descubrimiento.log
                  #   echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Inicia descubrimiento" >> descubrimiento.log     
                     let "sigue=sigue+1"
                     while IFS='' read -r line || [[ -n "$line" ]]; do
                        php  -f /home/implementacion/scripts-sh/lib/descubre_ifIndex.php $line &
                     done < "$1"
                   #  sleep 10
				   wait
                     tamIni=$(stat -c %s  /home/implementacion/scripts-sh/out/indexonts.csv)
                     if  [ $tamIni -gt 0 ]; then
                        t1=$(stat -c %s  /home/implementacion/scripts-sh/out/indexonts.csv)
                        t2=$(stat -c %s  /home/implementacion/scripts-sh/out/indexonts.csv)
                        t2=$((t2+1))
                        echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Esperando la finalizacion de escritura en el archivo indexonts.csv" >> descubrimiento.log
                        while [ $t1 != $t2 ]; do
                           t1=$(stat -c %s  /home/implementacion/scripts-sh/out/indexonts.csv)
                           sleep 10
                           t2=$(stat -c %s  /home/implementacion/scripts-sh/out/indexonts.csv)
                        done   
                        echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] El archivo indexonts.csv se genero con exito" >> descubrimiento.log
                        echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Inicia persistencia de datos en la tabla inventario_ifindex" >> descubrimiento.log
                        mysql -h $host -u$usr -p$pass -P$port $bd < /home/implementacion/scripts-sh/in/subeIndex.sql
                        totIndex=$(mysql -h $host -u$usr -p$pass -P$port $bd --skip-column-names </home/implementacion/scripts-sh/in/CuentaIndex.sql)
                        echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Se registraron: "$totIndex" Onts" >> descubrimiento.log
                        echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] La persitencia termino con exito" >> descubrimiento.log
                        echo "["`date +%d/%m/%Y%n%H:%M:%S`"][INFO] Termina Proceso Descubrimiento de Frame/Slot/Port " >> descubrimiento.log               
                     else
                        echo "["`date +%d/%m/%Y%n%H:%M:%S`"][ERROR] El archivo indexonts.csv NO se genero" >> descubrimiento.log
                     fi
                  #else
                  #   totIndex=$(mysql -h $host -u$usr -p$pass -P$port $bd --skip-column-names </home/implementacion/scripts-sh/in/CuentaIndex.sql)
                  #   echo "["`date +%d/%m/%Y%n%H:%M:%S`"][ERROR] La tabla inventario_ifindex aun cuenta con "$totIndex" registros" >> descubrimiento.log
                  #fi
               done
            else
               echo "["`date +%d/%m/%Y%n%H:%M:%S`"][ERROR] El archivo descubrimiento.csv NO se genero" >> descubrimiento.log
            fi
         #else
         #   totOnts=$(mysql -h $host -u$usr -p$pass -P$port $bd --skip-column-names </home/implementacion/scripts-sh/in/CuentaOnts.sql)
         #   echo "["`date +%d/%m/%Y%n%H:%M:%S`"][ERROR] La tabla inventario_onts aun cuenta con "$totOnts" registros" >> descubrimiento.log
         #fi
      done
   #fi
else
   echo "["`date +%d/%m/%Y%n%H:%M:%S`"][ERROR] El archivo inventarioOlts.csv NO se genero" >> descubrimiento.log       
fi
echo "["`date +%d/%m/%Y%n%H:%M:%S`"]********************* TERMINA DESCUBRIMIENTO **********************" >> descubrimiento.log
