#!/bin/bash
for LINEA in `cat  /home/implementacion/scripts-sh/con_descubre.txt `
do
    host=`echo $LINEA | cut -d ":" -f1`
    usr=`echo $LINEA | cut -d ":" -f2`
    pass=`echo $LINEA | cut -d ":" -f3`
    port=`echo $LINEA | cut -d ":" -f4`
    bd=`echo $LINEA | cut -d ":" -f5`
done 
echo "Inicia validacion de Region09DF03 ".`date "+%d/%m/%Y %H:%M:%S"`
mysql -h $host -u$usr -p$pass -P$port $bd < /home/implementacion/scripts-sh/in/procesa_OntxRegion09DF03.sql
echo "Termina validacion de Region09DF03 ".`date "+%d/%m/%Y %H:%M:%S"`