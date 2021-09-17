#!/bin/bash

dt=`date +%Y%m%d%H%M%S`

cd /home/implementacion/monitor_procesos/out/

mv sonda_consumo_servidor01.txt sonda_consumo_servidor01_$dt.txt
mv sonda_consumo_servidor02.txt sonda_consumo_servidor02_$dt.txt
mv sonda_consumo_servidor03.txt sonda_consumo_servidor03_$dt.txt
mv sonda_consumo_servidor04.txt sonda_consumo_servidor04_$dt.txt
mv sonda_consumo_servidor05.txt sonda_consumo_servidor05_$dt.txt
mv sonda_consumo_servidor06.txt sonda_consumo_servidor06_$dt.txt

mysql -h 10.180.251.83 -P 3306 -u root -pSeguridadMayo2019 monitor_onts </home/implementacion/monitor_procesos/consumo_serv_metricas01.sql > sonda_consumo_servidor01.txt
mysql -h 10.180.251.83 -P 3306 -u root -pSeguridadMayo2019 monitor_onts </home/implementacion/monitor_procesos/consumo_serv_metricas02.sql > sonda_consumo_servidor02.txt
mysql -h 10.180.251.83 -P 3306 -u root -pSeguridadMayo2019 monitor_onts </home/implementacion/monitor_procesos/consumo_serv_metricas03.sql > sonda_consumo_servidor03.txt
mysql -h 10.180.251.83 -P 3306 -u root -pSeguridadMayo2019 monitor_onts </home/implementacion/monitor_procesos/consumo_serv_metricas04.sql > sonda_consumo_servidor04.txt
mysql -h 10.180.251.83 -P 3306 -u root -pSeguridadMayo2019 monitor_onts </home/implementacion/monitor_procesos/consumo_serv_metricas05.sql > sonda_consumo_servidor05.txt
mysql -h 10.180.251.83 -P 3306 -u root -pSeguridadMayo2019 monitor_onts </home/implementacion/monitor_procesos/consumo_serv_metricas06.sql > sonda_consumo_servidor06.txt


##         BORRAMOS LOS RESPALDOS QUE TIENEN MAS DE X DIAS   ##
find sonda_consumo_servidor*_ -mtime +1 -exec tar -czvf sonda_consumo_$dt.tar.gz sonda_consumo_servidor* {} \;
find sonda_consumo_servidor*_ -mtime +1 -exec rm {} \;
