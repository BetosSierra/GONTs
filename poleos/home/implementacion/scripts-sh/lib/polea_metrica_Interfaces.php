<?php
  require_once 'monitorOnts.php';
  $f=trim(shell_exec("echo `date +%Y%m%d%H%M%S`"));
  $archmet = fopen("/home/implementacion/scripts-sh/out/Interfaces_".$f.".out", "a+");
  $archlog = fopen("/home/implementacion/scripts-sh/out/Interfaces_".$f.".log", "a+");
  //$vRegion = $argv[1];
  $d=trim(shell_exec("echo `date +%Y-%m-%d%n%H:%M:%S`"));
  fwrite($archlog, "[".$d."] [INFO] Inicia proceso de colecta para la metrica de Interfaces"."\n");
  $conn = new mysqli ($servername, $username, $password, $dbname, $portname);
  if (mysqli_connect_errno())
      {
        //echo "Error en la conexion a la base de Monitoreo de ONTs: " . mysqli_connect_error() . "\n";
        $d=trim(shell_exec("echo `date +%Y-%m-%d%n%H:%M:%S`"));
        fwrite($archlog, "[".$d."] [ERROR] Error en la conexion a la base de Monitoreo de ONTs: " . mysqli_connect_error() . "\n");
        //exit;
        }
  $sqlOnts = "select b.Region, a.Ip_Olt, a.Num_Serie, Concat(ObjectId,'.',OntId) Oid, ".
             " Concat('snmpbulkwalk -r 1 -t 1 -Ir -v3 -u userAGPON17 -l authPriv -a SHA -A accesskey372 -x AES -X securitykey372 ',a.ip_olt,' ', ".
             " (select Valor_Oid from cat_metricas where id_metrica = 16 and status = 'A'), ObjectId,'.',OntId) Metrica ".
             " from monitor_control_onts a, inventario_olts b ".
             " where a.Ip_Olt = b.Ip_Olt ".
             " and tipo = 'E' ".
             " and nombre_cliente in ('GOBIERNO DEL DISTRITO FEDERAL C5', 'TRIBUNAL FEDERAL DE JUSTICIA FISCAL Y ADMINISTRATIVA')";
  if ($resOnts = $conn->query($sqlOnts))
     {
        $arrSal=array();
        while ($onts = $resOnts->fetch_array())
           {
              $fechapol=trim(shell_exec("echo `date '+%Y-%m-%d %H:%M:%S'`"));
              $metrica = trim(shell_exec($onts['Metrica']));
              $array  =   explode("\n", $metrica);
              if (!empty($array))
                 {
                    for ($i = 0; $i < count($array); $i++)
                       {
                          $tmp = trim(str_replace("HUAWEI-XPON-MIB::hwGponDeviceOntEthernetOnlineState.", "", $array[$i]));
                          $a = strpos($tmp, "=");
                          $oid = trim(substr($tmp,0,$a-1));
                          $b = strpos($oid, ".");
                          $oid = trim(substr($oid,0,$b));
                          $tmp = trim(substr($tmp, $b+1));
                          $b = strpos($tmp, ".");
                          $ontid = trim(substr($tmp,0,$b));
                          $tmp = trim(substr($tmp, $b+1));
                          $a = strpos($tmp, "=");
                          $inter = trim(substr($tmp,0,$a));
                          $tmp = trim(substr($tmp, $a+1));
                          $valor = trim(str_replace("INTEGER: ", "", $tmp));
                          if (empty($inter))
                             {
                                $inter=0;
                                $valor="TimeOut";
                             }
                          array_push($arrSal, array("region" => $onts['Region'],
                                                    "ip" => $onts['Ip_Olt'],
                                                    "serie" => $onts['Num_Serie'],
                                                    "oid" => $onts['Oid'],
                                                    "id_Inter" => $inter,
                                                    "valor_metrica" => $valor,
                                                    "fecha_poleo" => $fechapol));
                       }
                    //var_dump($arrSal);
                   foreach($arrSal as $general => $detalle)
                      {
                         foreach($detalle as $indice => $valor)
                            {
                               switch ($indice)
                                  {
                                     case "region":
                                        $region = $valor;
                                        break;
                                     case "ip":
                                        $ip = $valor;
                                        break;
                                     case "serie":
                                        $serie = $valor;
                                        break;
                                     case "oid":
                                        $oid = $valor;
                                        break;
                                     case "id_Inter":
                                        $id_Inter = $valor;
                                        break;
                                     case "valor_metrica":
                                        $valor_metrica = $valor;
                                        break;
                                     case "fecha_poleo":
                                        $fecha_poleo = $valor;
                                        break;
                                  }
                            }
                         $linea=utf8_encode($region."|".$ip."|".$serie."|".$oid."|".$id_Inter."|".$valor_metrica."|".$fecha_poleo);
                         fwrite($archmet, $linea."\n");
                         $ins="Insert Into registro_poleo_interfaces (Region,Ip_Olt,Num_Serie,Oid,Id_Interfaz,valor,Fecha_Poleo) values ('".
                              $region."','".$ip."','".$serie."','".$oid."',".$id_Inter.",'".$valor_metrica."','".$fecha_poleo."')";
                         if (!(mysqli_query($conn, $ins)))
                            {
                               $fec= trim(shell_exec("echo `date +%Y-%m-%d%n%H:%M:%S`"));
                               fwrite($archlog, "[".$fec."][ERROR] Error insertar las Interfaces en la tabla  registro_poleo_interfaces -> ".$ins.mysqli_error($conn)."\n");
                            }
                      }
                 }
           }
     }
   $fin=trim(shell_exec("echo `date +%Y-%m-%d%n%H:%M:%S`"));
   fwrite($archlog, "[".$fin."] [INFO] Termina proceso de colecta para la metrica de Interfaces"."\n");
$conn->close();