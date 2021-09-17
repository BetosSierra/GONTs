<?php
  require_once 'monitorOnts.php';
  $vRegion = $argv[1];
  $inicio = date ('Y-m-d- H:i:s');
  echo "Inicia proceso: ". $inicio . "\n";    
  $conn = new mysqli ($servername, $username, $password, $dbname, $portname);
  if (mysqli_connect_errno()) 
      {
        echo "Error en la conexion a la base de Monitoreo de ONTs: " . mysqli_connect_error() . "\n";
        exit;
    	}     
   $sqlTmpTabla = "CREATE TEMPORARY TABLE tmp_Metrica_".$vRegion." (
                   id_ont int(11),
                   metrica varchar(255),
                   valor_ant varchar(255),
                   valor_act varchar(255),
                   fecha_poleo datetime,
                   primary key(id_ont))";
    if (mysqli_query($conn, $sqlTmpTabla)) 
        {
          $sqlInserta = "Insert into tmp_Metrica_".$vRegion." (id_ont, metrica, valor_ant)
                   select id_ont, 
                   Concat('snmpget -Oqv -v 3 -u userAGPON17 -l authPriv -a SHA -A accesskey372 -x AES -X securitykey372 -Ir ',ip_olt,' ',
                   (select Valor_Oid from cat_metricas where id_metrica = 4 and status = 'A'), ObjectId,'.',OntId) Metrica,
                   Cpu
                   from monitor_control_onts ont
                   where tipo = 'E'
                   and ip_olt in (
	                 select ip_olt
                  from inventario_olts
                  Where region = '".$vRegion."')";
            if (mysqli_query($conn, $sqlInserta)) 
               {
                  $sqlOnts = "Select id_ont, metrica,valor_ant  from tmp_Metrica_".$vRegion;
                  if ($resOnts = $conn->query($sqlOnts))
                     {                           
                        while ($onts = $resOnts->fetch_array())
                           {
                             $val_metrica = shell_exec($onts['metrica']);
                             if (!(empty($val_metrica)))
                                {
                                   $val_metrica = trim($val_metrica);
                                }
                             else
                                {
                                   $val_metrica = 0;
                                }
                              $ActMon = "Update monitor_control_onts ".
                                        " set cpu = '".$val_metrica."', ".
                                        " date_last_cpu = current_timestamp ". 
                                        " Where Id_Ont = ".$onts['id_ont'];                                                            
                              if (!(mysqli_query($conn, $ActMon))) 
                                 {
                                    echo "Error al actualizar la tabla temporal para el Id_Ont : ".$onts['id_ont']."-> ". $ActMon  . mysqli_error($conn)."\n";
                                 }
                              $InsMet = "Insert Into historico_metricas (id_metrica, id_ont, valor_numerico, fecha_poleo) values (".
                                        " 4, ".$onts['id_ont'].", '".$val_metrica."', current_timestamp)";
                              if (!(mysqli_query($conn, $InsMet))) 
                                 {
                                    echo "Error al insertar en la tabla historica de metricas para el Id_Ont : ".$onts['id_ont']."-> ". $InsMet  . mysqli_error($conn)."\n";
                                 }
                           }
                     }                 
               }
            else
               {
                   echo "Error No se creo la tabla temporal: " . $sqlAlcanza  . mysqli_error($conn)."\n";
               }                  
        } 
    else 
       {
           echo "Error No se creo la tabla temporal: " . $sqlAlcanza . mysqli_error($conn)."\n";
       }
   $fin = date ('Y-m-d- H:i:s');
   echo "Fin proceso: ". $fin . "\n";
   $conn->close(); 
 ?>