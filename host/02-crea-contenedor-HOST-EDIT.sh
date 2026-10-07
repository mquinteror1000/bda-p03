#!/bin/sh
#EDITAR
MATERIA='bda'
INICIALES='mqr'
BASE_IMAGE='ol-mqr:1.0'

NETWORK_NAME="${MATERIA}_network"

IP_DIR="172.22.0.11"

VOLUME_NAME="v1-${MATERIA}-oradata-${INICIALES}"

# Verifica si el volumen existe antes de crearlo para no borrar datos
if podman volume inspect "${VOLUME_NAME}" >/dev/null 2>&1; then
  echo "[podaman] El volumen '${VOLUME_NAME}' ya existe. Borrar manualmente si no se quiere usar"
else
  podman volume create "${VOLUME_NAME}"
fi

CONTAINER_NAME="c1-${MATERIA}-${INICIALES}"

HOSTNAME="h1-${MATERIA}-${INICIALES}.fi.unam"

# Verificar UNAM_HOME
if [ -z "$UNAM_HOME" ]; then
  echo "Error: La variable UNAM_HOME no está definida."
  exit 1
fi

if podman container inspect "$CONTAINER_NAME" > /dev/null 2>&1; then
    echo "[podman] ya existe $CONTAINER_NAME eliminalo manualmente"
    exit 1
fi

## Crear el contenedor
podman run -it \
  --userns=keep-id \
  -v "${UNAM_HOME}:/unam" \
  -v "${VOLUME_NAME}:/opt/oracle/oradata" \
  --name "${CONTAINER_NAME}" \
  --hostname "${HOSTNAME}" \
  --network "${NETWORK_NAME}" \
  --ip "${IP_DIR}" \
  -p 1522:1521 \
  --shm-size=2gb \
  "${BASE_IMAGE}" bash
