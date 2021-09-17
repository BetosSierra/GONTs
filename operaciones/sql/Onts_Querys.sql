  /* Consulta que devuelve el inventario de OLTs registradas en el Gestor de ONTs*/
  
  Select *	 
  from v_cat_olts
  
  /* Consulta que devuelve el inventario de ONTs que se encuentran en Monitoreo en el Gestor de ONTs*/  
  Select Ip_Olt, Num_Serie, Concat(ObjectId,'.', OntId) Oid, Id_Cliente, Nombre_Cliente, Vertical Unidad_Negocio, RunStatus, date_last_RunStatus fecha_ultimo_poleo
  from monitor_control_onts
  where  Num_Serie = '48575443D3299E9D'
  
  
  
  /* Consulta dipositivos en PDM*/
  sh consulta_sdwan.sh
  
  /* Consulta ONTs pendientes */
  sh consulta_onts_pendientes.sh
  
/* Registrar Nuevas OLTs*/
sh registra_olts.sh
  
Network_Address
ModelName
SysContact
Sys_Location
Topology 

/* Cambiar Ip de una OLT existente */

sh actualiza_olt.sh ip_actual ip_nueva

/* Cambiar ip a una ONT que ya se monitorea*/

sh cambia_olt_ont.sh numero_serie ip_olt_nueva


  
  
  
  
  
  
  
   
  /* Consulta que devuelve las ONTs descubiertas en la última hora*/
  
  Select a.Ip_Olt, a.serial, Concat(a.ObjectId,'.', OntId) Oid, Frame, Slot, Port, a.Fecha_Descubrimiento
  from inventario_onts a, inventario_ifindex b
  where a.Ip_Olt = b.Ip_Olt
    and a.ObjectId = b.ObjectId
    and a.Ip_Olt = '10.180.216.134'    
    and serial = '48575443FF69F09C'
  
/* Consulta que devuelve las ONTs que se enviaron desde PDM y que no fue posible registrar en el Gestor de ONTs para su monitoreo*/  
insert into monitor_control_onts (Ip_Olt, Num_Serie, Id_Cliente, Nombre_Cliente, Vertical, tipo, status, Monitoreo, Fecha_Inc)
select pdm.Ip_Olt, pdm.Num_Serie, pdm.Id_Cliente, pdm.Nombre_Cliente, pdm.Vertical, 'E', 'A', 'S', pdm.fecha_registro
from registra_nuevas_onts pdm
join
  (Select Num_Serie, max(Fecha_Registro) fecha_registro
  from registra_nuevas_onts
  where origen = 'PDM'
  and status = 'E'  
  and Observaciones  != 'La ONT ya se encuentra en Monitoreo'
  and substring(Num_Serie,1,3) != 'ZTE'
  and Num_Serie = '48575443D3299E9D'  
  group by Num_Serie) x
  on pdm.Num_Serie = x.num_serie
  and pdm.Fecha_Registro = x.fecha_registro
  
  Select Ip_Olt, Num_Serie, Id_Cliente, Nombre_Cliente, Vertical
  from registra_nuevas_onts
  where origen = 'PDM'
  and status = 'E'  
  limit 10
  
 /* Insertar una OLT */
  insert into inventario_olts (Ip_Olt, Name, Status, Region, Fecha_Registro) 
            values ('10.71.2.131', 'VILLA_GALAXIA_MZT', 'A', 'REGION_02', current_timestamp);
            
select *           
  from registra_nuevas_onts
  where origen = 'PDM'
  and status = 'E'  
  and Num_Serie = '48575443ACE85367'     
  
 /* Registradas en el Gestor de ONTs sin OLT */
select distinct pdm.Ip_Olt, pdm.Num_Serie, pdm.Id_Cliente, pdm.Nombre_Cliente, pdm.Vertical, 'E', 'A', 'S', pdm.fecha_registro,
       case 
          when (select count(*) from inventario_olts where Ip_Olt = pdm.Ip_Olt) > 1 then 'S' else 'N' end existe_olt 
from registra_nuevas_onts pdm
join
  (
  
  Select *
  from registra_nuevas_onts
  where origen = 'PDM'
  and status = 'E'  
 and substring(Num_Serie,1,7)  = '4857544'
--  and Num_Serie in (select num_serie from monitor_control_onts where tipo = 'E')
  and Ip_Olt not in (select Ip_Olt  from inventario_olts)
  
  , 'E', 'A', 'S', pdm.fecha_registro,
  
/* NO Registradas en Gestor de ONTs*/  
select Concat(pdm.Ip_Olt,'|',pdm.Num_Serie,'|',ifnull(pdm.Id_Cliente,0),'|',ifnull(pdm.Nombre_Cliente,'PUNTAS SIN CLIENTE'),'|',ifnull(pdm.Vertical,'null'),'|',pdm.fecha_registro,'|',
       case when (select count(*) from inventario_olts where Ip_Olt = pdm.Ip_Olt) >= 1 then 'S' else 'N' end )
from registra_nuevas_onts pdm
join
  (Select Num_Serie, max(Fecha_Registro) fecha_registro
  from registra_nuevas_onts
  where origen = 'PDM'
  and status = 'E'  
  group by Num_Serie) x
  on pdm.Num_Serie = x.num_serie
  and pdm.Fecha_Registro = x.fecha_registro
  and substring(pdm.Num_Serie,1,7) = '4857544'
  and pdm.Num_Serie not in (select num_serie from monitor_control_onts where tipo = 'E');
  
 insert into monitor_control_onts (ip_olt, pdm.num_serie, Id_Cliente,Nombre_Cliente, Vertical, Fecha_Inc,tipo,status,Monitoreo) 
 select  Ip_Olt,Num_Serie,Id_Cliente,Nombre_Cliente,Vertical,fecha_registro,'E','A','S'
 from 
 (select pdm.Ip_Olt,pdm.Num_Serie,pdm.Id_Cliente,pdm.Nombre_Cliente,pdm.Vertical,pdm.fecha_registro,
       case when (select count(*) from inventario_olts where Ip_Olt = pdm.Ip_Olt) >= 1 then 'S' else 'N' end Existe_Olt
from registra_nuevas_onts pdm
join
  (Select Num_Serie, max(Fecha_Registro) fecha_registro
  from registra_nuevas_onts
  where origen = 'PDM'
  and status = 'E'  
  group by Num_Serie) x
  on pdm.Num_Serie = x.num_serie
  and pdm.Fecha_Registro = x.fecha_registro
  and substring(pdm.Num_Serie,1,7) = '4857544'
  and pdm.Num_Serie not in (select num_serie from monitor_control_onts where tipo = 'E')) onts  
  where onts.existe_olt = 'S';
  
  select distinct pdm.Num_Serie
from registra_nuevas_onts pdm
join
  (Select Num_Serie, max(Fecha_Registro) fecha_registro
  from registra_nuevas_onts
  where origen = 'PDM'
  and status = 'E'  
  group by Num_Serie) x
  on pdm.Num_Serie = x.num_serie
  and pdm.Fecha_Registro = x.fecha_registro
  and substring(pdm.Num_Serie,1,7) = '4857544'
  and pdm.Num_Serie not in (select num_serie from monitor_control_onts where tipo = 'E')
  
  update  from registra_nuevas_onts reg
  join
  ( select  Ip_Olt,Num_Serie
 from 
 (select pdm.Ip_Olt,pdm.Num_Serie,pdm.Id_Cliente,pdm.Nombre_Cliente,pdm.Vertical,pdm.fecha_registro,
       case when (select count(*) from inventario_olts where Ip_Olt = pdm.Ip_Olt) >= 1 then 'S' else 'N' end Existe_Olt
from registra_nuevas_onts pdm
join
  (Select Num_Serie, max(Fecha_Registro) fecha_registro
  from registra_nuevas_onts
  where origen = 'PDM'
  and status = 'E'  
  group by Num_Serie) x
  on pdm.Num_Serie = x.num_serie
  and pdm.Fecha_Registro = x.fecha_registro
  and substring(pdm.Num_Serie,1,7) = '4857544'
  and pdm.Num_Serie not in (select num_serie from monitor_control_onts where tipo = 'E')) onts  
  where onts.existe_olt = 'S') mon
  on reg.Ip_Olt = mon.ip_olt
  and reg.Num_Serie = mon.num_serie
  and status = 'E'
  set reg.Status = 'T', 
     observaciones= 'Se integro al Mnitoreo';
     
     
  
  
  select *
  from monitor_control_onts
  where tipo = 'E'
    and Num_Serie = '48575443AD840B9E'
    
    select *
    from inventario_olts
    where Ip_Olt = '10.180.214.38'
    
    select *
    from inventario_onts
    where Ip_Olt = '10.180.214.38'
    and serial = '48575443AD840B9E'
    
    4194403072	6
    
    select *
    from inventario_ifindex
    where Ip_Olt = '10.180.214.38'        
    and ObjectId = 4194403072
  
  update registra_nuevas_onts
    set Status = 'T'
  where Num_Serie = ''
  
  update registra_nuevas_onts
    set Status = 'T'
  where Num_Serie = ''
  
select  ont.Ip_Olt,ont.Num_Serie,concat(ifnull(ObjectId,0),'.',ifnull(ontid,0)),ifnull(ObjectId,0),ifnull(OntId,0),ifnull(frame,0),ifnull(slot,0),ifnull(port,0),0,ifnull(Id_Cliente,0),
       ifnull(Nombre_Cliente,'null'),0,ifnull(Vertical,'null'),ifnull(Monitoreo,'S'),
       fecha_registro
from monitor_control_onts ont
join (select  num_serie,  max(ifnull(Fecha_Inc, '2019-10-25 14:58:57')) fecha_registro
from monitor_control_onts
where tipo = 'E'
  group by num_serie) k
 on ont.Num_Serie = k.num_serie
 and ifnull(ont.Fecha_Inc, '2019-10-25 14:58:57') = k.fecha_registro
 and tipo = 'E'
  
 update registra_nuevas_onts x
 join
(select Num_Serie, max(Fecha_Registro) Fecha_Registro
from registra_nuevas_onts
where Status in ('E','V')
group by Num_Serie) y
on x.Num_Serie = y.num_serie
and x.Fecha_Registro = y.fecha_registro
set Status = 'P'
 
 select *
 from registra_nuevas_onts x
 join
(select Num_Serie, max(Fecha_Registro) Fecha_Registro
from registra_nuevas_onts
where Status in ('E','V')
group by Num_Serie) y
on x.Num_Serie = y.num_serie
and x.Fecha_Registro = y.fecha_registro

select *
from registra_nuevas_onts
where Status = 'P'

select *
from inventario_olts
where region = 'REGION_XX'

select count(*)
from registro_poleo_interfaces

select date_format(fecha_poleo, '%Y-%m-%d %H:%i') fecha_poleo, count(*) num_registros
from registro_poleo_interfaces
group by date_format(fecha_poleo, '%Y-%m-%d %H:%i')

select *
  from registro_poleo_interfaces
 where fecha_poleo >= '2020-08-17 20:15:00' 
   and  fecha_poleo < '2020-08-17 20:20:00'


update registra_nuevas_onts
set Status = 'C', Observaciones = 'Dispositivo registrado erroneamente'
where substring(Num_Serie,1,1) = 'P'

update registra_nuevas_onts pdm
join
(select Num_Serie
from monitor_control_onts
where tipo = 'E') mon
on pdm.Num_Serie = mon.num_serie
and Status != 'T'
set Status = 'T', Observaciones = 'Se integro con exito al Monitoreo'

select current_timestamp


select Id_Ont, Ip_Olt, Num_Serie, RunStatus, date_last_RunStatus
from monitor_control_onts
where Num_Serie = '4857544301CA1B70' 

select a.Ip_Olt, serial, a.Fecha_Descubrimiento
from inventario_onts a, inventario_ifindex b
where a.Ip_Olt = b.Ip_Olt 
  and a.ObjectId = b.ObjectId
  and serial = '4857544301CA1B70'
  

snmpget -Oqv -v 3 -u userAGPON17 -l authPriv -a SHA -A accesskey372 -x AES -X securitykey372 -Ir 10.71.5.73 HUAWEI-XPON-MIB::hwGponDeviceOntControlRunStatus.4194346240.5