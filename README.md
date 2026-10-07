# bda-p03 podman

Práctica 03 de BDA

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
| bdd     | mqr       | c1-bda-mqr | bdd_network | 172.23.0.0/16 | 172.22.0.11 | 1523:1521        |

## Mapeo de puertos

Como se usa podman rootless es necesario realizar mapeo de puertos. el puerto 1521 del container se mapea en el 1522 del host

```shellsession
14942b10b9f2  localhost/ol-mqr:1.0                            bash                  6 minutes ago   Up 5 minutes            0.0.0.0:1522->1521/tcp                     c1-bda-mqr
```

## host/01-crea-red-docker-HOST-EDIT.sh

Crea una red de docker para la materia de BDA  y un contenedor en esa red

Editar 

```bash
NETWORK_NAME="bda_network"
MATERIA="bda"
```

Ejecutar

```shellsession
martin@pc-bdx-mqr:/unam/bda/practicas/03/host$ sh 01-crea-contenedor-HOST-EDIT.sh 
```

[salida: 01-crea-contenedor-HOST-EDIT.sh](ejecucion/01-crea-contenedor-HOST-EDIT.sh.md)

## host/02-crea-contenedor-EDIT.sh

editar 

```bash
MATERIA="bda"
INICIALES="mqr"
BASE_IMAGE="ol-mqr:1.0"
```

ejecutar **/unam/bda/practicas/03/debian/02-crea-contenedor-EDIT.sh**

```shellsession
martin@pc-bda-mqr:/unam/bda/practicas/03/debian$ sh 02-crea-contenedor-EDIT.sh 
```

[salida: 02-crea-contenedor-EDIT.sh] (ejecucion/02-crea-contenedor-HOST-EDIT.sh.md)

[salida](ejecucion/02-crea-contenedor-HOST-EDIT.sh.md)

Si todo esta correcto entrega una shell del nuevo contenedor. SAlir de este

#### Agregar los alias de acceso rápido al contenedor

De manera **manual**

agregar en .bashrc el usuario **/home/martin/.bashrc**

```bash
alias dockerBda1='podman container start c1-bda-mqr && podman exec -u root -it c1-bda-mqr bash -l'
alias dockerBda1T='podman exec -it -u martin c1-bda-mqr bash -l'
```

probar

```shellsession
martin@pc-bdx-mqr:~$ podman container start c1-bda-mqr
c1-bda-mqr
martin@pc-bdx-mqr:~$ dockerBda1T
[martin@h1-bda-mqr /]$ 
```

También

```shellsession
martin@pc-bdx-mqr:~$ dockerBda1
c1-bda-mqr
[root@h1-bda-mqr /]# 
```

## container/03-permisos-variables-EDIT.sh

Se agregan las variables de entorno necesarias en /etc/profile.d/99-custom-env.sh

También se cambia el propietario del folder ${ORACLE_HOME}/oradata

Editar

```bash
#EDITAR
MATERIA="bda"
INICIALES="mqr"
ORACLE_VERSION="23ai"
ORACLE_SID="free"
UNAM_HOME="/unam"
```

Ejecutar **/container/03-permisos-variables-EDIT.sh**

```shellsession
[martin@h1-bda-mqr container]$ sudo sh 03-permisos-variables-EDIT.sh 
```

[salida](ejecucion/03-permisos-variables-root-EDIT.sh.md)

#### Crear un listener modo no interactivo

Modificar el script **/unam/bda/practicas/03/debian/container/04-crea-listener-EDIT.sh**

```bash
# editar
ASIGNATURA="bda"
```

Cambiar al usuario **oracle** con **su -l oracle** y  ejecutar el script  **/unam/bda/practicas/03/debian/container/04-crea-listener-EDIT.sh**

```shellsession
[oracle@h1-bda-mqr container]$ sh 04-crea-listener-EDIT.sh 
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
[martin@h1-bda-mqr container]$ sudo mv launch-EDIT.sh /usr/bin/launch
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
Fixed Size            4922232 bytes
Variable Size          452984832 bytes
Database Buffers     1140850688 bytes
Redo Buffers            4530176 bytes
Database mounted.
Database opened.
Cambiando al usuario admin
Last login: Thu Sep 24 07:52:02 CST 2026 on pts/0
[martin@h1-bda-mqr ~]$ 
```

y podemos acceder a nuestr pdb de manera directa con sqlplus

```shellsession
[martin@h1-bda-mqr ~]$ sqlplus sys/system1@mqrbda_s1 as sysdba
[...]
sys@mqrbda_s1> 
```

# Validador

## Parte 1

ejecutar  **/unam/bda/practicas/03/runval01.sh**

```shellsession
[martin@h1-bda-mqr 03]$ sh runval01.sh 
```

[salida](ejecucion/runval01.sh.md)

## Parte 2

Antes en SQLplus haer ..

```shellsession
[martin@h1-bda-mqr 03]$ sqlplus sys/system1@free as sysdba

sys@free> alter pluggable database all save state;

Pluggable database altered.
```

Modificar el script del profesor **/unam/bda/practicas/03/sv-03-main.sql**  

```sql
--Password de sys/system (mismo para ambos en el curso)
define v_password = 'system1'
--Iniciales del estudiante
define v_iniciales = 'mqr'
--asignatura ( bd | bda | bdd )
define v_asignatura = 'bda'
```

## runval-02.sh

este script autentica en sqlplus y corre el script validador de sql

```shellsession
[martin@h1-bda-mqr 03]$ sh runval02.sh 
```

se mostrará el resultado del segundo validador

[salida](ejecucion/runval02.sh.md)

## Interactuar con herramientas gráficas

 hasta ahora para usar la BD hay que entrar al contenedor y posteriormente usar sqlplus

vamos a acceder a nuestra BD desde la maquina host

Instalar visual studio code

```bash
 sudo apt install snapd
 sudo snap install core
 sudo snap install code --classic
```

Ya en code en el menu; view -> extensions . Buscar Oracle Sqldeveloper
