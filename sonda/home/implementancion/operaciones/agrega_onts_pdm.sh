#!/bin/bash

SCRIPT_SOURCE="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
. "$SCRIPT_SOURCE/config.sh"

cd /home/implementacion/desarrollo/

mysql -h $MAP_IP -P $MAP_PUERTO -u $MAP_USUARIO -p$MAP_CONTRASENA $MAP_BD < procesa_onts_pdm.sql >> onts_pdm.txt

  