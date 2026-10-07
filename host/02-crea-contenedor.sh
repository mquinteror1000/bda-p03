#!/bin/sh
## modificar
MATERIA="bda"
INICIALES="agn"
BASE_IMAGE="ol-agn:1.0"

NETWORK_NAME="${MATERIA}_network"
if ! docker network inspect "${NETWORK_NAME}" >/dev/null 2>&1; then
  echo "[docker] La red '${NETWORK_NAME}' no existe. Por favor, créala antes de ejecutar el script."
  exit 1
fi

IP_DIR="172.22.0.11"   ## 11 para practica 3

## Volumen nombrado
VOLUME_NAME="v1-${MATERIA}-oradata-${INICIALES}"


# Verifica si el volumen existe antes de crearlo para no borrar datos
if docker volume inspect "${VOLUME_NAME}" >/dev/null 2>&1; then
  echo "[docker] El volumen '${VOLUME_NAME}' ya existe. Borrar manualmente si no se quiere usar"
else
  docker volume create "${VOLUME_NAME}"
fi

CONTAINER_NAME="c1-${MATERIA}-${INICIALES}"
HOSTNAME="h1-${MATERIA}-${INICIALES}.fi.unam"

# Verificar UNAM_HOME
if [ -z "$UNAM_HOME" ]; then
  echo "Error: La variable UNAM_HOME no está definida."
  exit 1
fi

if docker container inspect "$CONTAINER_NAME" > /dev/null 2>&1; then
    echo "[docker] ya existe $CONTAINER_NAME eliminalo manualmente"
    exit 1
fi

## Crear el contenedor
docker run -it \
  -v "${UNAM_HOME}:/unam" \
  -v "${VOLUME_NAME}:/opt/oracle/oradata" \
  --name "${CONTAINER_NAME}" \
  --hostname "${HOSTNAME}" \
  --network "${NETWORK_NAME}" \
  --ip "${IP_DIR}" \
  -p 1521:1521 \
  --shm-size=2gb \
  "${BASE_IMAGE}" bash
