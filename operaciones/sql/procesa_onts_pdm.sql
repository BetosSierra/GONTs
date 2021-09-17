insert into monitor_control_onts
(Ip_Olt, Num_Serie, Id_Cliente, Nombre_Cliente,Tipo,Monitoreo,Status,Vertical,Fecha_Inc)
select Ip_Olt, num_serie, Id_Cliente, Nombre_Cliente, 'E', 'S', 'A', Vertical, Fecha_Registro
from registra_nuevas_onts
where status = 'P';

update monitor_control_onts mon
join
(select a.Ip_Olt, a.Serial, a.ObjectId, a.OntId, frame, slot, port
from inventario_onts a, inventario_ifindex b
where a.Ip_Olt = b.Ip_Olt
  and a.ObjectId = b.ObjectId
  and serial in (select num_serie
                   from registra_nuevas_onts
                  where origen = 'PDM'
                    and Status = 'P')) inv
on mon.ip_olt = inv.ip_olt
and mon.num_serie = inv.serial
set mon.objectid = inv.objectid,
    mon.ontid = inv.ontid,
    mon.frame = inv.frame,
    mon.slot = inv.slot,
    mon.port = inv.port;

update registra_nuevas_onts x
join
(select a.id, a.Num_Serie
from registra_nuevas_onts a inner join monitor_control_onts b
on a.Num_Serie = b.Num_Serie
and a.Status = 'P'
and b.tipo = 'E') v
on x.Num_Serie = v.Num_Serie
and x.id = v.id
set Status = 'T',
    Fecha_Integracion = current_timestamp,
    Observaciones = 'Inicia Monitoreo de la ONT';