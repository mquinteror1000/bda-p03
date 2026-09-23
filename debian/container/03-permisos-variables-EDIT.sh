#!/bin/sh

## modificar
MATERIA="bda"
INICIALES="mqr"
BASE_IMAGE="ol-mqr:1.0"
ORACLE_VERSION="23ai"
ORACLE_SID="free"
UNAM_HOME="/unam"

# Verificar que el script se este ejecutando con privilegios de root
if [ "$(id -u)" -ne 0 ]; then
    echo "Alto. este script debe ejecutarse con privilegios de sudo"
    echo "Ejecutar así: sudo sh $0"
    exit 1
fi

## verificar que hay una subred para esa materia
if [ "$MATERIA" != "bda" ] && [ "$MATERIA" != "bdd" ]; then
  echo "Error: La materia '$MATERIA' no tiene una subred asignada."
  exit 1
fi


# Nombre del contenedor
CONTAINER_NAME="c1-${MATERIA}-${INICIALES}"
echo "CONTAINER_NAME: ${CONTAINER_NAME}"

## Nombre de host
HOSTNAME="h1-${MATERIA}-${INICIALES}.fi.unam"
echo "HOSTNAME: ${HOSTNAME}"


## verificar o cambiar permisos de /opt/oracle/oradata

ORADATA_DIR="/opt/oracle/oradata"

if [ -d "$ORADATA_DIR" ]; then
    if [ "\((stat -c '%U:%G' "\)ORADATA_DIR")" != "oracle:oinstall" ]; then
        echo "Cambiando dueño y grupo de $ORADATA_DIR a oracle:oinstall..."
        sudo chown -R oracle:oinstall "$ORADATA_DIR"
    else
        echo "El directorio $ORADATA_DIR ya pertenece a oracle:oinstall. Continuando..."
    fi
else
    echo "Error: El directorio $ORADATA_DIR no existe."
    exit 1
fi


## Modificar /etc/profile.d/99-custom-env
UNAM_HOME="/unam"
ORACLE_HOSTNAME=${CONTAINER_NAME}
ORACLE_BASE=/opt/oracle
ORACLE_HOME=${ORACLE_BASE}/product/${ORACLE_VERSION}/dbhomeFree
ORA_INVENTORY=${ORACLE_BASE}/oraInventory
ORACLE_SID=${ORACLE_SID}
NLS_LANG=American_America.AL32UTF8


cat > archivo.txt << EOF
export UNAM_HOME=${UNAM_HOME}
export ORACLE_HOSTNAME=${CONTAINER_NAME}
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/${ORACLE_VERSION}/dbhomeFree
export ORA_INVENTORY=${ORACLE_BASE}/oraInventory
export ORACLE_SID=${ORACLE_SID}
export NLS_LANG=American_America.AL32UTF8
export PATH=${ORACLE_HOME}/bin:\$PATH
export LD_LIBRARY_PATH=\${ORACLE_HOME}/lib:\${LD_LIBRARY_PATH}
EOF

