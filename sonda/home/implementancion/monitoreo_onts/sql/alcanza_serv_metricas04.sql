Select
      Concat("FECHA_CORTE:", date_format(current_timestamp, '%d/%m/%Y %H:%i:%S'),
      "|SERVIDOR:",
      case
          when inv.region in ('REGION_04', 'REGION_05')  then
               '10.180.199.82'
          when inv.region in ('REGION_06', 'REGION_07') then
               '10.180.199.94'
          when inv.region in ('REGION_03', 'REGION_09DF01') then
               '10.180.199.227'
          when inv.region in ('REGION_02', 'REGION_09DF02') then
               '10.180.199.68'
          when inv.region in ('REGION_09DF03') then
               '10.180.199.69'
          when inv.region in ('REGION_01','REGION_08')  then
               '10.180.199.79'
          end,
      "|REGION:", inv.region, "|METRICA:", nom_metrica, "|NUMERO DE ONTS:", Num_Onts,
      "|NUMERO DE POLEOS:", Num_poleos, "|DIFERENCIA:", Num_Onts - Num_poleos) Salida
from
  (select olt.region, nom_metrica,
          count(distinct his.id_ont) num_poleos
from historico_metricas his, cat_metricas cat, monitor_control_onts mon, inventario_olts olt
where his.Id_Metrica = cat.Id_Metrica
    and his.Id_Ont = mon.Id_Ont
    and mon.Ip_Olt = olt.Ip_Olt
    and cat.Id_Metrica = 1
    and Fecha_Poleo  >= current_timestamp - INTERVAL 5 minute
  group by olt.region, nom_metrica) poleo,
(select b.region, count(a.Num_Serie) Num_Onts
from monitor_control_onts a, inventario_olts b
where a.Ip_Olt = b.Ip_Olt
  and tipo = 'E'
group by b.region) inv
where poleo.region = inv.region
  and inv.region in ('REGION_09DF03')  
union
select
      Concat("FECHA_CORTE:", date_format(current_timestamp, '%d/%m/%Y %H:%i:%S'),
      "|SERVIDOR:",
      case
          when inv.region in ('REGION_04', 'REGION_05')  then
               '10.180.199.82'
          when inv.region in ('REGION_06', 'REGION_07') then
               '10.180.199.94'
          when inv.region in ('REGION_03', 'REGION_09DF01') then
               '10.180.199.227'
          when inv.region in ('REGION_02', 'REGION_09DF02') then
               '10.180.199.68'
          when inv.region in ('REGION_09DF03') then
               '10.180.199.69'
          when inv.region in ('REGION_01','REGION_08')  then
               '10.180.199.79'
          end,
      "|REGION:", inv.region, "|METRICA:", nom_metrica, "|NUMERO DE ONTS:", Num_Onts,
      "|NUMERO DE POLEOS:", Num_poleos, "|DIFERENCIA:", Num_Onts - Num_poleos) Salida
from
  (select olt.region,
          nom_metrica,
          count(distinct his.id_ont) num_poleos
from historico_metricas his, cat_metricas cat, monitor_control_onts mon, inventario_olts olt
where his.Id_Metrica = cat.Id_Metrica
    and his.Id_Ont = mon.Id_Ont
    and mon.Ip_Olt = olt.Ip_Olt
    and cat.Id_Metrica = 11
    and Fecha_Poleo  >= current_timestamp - interval 5 minute
  group by olt.region, nom_metrica) poleo,
(select b.region, count(a.Num_Serie) Num_Onts
from monitor_control_onts a, inventario_olts b
where a.Ip_Olt = b.Ip_Olt
  and tipo = 'E'
group by b.region) inv
where poleo.region = inv.region
and inv.region in ('REGION_09DF03');