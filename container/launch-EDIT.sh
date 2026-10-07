#!/bin/bash
# @Descripcion  Utilidad para levantar el listener y la instancia de la CDB del
#               contenedor, verificando el estado antes de intentarlo (idempotente).
#               Ubicación sugerida: / dentro del contenedor. Ejecutar como root; el
#               script hace su - oracle internamente para autenticar por sistema
#               operativo en cada operación.

## -- Este script se llama: start-cdb.sh
#editar
ADMINUSER="martin"

if [ "$(whoami)" != "root" ]; then
  echo "ERROR: este script debe ejecutarse como el usuario root"
  exit 1
fi

echo "Verificando el listener..."
if su - oracle -c "lsnrctl status" >/dev/null 2>&1; then
  echo "El listener ya esta en ejecucion"
else
  echo "Iniciando el listener..."
  su - oracle -c "lsnrctl start"
fi

echo "Verificando el estado de la instancia..."
estado=$(su - oracle -c "sqlplus -s /nolog" <<EOF
connect / as sysdba
set heading off feedback off pagesize 0
select status from v\$instance;
exit
EOF
)
estado=$(echo "${estado}" | tr -d '[:space:]')

if [ "${estado}" = "OPEN" ]; then
  echo "La instancia ya esta abierta (OPEN)"
else
  echo "Iniciando la instancia..."
  su - oracle -c "sqlplus -s /nolog" <<EOF
connect / as sysdba
startup
exit
EOF
fi

echo "Cambiando al usuario admin"
exec su -l ${ADMINUSER}
echo "Listo."
