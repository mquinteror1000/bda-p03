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

Editar **/unam/bda/practicas/03/debian/02-crea-red-docker-EDIT.sh**

```bash
# editar
NETWORK_NAME="bda_network"
MATERIA="bda"
```

ejecutar **/unam/bda/practicas/03/debian/02-crea-red-docker-EDIT.sh**

```shellsession
martin@pc-bda-mqr:/unam/bda/practicas/03/debian$ sh 02-crea-red-docker-EDIT.sh 
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
