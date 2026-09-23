#!/bin/sh

# cargar variables de entorno
. /etc/profile.d/99-custom-env.sh
echo "verificar si con sudo puedo acceder a las varianbles de entorno"

echo "UNAM_HOME: ${UNAM_HOME}"
echo "ORACLE_HOME: ${ORACLE_HOME}"
