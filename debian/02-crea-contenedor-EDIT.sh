#!/bin/sh

## modificar
MATERIA="bda"
INICIALES="mqr"
BASE_IMAGE="ol-mqr:1.0"

## verificar que hay una subred para esa materia
if [ "$MATERIA" != "bda" ] && [ "$MATERIA" != "bdd" ]; then
  echo "Error: La materia '$MATERIA' no tiene una subred asignada."
  exit 1
fi

NETWORK_NAME="${MATERIA}_network"
echo "NETWORK_NAME: ${NETWORK_NAME}"

# dirección IP
if [ "$MATERIA" = "bda" ]; then
  IP_DIR="172.22.0.11"
elif [ "$MATERIA" = "bdd" ]; then
  IP_DIR="172.23.0.11"
else
  echo "Error: dirección IP - ni bda ni bdd"
  exit 1
fi

## Volumen nombrado
VOLUME_NAME="v1-${MATERIA}-oradata-${INICIALES}"
echo "VOLUME_NAME: ${VOLUME_NAME}"

# Crear el volumen nombrado
docker volume create "${VOLUME_NAME}"

# Nombre del contenedor
CONTAINER_NAME="c1-${MATERIA}-${INICIALES}"
echo "CONTAINER_NAME: ${CONTAINER_NAME}"

## Nombre de host
HOSTNAME="h1-${MATERIA}-${INICIALES}.fi.unam"
echo "HOSTNAME: ${HOSTNAME}"

# Verificar UNAM_HOME
if [ -z "$UNAM_HOME" ]; then
  echo "Error: La variable UNAM_HOME no está definida."
  exit 1
fi
echo "UNAM_HOME: ${UNAM_HOME}"

## Crear el contenedor
docker run -it \
  -v "${UNAM_HOME}:/unam" \
  -v "${VOLUME_NAME}:/opt/oracle/oradata" \
  --name "${CONTAINER_NAME}" \
  --hostname "${HOSTNAME}" \
  --network "${NETWORK_NAME}" \
  --ip "${IP_DIR}" \
  --expose 1521 \
  --shm-size=2gb \
  "${BASE_IMAGE}" bash
