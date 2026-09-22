#!/bin/bash

## modificar
NETWORK_NAME="bda_network"
MATERIA="bda"


if [ "$MATERIA" = "bda" ]; then
  SUBNET="172.22.0.0/16"
elif [ "$MATERIA" = "bdd" ]; then
  SUBNET="172.23.0.0/16"
else
  echo "Error: La materia '$MATERIA' no tiene una subred asignada."
  exit 1
fi

# si no existe la red, la crea 
if docker network inspect "$NETWORK_NAME" >/dev/null 2>&1; then
  echo "La red '$NETWORK_NAME' ya existe."
else
  echo "La red '$NETWORK_NAME' no existe. Creándola..."
  docker network create --subnet "$SUBNET" "$NETWORK_NAME"
  echo "Red '$NETWORK_NAME' creada exitosamente."
fi

docker network list 
