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