<?php  
    $ip  = $argv[1];
    $log = fopen("/home/implementacion/scripts-sh/out/descubrimiento.log", "a+");
    $desOnt = fopen("/home/implementacion/scripts-sh/out/descubrimiento.csv", "a+");
    error_reporting(E_ALL && ~(E_NOTICE & E_WARNING));
    fwrite($log, "[INFO] Procesando la OLT : ".$ip. "\n");
    $array = snmp3_real_walk($ip, 'userAGPON17', 'authPriv', 'SHA', 'accesskey372', 'AES', 'securitykey372', 'HUAWEI-XPON-MIB::hwGponDeviceOntSn');
    if (!empty($array))
       {
           $key = array_keys($array);
           foreach ($key as $id => $valor) 
               {
                   $oid = trim(str_replace("HUAWEI-XPON-MIB::hwGponDeviceOntSn.", "", $valor));
	                 $serial = "";
                   if (substr_count($array[$valor], "Hex-STRING: ") > 0) 
                       {
              	           $serial = str_replace("Hex-STRING: ", "", $array[$valor]);
		                       $serial = str_replace(' ', '', $serial);
                       }  
                   else 
                       {
	    	                   $serial = str_replace("STRING: ", "", $array[$valor]);
	                         $serial = ltrim($serial, '"');
		                       $serial = rtrim($serial, '"');
		                       $serial = strtoupper(bin2hex(stripslashes($serial)));
                       } 
	                 $serial = trim($serial);   
                   $objid = substr($oid,0,strpos($oid,"."));
                   $ontid = substr($oid, strpos($oid,".")+1);                                
                   $linea = "$ip,$serial,$oid,$objid,$ontid";
                   fwrite($desOnt, $linea."\n");                       
               }
       }  
       else
       {
        fwrite($log, "[WARN] No se logró alcanzar la OLT : ".$ip. "\n");
       } 
    fclose($log);
?>
