CREATE DEFINER=`root`@`%` PROCEDURE `monitor_onts`.`Sp_Agrega_Onts_Externas`(In  vOrigen     Varchar(255), 
                                                                   In  vIp         Varchar(50),
																   In  vSerie      Varchar(50),
                                                                   In  vIdCliente  BigInt(11),
                                                                   In  vNomCliente Varchar(255),
                                                                   In  vVertical   Varchar(255),
                                                                   Out vExito      Char(1),
                                                                   Out vMensaje    Varchar(255))
BEGIN
   Declare vExiste    Int Default 0;
   Declare vExisteOLT Int Default 0;
   Declare vExisteONT Int Default 0;
   /*Declare vExisteDes Int Default 0;
   Declare vSigue     Boolean Default False;
   Declare vMsj       Varchar(255) default '';
   Declare vEstatus   Char(1) default 'V';*/
   
   /*Select  Count(*) 
     Into vExiste
    From Monitor_Control_Onts
   Where tipo = 'E'
     and Num_Serie = vSerie;
    
    select count(*)
      Into vExisteOLT
     from inventario_olts
     where ip_olt = vIp;
	  
    Select Count(*)
      Into vExisteDes
      from inventario_onts a, inventario_ifindex b
     where a.Ip_Olt = b.Ip_Olt
       and a.ObjectId = b.ObjectId
       and a.Serial = vSerie;
          
   if  vExiste > 0 then	   
       Set vMsj = 'La ONT ya se encuentra en Monitoreo';
       Set vEstatus = 'T';
   end if;
  
   if  vExisteOLT = 0 then
       Set vMsj = 'La OLT No se encuentra registradas en el Gestor o cambio de Ip';
       Set vEstatus = 'P';
   end if;
  
   if  vExisteDes = 0 then 
       Set vMsj = 'La ONT No se localizo en el descubrimiento, valide OLT y Numero de Serie';
       Set vEstatus = 'P';
   end if;
  
   if vExiste = 0 and vExisteDes > 0 and vExisteOLT > 0 then
      set vSigue = true;
   else
      set vSigue = false;
      Set vExito = 'N';
      Set vMensaje = vMsj; 
      Insert into Registra_Nuevas_Onts (Origen,  Ip_Olt, Num_Serie, Id_Cliente, Nombre_Cliente, Vertical,  Status, Fecha_Registro, observaciones)
                                Values (vOrigen, vIp,    vSerie,    vIdCliente, vNomCliente,    vVertical, vEstatus,    Current_TimeStamp, vMsj);    
   end if;
  
   if vSigue then
          Insert into monitor_control_onts 
             (Ip_Olt,   Num_Serie, ObjectId,  OntId, frame, slot, port, Id_Cliente, Nombre_Cliente,Tipo,Monitoreo,Status,Vertical,Fecha_Inc)
          Select a.Ip_Olt, serial,   a.ObjectId, OntId, frame, slot, port, vIdCliente, vNomCliente,   'E', 'S', 'A',vVertical, Current_TimeStamp
            from inventario_onts a, inventario_ifindex b
           where a.Ip_Olt = b.Ip_Olt
             and a.ObjectId = b.ObjectId
             and a.Serial = vSerie;

 	    Set vExito = 'S';
        Set vMsj = 'Se integro con exito al Monitoreo'; 
        Set vMensaje = vMsj; 
        Insert into Registra_Nuevas_Onts (Origen,  Ip_Olt, Num_Serie, Id_Cliente, Nombre_Cliente, Vertical,  Status, Fecha_Registro, observaciones)
                                  Values (vOrigen, vIp,    vSerie,    vIdCliente, vNomCliente,    vVertical, vEstatus,    Current_TimeStamp, vMsj);
   end if;*/
  Select  Count(*) 
     Into vExiste
    From monitor_control_onts
    where tipo = 'E'
     and num_serie = vSerie;
  if  vExiste > 0 then
      Set vExito = 'S'; 
      Set vMensaje = 'El dispositivo ya existe en Monitoreo';
  else
      Select  Count(*) 
         Into vExisteOLT
         From inventario_olts
        Where ip_olt = vIp;
      if  vExisteOLT = 0 then	 
          insert into inventario_olts(ip_olt, region, Fecha_Registro) values (vIp, 'REGION_XX', current_timestamp);
          commit;
          Set vMensaje = 'Se integro la ONT a Monitoreo, la OLT no se encontro en el Gestor';   
      else
          Set vMensaje = 'Se integro la ONT a Monitoreo';
      end if;  
      Insert into Registra_Nuevas_Onts 
              (Origen,  Ip_Olt, Num_Serie, Id_Cliente, Nombre_Cliente, Vertical,  Status, Fecha_Registro, observaciones)
      values  (vOrigen, vIp,    vSerie,    vIdCliente, vNomCliente,    vVertical, 'P',    Current_TimeStamp, 'Registrado en Gestor de ONTs');
      commit; 
      Set vExito = 'S'; 
     /*Set vExito = 'S'; 
     Set vMensaje = 'Se registro ONT';  
     Insert into monitor_control_onts (Ip_Olt, Num_Serie, Id_Cliente, Nombre_Cliente,Tipo,Monitoreo,Status,Vertical,Fecha_Inc)
     select Ip_Olt, Num_Serie, Id_Cliente,Nombre_Cliente, 'E', 'S', 'A', Vertical, Fecha_Registro  
     from registra_nuevas_onts
     where Num_Serie = vSerie
       and Status = 'P';
      commit;*/
  end if;
END