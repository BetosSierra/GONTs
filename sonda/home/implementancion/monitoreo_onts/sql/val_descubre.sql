select Concat('FECHA_CORTE:', 
       date_Format(current_timestamp, '%d/%m/%Y %H:%i:%S'), 
       '|SERVIDOR:10.180.199.170|','FECHA_DESCUBRIMIENTO:',
       max(date_format(fecha_descubrimiento, '%d/%m/%Y %H:%i:%S')), 
       '|Onts Descubiertas: ',  
       CAST(count(*) AS CHAR)) val 
from inventario_onts
