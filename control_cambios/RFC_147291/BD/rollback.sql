create table tmp_inventario_onts as select * from inventario_onts;
create table tmp_inventario_ifindex as select * from inventario_ifindex;

drop table inventario_onts; 
drop table inventario_ifindex;

CREATE TABLE `inventario_onts` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Consecutiva',
  `Ip_Olt` varchar(20) DEFAULT NULL COMMENT 'Ip OLT',
  `Serial` varchar(50) DEFAULT NULL COMMENT 'Numero de Serie de la ONT',
  `Oid` varchar(45) DEFAULT NULL COMMENT 'Identificador de la ONT',
  `ObjectId` bigint(20) DEFAULT NULL COMMENT 'Identificador de la ONT (1)',
  `OntId` int(11) DEFAULT NULL COMMENT 'Identificador de la ONT (2)',
  `Status` char(1) DEFAULT NULL COMMENT 'Status A Activo I Inactivo',
  `Fecha_Descubrimiento` datetime DEFAULT NULL COMMENT 'Fecha cuando se realizo el descubrimiento',
  `Fecha_Validacion` datetime DEFAULT NULL COMMENT 'Fecha cuando se valido la Ont',
  `Id_Validacion` int(11) DEFAULT NULL COMMENT 'Campo auxiiar para ordenar las Onts por Region para su validacion solo de las Onts que se Monitorean',
  `Region` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `ID` (`Id`),
  KEY `Ip_Olt` (`Ip_Olt`,`Serial`),
  KEY `ObjId` (`Ip_Olt`,`ObjectId`),
  KEY `Serie` (`ObjectId`,`Serial`),
  KEY `Ip` (`Ip_Olt`),
  KEY `idx_idvalidacion` (`Id_Validacion`),
  KEY `idx_serial` (`Serial`),
  KEY `idx_region` (`Region`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para guardar las ONTs descubiertas de cada OLT';

CREATE TABLE `inventario_ifindex` (
  `Id_Index` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Consecutivo',
  `Ip_Olt` varchar(20) DEFAULT NULL COMMENT 'Ip de la OLT',
  `ObjectId` bigint(20) DEFAULT NULL COMMENT 'Identificador de la ONT',
  `Slot` int(11) DEFAULT NULL COMMENT 'Slot donde se encuentra la Ont',
  `Frame` int(11) DEFAULT NULL COMMENT 'Frame donde se encuentra la Ont',
  `Port` int(11) DEFAULT NULL COMMENT 'Puerto donde se encuentra la Ont',
  `Status` char(1) DEFAULT NULL COMMENT 'Status Activo I Inactivo',
  `Fecha_Descubrimiento` datetime DEFAULT NULL COMMENT 'Fecha cuando se realiza el descubrimiento',
  PRIMARY KEY (`Id_Index`),
  KEY `Ip` (`Ip_Olt`),
  KEY `ObjId` (`ObjectId`),
  KEY `Ip_ObjId` (`Ip_Olt`,`ObjectId`),
  KEY `ObjecId` (`ObjectId`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para almacenar los valores de Frame, Slot y Puerto de cada Ont';

insert into inventario_onts(Id, Ip_Olt, Serial, Oid, ObjectId, OntId, Status, Fecha_Descubrimiento) select Id, Ip_Olt, Serial, Oid, ObjectId, OntId, Status, Fecha_Descubrimiento from tmp_inventario_onts;
insert into inventario_ifindex(Id_Index, Ip_Olt, ObjectId, Slot, Frame, Port, Status, Fecha_Descubrimiento) select Id_Index, Ip_Olt, ObjectId, Slot, Frame, Port, Status, Fecha_Descubrimiento from tmp_inventario_ifindex;

drop table tmp_inventario_onts;
drop table tmp_inventario_ifindex;

