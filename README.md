# bda-p03

practica 03 de BDA

## Objetivo:

Conocer y poner en práctica las actividades requeridas para crear una base de datos contenedora (CDB) con al menos una pluggable database (PDB).

#### Novedades

**Uso de Volúmenes nombrados**

Se usarán para guardar los archivos de la base de datos **(datafiles, redo logs y control files)**. Con esto se conseguirán: imágenes de docker mas pequeñas y permitirá reutilizarlos entre contenedores.

- Bind Mount: **-v ${UNAM_HOME}:/unam**

- Volumen nombrado: **-v v1-oradata-...:/opt/oracle/oradata**

#### Volúmenes nombrados

| materia | iniciales | volumen         | punto de montaje |
| ------- | --------- | --------------- | ---------------- |
| BDA     | mqr       | bda-oradata-mqr |                  |
| BDD     | mqr       | bdd-oradata-mqr |                  |

editar **/unam/bda/practicas/03/debian/01-crea-volumen-EDIT.sh**

```bash

```

ejecutar

```shellsession

```

#### RED

| materia | iniciales | contenedor | network     | subnet        | dirección   | puerto publicado |
| ------- | --------- | ---------- | ----------- | ------------- | ----------- | ---------------- |
| BDA     | mqr       | c1-bda-mqr | bda_network | 172.22.0.0/16 | 172.22.0.11 | 1522:1521        |
| BDD     | mqr       | c1-bda-mqr | bdd_network | 172.23.0.0/16 | 172.22.0.11 | 1523:1521        |

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

editar fddfdfd

ejecutar sdsdsds



Ahora dentro del contenedor
