create temporary table tmp_actualiza_ont_Region_05 as
select a.Ip_Olt, serial, a.ObjectId, a.OntId, frame, slot, port
from inventario_onts a, inventario_ifindex b, inventario_olts c
where a.Ip_Olt = b.Ip_Olt
  and a.ObjectId = b.ObjectId
  and a.Ip_Olt = c.Ip_Olt
  and b.Ip_Olt = c.Ip_Olt
  and c.region = 'REGION_05'
and serial in (
select num_serie 
from monitor_control_onts c, inventario_olts d
where c.Ip_Olt = d.Ip_Olt
 and tipo = 'E'
 and d.region = 'REGION_05');
 
 update monitor_control_onts ont 
join ( 
select  des.Ip_Olt, des.serial, des.ObjectId, des.OntId, des.Slot, des.Frame, des.Port 
from 
(select x.ip_olt, x.serial, x.ObjectId, x.OntId, x.Frame, x.Slot, x.Port  
from tmp_actualiza_ont_Region_05 x ) des 
join 
(select ip_olt, num_serie, ObjectId, OntId, Frame, Slot, Port 
from monitor_control_onts 
where tipo = 'E'
 and num_serie in (select serial from tmp_actualiza_ont_Region_05) ) mon 
on des.serial = mon.num_serie 
and (des.ip_olt != mon.ip_olt or 
des.objectid != mon.objectid or  
des.ontid != mon.ontid or
des.frame != mon.Frame or 
des.slot != mon.Slot or 
des.port != mon.Port)) camb  
on ont.num_serie = camb.serial 
set ont.ip_olt = camb.ip_olt,                                         
ont.ObjectId = camb.ObjectId, 
ont.ontid = camb.ontid,  
ont.Frame = camb.Frame, 
ont.slot = camb.slot, 
ont.port = camb.port;

drop table tmp_actualiza_ont_Region_05;