select Concat(
ifnull(TB.FOLIO,'null'),'|',
ifnull(TB.ID_ITSM_CLIENTE,'0'),'|',
ifnull(TB.CLIENTE,'null'),'|',
ifnull(TB.MH_DISPOSITIVO,'null'),'|',
ifnull(CD.NOMBRE_DISPOSITIVO,'null'),'|',
ifnull(TB.MAC_ADDRESS,'null'),'|',
ifnull(TB.IP_NETWORK,'null'),'|',
ifnull(TB.IP_OLT,'null'),'|',
ifnull(TB.NUMERO_SERIE,'null'),'|',
 DATE_FORMAT( TB.FECHA_ALTA, "%Y-%m-%d"),'|',
 TB.FECHA_ALTA,'|',
 U.username,'|',
 ifnull(TB.HOST_NAME,'null'),'|',
 ifnull(TB.COMUNIDAD_SNMP,'null'),'|',
 ifnull(TB.VERSION_SNMP,'null'),'|',
 ifnull(TB.NOMBRE_DISPOSITIVO,'null'),'|',
 ifnull(TB.NUM_CUENTA_CLIENTE,'null'),'|',
 ifnull(TB.NUM_CUENTA_SITIO,'null'),'|',
 ifnull(TB.SEGMENTO_FACTURACION,'null'),'|',
 ifnull(TB.NOMBRE_SITIO,'null'),'|',
ifnull(TB.MENSAJE_CMDB,'null'),'|',
ifnull(TB.MENSAJE_SPECTRUM,'null'),'|',
ifnull(TB.STATUS_ZABBIX_STORED,'null'),'|',
ifnull(TB.MENSAJE_ZABBIX_STORED,'null'),'|',
ifnull(TB.STATUS_CMDB,'null'),'|',
ifnull(TB.STATUS_SPECTRUM,'null'),'|',
ifnull(TB.STATUS_ZABBIX,'null'),'|',
ifnull(TB.STATUS_ZABBIX_STORED,'null'),'|',
ifnull(TB.STATUS_SNMP,'null'),'|',
ifnull(O.NOMBRE,'null'),'|',
ifnull(TB.ACTIVO,'null'),'|',
ifnull(TB.SDWAN,'null'))
from tb_dispositivos TB
left join cat_dispositivos CD on TB.TIPO_DISPOSITIVO = CD.ID_DISPOSITIVO
left join tb_user U on TB.USUARIO_ALTA = U.id
left join tb_origen O on TB.AREA = O.ID_ORIGEN
 where  U.username in ('sdwan')
 and date_format(FECHA_ALTA, '%Y') = '2020'
order by FECHA_ALTA desc;