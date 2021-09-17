#!/bin/bash

dt=`date +%Y%m%d%H%M%S`

cd /home/implementacion/monitor_procesos/out/

mv sonda_descubre.txt sonda_descubre_$dt.txt
 
mysql -h 10.180.251.83 -P 3306 -u root -pSeguridadMayo2019 monitor_onts </home/implementacion/monitor_procesos/val_descubre.sql > sonda_descubre.txt

##         BORRAMOS LOS RESPALDOS QUE TIENEN MAS DE X DIAS   ##
find sonda_descubre*_ -mtime +1 -exec tar -czvf sondaDescubre_$dt.tar.gz sonda_descubre* {} \;
find sonda_descubre*_ -mtime +1 -exec rm {} \;



