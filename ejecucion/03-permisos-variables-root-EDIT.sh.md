## 03-permisos-variables-root-EDIT.sh

```shellsession
[martin@h1-bda-mqr container]$ sudo sh 03-permisos-variables-root-EDIT.sh 
[sudo] password for martin: 
CONTAINER_NAME: c1-bda-mqr
HOSTNAME: h1-bda-mqr.fi.unam
Cambiando dueño y grupo de /opt/oracle/oradata a oracle:oinstall...
Permisos actualizados.
Contenido actual de /etc/profile.d/99-custom-env.sh

# Variables de entorno Oracle - generadas automáticamente
export UNAM_HOME=/unam
export ORACLE_HOSTNAME=h1-bda-mqr.fi.unam
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/23ai/dbhomeFree
export ORA_INVENTORY=/opt/oracle/oraInventory
export ORACLE_SID=free
export NLS_LANG=American_America.AL32UTF8
export PATH=${ORACLE_HOME}/bin:$PATH
export LD_LIBRARY_PATH=${ORACLE_HOME}/lib:${LD_LIBRARY_PATH}
```
