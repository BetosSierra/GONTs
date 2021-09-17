 insert into monitor_control_onts (ip_olt, num_serie, Id_Cliente,Nombre_Cliente, Vertical, Fecha_Inc,tipo,status,Monitoreo) 
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