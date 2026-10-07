#!/bin/sh

# cargar variables de entorno
. /etc/profile.d/99-custom-env.sh
#editar
PDBNAME="mqrbda_s1"
NUMBEROFPDBS=1
# si fuera bdd
#NUMBEROFPDBS=2
#PDBNAME="mqrbdd_s"

echo "==> Creando CDB Oracle Free en modo silencioso"
echo "==> Verificando que el usuario actual sea 'oracle'..."


if [ "$(whoami)" != "oracle" ]; then
echo "Error: este script debe ejecutarse como usuario 'oracle'."
exit 1
fi

## revisar que no exista ya la CDB
SID="free"
DB_EXISTS=0

# 1. ¿Hay un proceso pmon del SID?
if pgrep -f "ora_pmon_${SID}" > /dev/null 2>&1; then
  DB_EXISTS=1
fi

# 2. ¿Existe el directorio de datafiles típico?
if [ -d "${DATAFILE_DEST}/FREE" ] || [ -d "${DATAFILE_DEST}/${SID}" ]; then
  DB_EXISTS=1
fi


echo "==> Usuario verificado. Iniciando creación de la CDB..."
dbca -silent -createDatabase \
-gdbName free.fi.unam \
-sid free \
-templateName FREE_Database.dbc \
-sysPassword system1 \
-systemPassword system1 \
-pdbAdminPassword system1 \
-datafileDestination /opt/oracle/oradata \
-characterSet AL32UTF8 \
-nationalCharacterSet AL16UTF16 \
-totalMemory 1024 \
-createAsContainerDatabase true \
-numberOfPDBs ${NUMBEROFPDBS} \
-pdbName ${PDBNAME} \
-emConfiguration NONE

if [ $? -eq 0 ]; then
echo "==> CDB Oracle Free creada correctamente."
else
echo "Error: no se pudo crear la CDB."
exit 1
fi
