# bda-p03

Práctica 03 de BDA

## Objetivo:

Conocer y poner en práctica las actividades requeridas para crear una base de datos contenedora (CDB) con al menos una pluggable database (PDB).

#### Novedades

**Uso de Volúmenes nombrados**

Se usarán para guardar los archivos de la base de datos **(datafiles, redo logs y control files)**. Con esto se conseguirán: imágenes de docker mas pequeñas y permitirá reutilizarlos entre contenedores.

- Bind Mount: **-v ${UNAM_HOME}:/unam**

- Volumen nombrado: **-v v1-oradata-...:/opt/oracle/oradata**

#### Volúmenes nombrados

| materia | iniciales | volumen         | punto de montaje(container) | En el host                                       |
| ------- | --------- | --------------- | --------------------------- | ------------------------------------------------ |
| bda     | mqr       | bda-oradata-mqr | /opt/oracle/oradata         | /var/lib/docker/volumes/v1-bda-oradata-mqr/_data |
| bda     | mqr       | bdd-oradata-mqr | /opt/oracle/oradata         | /var/lib/docker/volumes/v1-bda-oradata-mqr/_data |

#### RED

| materia | iniciales | contenedor | network     | subnet        | dirección   | puerto publicado |
| ------- | --------- | ---------- | ----------- | ------------- | ----------- | ---------------- |
| bda     | mqr       | c1-bda-mqr | bda_network | 172.22.0.0/16 | 172.22.0.11 | 1522:1521        |
| bda     | mqr       | c1-bda-mqr | bdd_network | 172.23.0.0/16 | 172.22.0.11 | 1523:1521        |

Editar **/unam/bda/practicas/03/debian/01-crea-red-docker-EDIT.sh**

```bash
## modificar
MATERIA="bda"
INICIALES="mqr"
BASE_IMAGE="ol-mqr:1.0"
```

ejecutar **/unam/bda/practicas/03/debian/01-crea-red-docker-EDIT.sh**

```shellsession
martin@pc-bda-mqr:/unam/bda/practicas/03/debian$ sh 01-crea-red-docker-EDIT.sh 
La red 'bda_network' no existe. Creándola...
8b63fbd100d9c81e45e7887aef4ccf96f4282c7f94c863d29f228c94acc23113
Red 'bda_network' creada exitosamente.
NETWORK ID     NAME          DRIVER    SCOPE
8b63fbd100d9   bda_network   bridge    local
4cc6ace72434   bridge        bridge    local
84c99b0c8c8f   host          host      local
8183d308cccf   none          null      local
```

### Crear el contenedor

editar **/unam/bda/practicas/03/debian/02-crea-contenedor-EDIT.sh**

```bash
## modificar
MATERIA="bda"
INICIALES="mqr"
BASE_IMAGE="ol-mqr:1.0"
```

ejecutar **/unam/bda/practicas/03/debian/02-crea-contenedor-EDIT.sh**

```shellsession
martin@pc-bda-mqr:/unam/bda/practicas/03/debian$ sh 02-crea-contenedor-EDIT.sh 
NETWORK_NAME: bda_network
VOLUME_NAME: v1-bda-oradata-mqr
v1-bda-oradata-mqr
CONTAINER_NAME: c1-bda-mqr
HOSTNAME: h1-bda-mqr.fi.unam
UNAM_HOME: /unam
bash-5.1#
```

Si todo esta correcto entrega una shell del nuevo contenedor. SAlir de este

#### Agregar los alias de acceso rápido al contenedor

agregar en .bashrc el usuario **/home/martin/.bashrc**

```bash
alias dockerBda1='docker start c1-bda-mqr && docker attach c1-bda-mqr'​
alias dockerBda1T='docker exec -it c1-bda-mqr bash'
```

probar

```shellsession
martin@pc-bda-mqr:~$ su -l martin
Password:
martin@pc-bda-mqr:~$ dockerBda1
c1-bda-mqr
bash-5.1# ls /unam/
bda  bdd
```

## Configurar contenedor

#### Variables de entorno y propietario de oradata

modificar **/unam/bda/practicas/03/debian/container/03-permisos-variables-EDIT.sh**

```bash
## modificar
MATERIA="bda"
INICIALES="mqr"
ORACLE_VERSION="23ai"
ORACLE_SID="free"
UNAM_HOME="/unam"
```

Ejecutar **/unam/bda/practicas/03/debian/container/03-permisos-variables-EDIT.sh**

```shellsession
[martin@h1-bda-mqr container]$ sudo sh 03-permisos-variables-EDIT.sh 
CONTAINER_NAME: c1-bda-mqr
HOSTNAME: h1-bda-mqr.fi.unam
El directorio /opt/oracle/oradata ya pertenece a oracle:oinstall. Continuando...
Contenido actual de /etc/profile.d/99-custom-env.sh

# Variables de entorno Oracle - generadas automáticamente
export UNAM_HOME=/unam
export ORACLE_HOSTNAME=c1-bda-mqr
export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/23ai/dbhomeFree
export ORA_INVENTORY=/opt/oracle/oraInventory
export ORACLE_SID=free
export NLS_LANG=American_America.AL32UTF8
export PATH=${ORACLE_HOME}/bin:$PATH
export LD_LIBRARY_PATH=${ORACLE_HOME}/lib:${LD_LIBRARY_PATH}
```

#### Crear un listener modo no interactivo

Modificar el script **/unam/bda/practicas/03/debian/container/04-crea-listener-EDIT.sh**

```bash
# editar
ASIGNATURA="bda"
```

Cambiar al usuario **oracle** con **su -l oracle** y  ejecutar el script  **/unam/bda/practicas/03/debian/container/04-crea-listener-EDIT.sh**

```shellsession

[martin@h1-bda-mqr container]$ su -l oracle
Password: 
Last login: Tue Sep 22 19:55:40 CST 2026 on pts/1
[oracle@h1-bda-mqr ~]$ cd /unam/bda/practicas/03/debian/container/
[oracle@h1-bda-mqr container]$ sh 04-crea-listener-EDIT.sh 
==> Creando listener de Oracle en modo silencioso
==> Verificando que el usuario actual sea 'oracle'...
==> Verificando la existencia del archivo de respuestas /unam/bda/practicas/03/debian/container/listener_silet.rsp...
==> Creando listener con archivo de respuestas /unam/bda/practicas/03/debian/container/listener_silet.rsp
[...]
==> Verificando el status del listener...
[...]
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=h1-bda-mqr.fi.unam)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
The listener supports no services
The command completed successfully
==> Listener creado y en ejecución correctamente.


```

#### Crear una CDB modo no interactivo

editar el script **/unam/bda/practicas/03/debian/container/05-crea-cdb-silent-oracle-EDIT.sh**

```bash
#editar
PDBNAME="mqrbda"
NUMBEROFPDBS=1
```

ejecutar el script **/unam/bda/practicas/03/debian/container/05-crea-cdb-silent-oracle-EDIT.sh**

```shellsession
[oracle@h1-bda-mqr container]$ sh 05-crea-cdb-silent-oracle-EDIT.sh 
==> Creando CDB Oracle Free en modo silencioso
==> Verificando que el usuario actual sea 'oracle'...
==> Usuario verificado. Iniciando creación de la CDB...
[...]
32% complete
36% complete
39% complete
42% complete
[...]
Look at the log file "/opt/oracle/cfgtoollogs/dbca/free/free.log" for further details.
==> CDB Oracle Free creada correctamente.
```

que emoción, vamos a ver si funciona

```shellsession
[oracle@h1-bda-mqr container]$ export ORACLE_SID=free
[oracle@h1-bda-mqr container]$ sqlplus / as sysdba

SQL*Plus: Release 23.0.0.0.0 - Production on Wed Sep 23 20:08:43 2026
Version 23.8.0.25.04

Copyright (c) 1982, 2025, Oracle.  All rights reserved.


Connected to:
Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.8.0.25.04

SQL> show con_name;

CON_NAME
------------------------------
CDB$ROOT

```

podemos continuar
