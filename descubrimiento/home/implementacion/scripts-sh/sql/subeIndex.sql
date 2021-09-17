CREATE TEMPORARY TABLE tmp_inventario_ifindex (
  `Ip_Olt` varchar(20) NOT NULL COMMENT 'Ip de la OLT',
  `ObjectId` bigint(20) NOT NULL COMMENT 'Identificador de la ONT',
  `Slot` int(11) DEFAULT NULL COMMENT 'Slot donde se encuentra la Ont',
  `Frame` int(11) DEFAULT NULL COMMENT 'Frame donde se encuentra la Ont',
  `Port` int(11) DEFAULT NULL COMMENT 'Puerto donde se encuentra la Ont',
  `Status` char(1) DEFAULT NULL COMMENT 'Status Activo I Inactivo',
  `Fecha_Descubrimiento` datetime DEFAULT NULL COMMENT 'Fecha cuando se realiza el descubrimiento'
);

LOAD DATA LOCAL INFILE '/home/implementacion/scripts-sh/out/indexonts.csv' 
INTO TABLE tmp_inventario_ifindex
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
(Ip_Olt, ObjectId, Slot, Frame, Port, Status, Fecha_Descubrimiento)
set Status = 'A', Fecha_Descubrimiento = current_timestamp;

INSERT INTO inventario_ifindex(Ip_Olt, ObjectId, Slot, Frame, Port, Status, Fecha_Descubrimiento)
SELECT Ip_Olt, ObjectId, Slot, Frame, Port, Status, Fecha_Descubrimiento FROM tmp_inventario_ifindex
ON DUPLICATE KEY UPDATE Slot = VALUES(Slot), Frame = VALUES(Frame), Port = VALUES(Port), Fecha_Modif = current_timestamp;

drop TEMPORARY TABLE tmp_inventario_ifindex;

