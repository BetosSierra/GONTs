#!/bin/bash
SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

if [ -z "$1" ]; then
  echo "El primer parametro no puede ser nulo, debe enviar el tipo de dispositivo ROUTER, RADIOBASE u ONT"
elif [ -z "$2" ]; then
  echo "El segundo parametro no puede ser nulo, para los dispositivo ROUTER y RADIOBASE se requiere la Ip, para ONT el numero de serie"
else
   if [ "$1" == "ROUTER" ] || [ "$1" == "RADIOBASE" ] || [ "$1" == "ONT" ]; then
      up="update tb_dispositivos set activo = 0 where "
      if [ "$1" == "ROUTER" ] || [ "$1" == "RADIOBASE" ]; then
         sqlup=$up"ip_network='"$2"'"
      elif [ "$1" == "ONT" ]; then
         sqlup=$up"numero_serie='"$2"'"
      fi
      echo $sqlup | mysql -h $PDM_IP -P $PDM_PUERTO -u $PDM_USUARIO -p$PDM_CONTRASENA $PDM_BD;
      echo ""
      echo "Se inactivo el dispositivo"
      echo ""
   else
      echo "El tipo de dispositivo es incorrecto, debe enviar el tipo de dispositivo ROUTER, RADIOBASE u ONT"
   fi
fi
