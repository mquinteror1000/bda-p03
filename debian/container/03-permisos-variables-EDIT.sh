#!/bin/sh

## modificar
MATERIA="bda"
INICIALES="mqr"
ORACLE_VERSION="23ai"
ORACLE_SID="free"
UNAM_HOME="/unam"

# Verificar que el script se esté ejecutando con privilegios de root
if [ "$(id -u)" -ne 0 ]; then
    echo "Alto. Este script debe ejecutarse con privilegios de sudo"
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

## Verificar o cambiar permisos de /opt/oracle/oradata
ORADATA_DIR="/opt/oracle/oradata"

if [ -d "$ORADATA_DIR" ]; then
    CURRENT_OWNER=$(stat -c '%U:%G' "$ORADATA_DIR")
    if [ "$CURRENT_OWNER" != "oracle:oinstall" ]; then
        echo "Cambiando dueño y grupo de $ORADATA_DIR a oracle:oinstall..."
        chown -R oracle:oinstall "$ORADATA_DIR"
        echo "Permisos actualizados."
    else
        echo "El directorio $ORADATA_DIR ya pertenece a oracle:oinstall. Continuando..."
    fi
else
    echo "Error: El directorio $ORADATA_DIR no existe."
    exit 1
fi

## Crear variables de entorno

ORACLE_BASE="/opt/oracle"
ORACLE_HOME="${ORACLE_BASE}/product/${ORACLE_VERSION}/dbhomeFree"
ORA_INVENTORY="${ORACLE_BASE}/oraInventory"

cat > /etc/profile.d/99-custom-env.sh << EOF
# Variables de entorno Oracle - generadas automáticamente
export UNAM_HOME=${UNAM_HOME}
export ORACLE_HOSTNAME=${CONTAINER_NAME}
export ORACLE_BASE=${ORACLE_BASE}
export ORACLE_HOME=${ORACLE_HOME}
export ORA_INVENTORY=${ORA_INVENTORY}
export ORACLE_SID=${ORACLE_SID}
export NLS_LANG=American_America.AL32UTF8
export PATH=\${ORACLE_HOME}/bin:\$PATH
export LD_LIBRARY_PATH=\${ORACLE_HOME}/lib:\${LD_LIBRARY_PATH}
EOF

echo "Contenido actual de /etc/profile.d/99-custom-env.sh"
echo ""
cat /etc/profile.d/99-custom-env.sh 
