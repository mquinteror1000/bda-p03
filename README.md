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

De manera **manual**

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

#### Variables de entorno

Se agregan las variables de entorno necesarias en /etc/profile.d/99-custom-env.sh

También se cambia el propietario del folder ${ORACLE_HOME}/oradata

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

Este script crea una CDB con la primera PDB



editar el script **/unam/bda/practicas/03/debian/container/05-crea-cdb-silent-oracle-EDIT.sh**

```bash
#editar
PDBNAME="mqrbda_s1"
NUMBEROFPDBS=1
# si fuera bdd
#NUMBEROFPDBS=2
#PDBNAME="mqrbdd_s"

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

#### En caso de querer eliminar una PDB

ejecutar como oracle

```bash
dbca -silent -deleteDatabase -sourceDB FREE
```

```shellsession
[oracle@h1-bda-mqr container]$ dbca -silent -deleteDatabase -sourceDB FREE
Enter SYS user password: 

[WARNING] [DBT-11503] The instance (FREE) is not running on the local node. This may result in partial delete of Oracle database.
   CAUSE: A locally running instance is required for complete deletion of Oracle database instance and database files.
   ACTION: Specify a locally running database, or execute DBCA on a node where the database instance is running.
[WARNING] [DBT-19202] The Database Configuration Assistant will delete the Oracle instances and datafiles for your database. All information in the database will be destroyed.
Prepare for db operation
32% complete
Connecting to database
[...]
Database deletion completed.
```



## Configuración de alias y tnsnames

Este script

- crea el alias sqlplus='rlwrap sqlplus'

- da de alta el servicio **mqrbda_s1** con el formato <iniciales><materia>s_1

Editar el script **/unam/bda/practicas/03/debian/container/07-alias-tnsnames-root-EDIT.sh**

```bash
# editar
MATERIA="bda"
INICIALES="mqr"
```

ejecutarlo

```shellsession
[martin@h1-bda-mqr container]$ sudo sh 07-alias-tnsnames-root-EDIT.sh 
alias sqlplus='rlwrap sqlplus' ya existe en /etc/profile.d/99-custom-env.sh No se hicieron cambios.
escrito en nombre de servicio [mqrbda_s1] en el archivo /opt/oracle/product/23ai/dbhomeFree/network/admin/tnsnames.ora
ahora se vale conectarse asi sqlplus sys@mqrbda_s1 as sysdba despues de iniciar listener y la cdb
```

## Script para levantar rápido Listener e instancia

Tomado del profesor

editar el script  **/unam/bda/practicas/03/debian/container/launch.sh**

```bash
#editar
ADMINUSER="martin"
```

darle privilegios de ejecución

y con **sudo**  copiarlo/moverlo a **/usr/bin** preferiblemente sin extensión asi **/usr/bin/launch**

```shellsession
[martin@h1-bda-mqr container]$ sudo mv launch.sh /usr/bin/launch
[martin@h1-bda-mqr container]$ chmod +x /usr/bin/launch
```

ahora tras iniciar el contenedor  o loguearnos como root, simplemente

```shellsession
martin@pc-bda-mqr:~$ dockerBda1
c1-bda-mqr
bash-5.1# launch 
Verificando el listener...
Iniciando el listener...
[...]
Verificando el estado de la instancia...
Iniciando la instancia...
ORACLE instance started.

Total System Global Area 1603287928 bytes
Fixed Size		    4922232 bytes
Variable Size		  452984832 bytes
Database Buffers	 1140850688 bytes
Redo Buffers		    4530176 bytes
Database mounted.
Database opened.
Cambiando al usuario admin
Last login: Thu Sep 24 07:52:02 CST 2026 on pts/0
[martin@h1-bda-mqr ~]$ 
```

y podemos acceder a nuestr pdb de manera directa con sqlplus

```shellsession
[martin@h1-bda-mqr ~]$ sqlplus sys/system1@mqrbda_s1 as sysdba

SQL*Plus: Release 23.0.0.0.0 - Production on Thu Sep 24 13:48:07 2026
Version 23.8.0.25.04

Copyright (c) 1982, 2025, Oracle.  All rights reserved.


Connected to:
Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.8.0.25.04

SP2-0734: unknown command beginning "echo "hech..." - rest of line ignored.
Help: https://docs.oracle.com/error-help/db/sp2-0734/
sys@mqrbda_s1> 

```

## Validador

Primer parte en el Host

ejecutar  **/unam/bda/practicas/03/runval01.sh**

```shellsession
[martin@h1-bda-mqr 03]$ sh runval01.sh 
=====================================================================
      Validación de resultados 📋 (Tomar captura desde aquí)
=====================================================================
Fecha ............................. 2026-09-24 13:52:39
Usuario ........................... martin
Hostname .......................... h1-bda-mqr.fi.unam
Asignatura ........................ bda
Semestre .......................... 2027-1
Práctica .......................... 03
=====================================================================


✅ [PASS] 01 - Uso de un contenedor Docker: Uso de un contenedor Docker correcto
✅ [PASS] 02 - Usuario de ejecución distinto a oracle y root: Usuario de ejecución: martin
✅ [PASS] 03 - Variables de entorno definidas en /etc/profile.d/99-custom-env.sh: Correcto.
✅ [PASS] 04 - Variable ORACLE_HOSTNAME: ORACLE_HOSTNAME: h1-bda-mqr.fi.unam
✅ [PASS] 05 - Variable ORACLE_SID: ORACLE_SID: free
✅ [PASS] 06 - Variable NLS_LANG: NLS_LANG: American_America.AL32UTF8
✅ [PASS] 07 - Status del listener: Status READY encontrado para el listener
✅ [PASS] 08 - Permisos de glogin.sql: Permisos de glogin.sql: -rwxr-xr-x
✅ [PASS] 09 - Configuración del editor en glogin.sql: Editor configurado: define _editor=vim
✅ [PASS] 10 - Personalización del prompt en glogin.sql: Prompt configurado: set sqlprompt '&prompt_value> '
✅ [PASS] 11 - Permisos de tnsnames.ora: Permisos de tnsnames.ora: -rwxr-xr-x
✅ [PASS] 12 - Alias de sqlplus con rlwrap: Alias configurado: alias sqlplus=rlwrap sqlplus
✅ [PASS] 13 - Alias de servicio para la PDB 1: Nombre de servicio encontrado: (SERVICE_NAME = mqrbda_s1.fi.unam)

🏆 RESUMEN: 13/13 validaciones correctas
FVH: b9229f1809f49831d328db6a74dcdf80502180dfc4324eb6f92459148cb4492f
================== : Fin de captura : =======================

```



#### Segunda parte, validar desde sqlplus

antes de correr el validador con sqlplus hacer lo siguiente

entrar a PDB$ROOT   = free

dentro de PDB$ROOT ejecutar  **alter pluggable database all save state;**

```shellsession
[martin@h1-bda-mqr 03]$ sqlplus sys/system1@free as sysdba

sys@free> alter pluggable database all save state;

Pluggable database altered.
```

Salir y ahora si ejecutar la segunda parte

ejecutar sqlplus /nolog

dentro de sqlplus ejecutar 

```shellsession
[martin@h1-bda-mqr 03]$ sqlplus /nolog

SQL*Plus: Release 23.0.0.0.0 - Production on Thu Sep 24 14:14:01 2026
Version 23.8.0.25.04

Copyright (c) 1982, 2025, Oracle.  All rights reserved.

SP2-0734: unknown command beginning "echo "hech..." - rest of line ignored.
Help: https://docs.oracle.com/error-help/db/sp2-0734/
idle> start sv-03-main.sql

```

se mostrará el resultado del segundo validador

```shellsession
==> Conectando como sysdba para otorgar privilegios a system...
Connected.
SP2-0734: unknown command beginning "echo "hech..." - rest of line ignored.
Help: https://docs.oracle.com/error-help/db/sp2-0734/
==> Otorgando privilegio de dbms_crypto en todos los contenedores...
==> Otorgando privilegio de select any dictionary en todos los contenedores...
==> Creando objetos de validación en CDB$ROOT...
Connected.
SP2-0734: unknown command beginning "echo "hech..." - rest of line ignored.
Help: https://docs.oracle.com/error-help/db/sp2-0734/
No errors.
No errors.
No errors.
No errors.
No errors.
No errors.
No errors.
No errors.
==> Validando en CDB$ROOT...


========================================================
Validación de resultados 📋 (Tomar captura desde aquí).
========================================================
Fecha .................... 2026-09-24 14:14:17
Usuario OS ............... martin
Usuario BD ............... SYSTEM
Hostname ................. h1-bda-mqr.fi.unam
Contenedor ............... CDB$ROOT
Asignatura ............... bda
Semestre .................. 2027-1
Práctica .................. 03
PDB mqrbda_s1 ............... con_id=3, open_time=24/09/2026 14:07:53, tamaño=807 MB
========================================================
✅ [PASS] 01 - Conexión aterrizó en el contenedor esperado (CDB$ROOT): con_name = CDB$ROOT
✅ [PASS] 02 - La base de datos es una CDB (arquitectura Multitenant): v$database.cdb = YES
✅ [PASS] 03 - Juego de caracteres de la CDB: NLS_CHARACTERSET = AL32UTF8
✅ [PASS] 04 - Juego de caracteres nacional de la CDB: NLS_NCHAR_CHARACTERSET = AL16UTF16
✅ [PASS] 05 - Modo de apertura de la PDB mqrbda_s1: open_mode = READ WRITE
✅ [PASS] 06 - Estado persistente (save state) de la PDB mqrbda_s1: Estado OPEN guardado correctamente
✅ [PASS] 07 - Usuario del sistema operativo distinto a root y oracle: Usuario de ejecución: martin


🏆 RESUMEN: 7/7 validaciones correctas
FVH: 2621dfeaa3c42d33d60e124efa75560c14609fb2ab9772a345db7e039e259db8
==============: Fin de captura :=======================


==> Limpiando objetos de validación en CDB$ROOT...
==> Conectando a mqrbda_s1 vía alias de servicio...
Connected.
SP2-0734: unknown command beginning "echo "hech..." - rest of line ignored.
Help: https://docs.oracle.com/error-help/db/sp2-0734/
==> Creando objetos de validación en mqrbda_s1..
No errors.
No errors.
No errors.
No errors.
No errors.
No errors.
No errors.
No errors.
==> Validando desde mqrbda_s1..


========================================================
Validación de resultados 📋 (Tomar captura desde aquí).
========================================================
Fecha .................... 2026-09-24 14:14:18
Usuario OS ............... martin
Usuario BD ............... SYSTEM
Hostname ................. h1-bda-mqr.fi.unam
Contenedor ............... MQRBDA_S1
Asignatura ............... bda
Semestre .................. 2027-1
Práctica .................. 03
PDB mqrbda_s1 ............... con_id=3, open_time=24/09/2026 14:07:53, tamaño=807 MB
========================================================
✅ [PASS] 01 - Conexión aterrizó en el contenedor esperado (mqrbda_s1): con_name = MQRBDA_S1
✅ [PASS] 02 - Modo de apertura de la PDB mqrbda_s1: open_mode = READ WRITE


🏆 RESUMEN: 2/2 validaciones correctas
FVH: 8135a2f32761b8ee6a64ddaad04b7796c097f177aacb83c3ffd09f5044fd447c
==============: Fin de captura :=======================


==> Limpiando objetos de validación en CDB$ROOT...

Disconnected from Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.8.0.25.04

```



## Interactuar con herramientas gráficas

 hasta ahora para usar la BD hay que entrar al contenedor y posteriormente usar sqlplus

vamos a acceder a nuestra BD desde la maquina host







































7
