<?php      
    require_once 'monitorOnts.php';
    error_reporting(E_ALL && ~(E_NOTICE & E_WARNING));
    $log = fopen("/home/implementacion/scripts-sh/out/descubrimiento.log", "a+");
    $arch = fopen("/home/implementacion/scripts-sh/out/inventarioOlts.csv", "w");
    $conn= new mysqli($servername, $username, $password, $dbname, $portname);
    $sqlOlts = " Select Distinct Ip_Olt From inventario_olts Order by Ip_Olt ";

    if ($nres = $conn->query($sqlOlts))
       {
          while ($nregs = $nres->fetch_assoc()) 
              {   
                  $linea =  $nregs['Ip_Olt'];
                  fwrite($arch, $linea."\n");                                        
              }
          fwrite($log, "[".date('d-m-Y H:i:s')."]"."[INFO]"." Se obtuvo la informacion de las OLTS con exito"."\n");
       }
    else
       {          
          fwrite($log, "[".date('d-m-Y H:i:s')."]"."[ERROR]"." No se pudo obtener la informacion de las OLTS "."->".mysqli_error($conn)."\n");
       }
    $conn->close();
    fclose($arch);
    fclose($log);    
?>