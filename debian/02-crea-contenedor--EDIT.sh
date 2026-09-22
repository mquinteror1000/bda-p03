#!/bin/bash

## modificar
MATERIA="bda"
INICIALES="mqr"
BASE_IMAGE="ol-mqr:1.0"

## verificar que hay un subred para esa materia

if [ "$MATERIA" != "bda" ] && [ "$MATERIA" != "bdd" ]; then
  echo "Error: La materia '$MATERIA' no tiene una subred asignada."
  exit 1
fi

NETWORK_NAME="${MATERIA}_network"
echo "NETWORK_NAME:${NETWORK_NAME}"

# direccion ip
if [ "$MATERIA" = "bda" ]; then
	IP_DIR="172.22.0.11"
elif [ "MATERIA" = "bdd" ]; then
	IP_DIR="172.23.0.11"
else
	echo "direccion: ni bda ni bdd exit"
	exit 1
fi

##Volumen nombrado
VOLUME_NAME="v1-${MATERIA}-oradata-${INICIALES}"
echo "VOLUME_NAME: ${VOLUME_NAME}"
#crear el volumen nombrado
docker volume create ${VOLUME_NAME}

# nombre del contenedor
CONTAINER_NAME="c1-${MATERIA}-${INICIALES}"
echo "CONTAINER_NAME: ${CONTAINER_NAME}"

## nombre de host
HOSTNAME="h1-${MATERIA}-${INICIALES}.fi.unam"
echo "HOSTNAME: ${HOSTNAME}"

# valorde $UNAM
echo "UNAM_HOME: ${UNAM_HOME}"


## Crear el contenedor

docker run -i -t \
-v ${UNAM_HOME}:/unam \
-v ${VOLUME_NAME}:/opt/oracle/oradata \
--name ${CONTAINER_NAME} \
--hostname ${HOSTNAME} \
--network ${NETWORK_NAME}--ip ${IP_DIR} \
--expose 1521 \
--shm-size=2gb \
${BASE_IMAGE} bash


