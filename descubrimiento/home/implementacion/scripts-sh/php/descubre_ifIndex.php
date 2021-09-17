<?php  
    $ip  = $argv[1];
    $log = fopen("/home/implementacion/scripts-sh/out/descubrimiento.log", "a+");
    $desIndx = fopen("/home/implementacion/scripts-sh/out/indexonts.csv", "a+");
    error_reporting(E_ALL && ~(E_NOTICE & E_WARNING));
    fwrite($log, "[INFO] Procesando la OLT : ".$ip. "\n");
    $array = snmp3_real_walk($ip, 'userAGPON17', 'authPriv', 'SHA', 'accesskey372', 'AES', 'securitykey372', '.1.3.6.1.2.1.31.1.1.1.1');
    if (!empty($array))
       {
           $key = array_keys($array);
           foreach ($key as $id => $valor) 
              {
                 if (substr_count($array[$valor], "STRING: GPON ") > 0) 
                    {  
                       $objId = 0;   
                       $objId = str_replace("IF-MIB::ifName.", "", $valor);
	                     $salida = "";
              	       $salida = str_replace("STRING: GPON ", "", $array[$valor]);
                       $cont = strlen(trim($salida));
                       if (strlen(trim($salida)) > 0 )
                           {
		                           $salida = str_replace(' ', '', $salida);
                               $slot = trim(substr($salida, 0, strpos($salida, '/')));
                               $frame = trim(substr(trim(substr($salida, strpos($salida, '/')+1)), 0, strpos(trim(substr($salida, strpos($salida, '/')+1)), '/')));
                               $port = trim(substr(trim(substr($salida, strpos($salida, '/')+1)), strpos(trim(substr($salida, strpos($salida, '/')+1)), '/')+1)); 
                           }
                       else
                           {
                               echo "entra"."\n";
                               $objId = 0;
                               $slot = 0;
                               $frame = 0;
                               $port = 0;
                           }
                              $linea = "$ip,$objId,$slot,$frame,$port";
                              fwrite($desIndx, $linea."\n");                            
                    }
              }  
       }  
       else
       {
        fwrite($log, "[WARN] No se logró alcanzar la OLT : ".$ip. "\n");
       } 
    fclose($log);
?>
