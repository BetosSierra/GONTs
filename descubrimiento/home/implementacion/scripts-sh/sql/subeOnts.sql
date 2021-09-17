CREATE TEMPORARY TABLE tmp_inventario_onts (
  `Ip_Olt` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'Ip OLT',
  `Serial` varchar(50) CHARACTER SET latin1 NOT NULL COMMENT 'Numero de Serie de la ONT',
  `Oid` varchar(45) CHARACTER SET latin1 DEFAULT NULL COMMENT 'Identificador de la ONT',
  `ObjectId` bigint(20) DEFAULT NULL COMMENT 'Identificador de la ONT (1)',
  `OntId` int(11) DEFAULT NULL COMMENT 'Identificador de la ONT (2)',
  `Status` char(1) CHARACTER SET latin1 DEFAULT NULL COMMENT 'Status A Activo I Inactivo',
  `Fecha_Descubrimiento` datetime DEFAULT NULL COMMENT 'Fecha cuando se realizo el descubrimiento'
);

LOAD DATA LOCAL INFILE '/home/implementacion/scripts-sh/out/descubrimiento.csv' 
INTO TABLE tmp_inventario_onts 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
(Ip_Olt, Serial, Oid, ObjectId, OntId, Fecha_Descubrimiento, Status)
set Fecha_Descubrimiento = current_timestamp, Status = 'A';

INSERT INTO inventario_onts(Ip_Olt, Serial, Oid, ObjectId, OntId, Fecha_Descubrimiento, Status)
SELECT Ip_Olt, Serial, Oid, ObjectId, OntId, Fecha_Descubrimiento, Status FROM tmp_inventario_onts
ON DUPLICATE KEY UPDATE Oid = VALUES(Oid), ObjectId = VALUES(ObjectId), OntId = VALUES(OntId), Fecha_Modif = current_timestamp;


DROP TEMPORARY TABLE tmp_inventario_onts;

