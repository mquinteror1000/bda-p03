#!/bin/sh

# cargar variables de entorno
. /etc/profile.d/99-custom-env.sh
#editar
PDBNAME="mqrbda"
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
echo "==> Usuario verificado. Iniciando creación de la CDB..."

echo "-numberOfPDBs ${NUMBEROFPDBS} \""
echo "-pdbName ${PDBNAME} \""

