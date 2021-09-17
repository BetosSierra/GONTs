LOAD DATA LOCAL INFILE '/home/implementacion/scripts-sh/out/descubrimiento.csv' 
INTO TABLE inventario_onts_tmp_test 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
(Ip_Olt, Serial, Oid, ObjectId, OntId, Fecha_Descubrimiento, Status)
set Fecha_Descubrimiento = current_timestamp, Status = 'N'