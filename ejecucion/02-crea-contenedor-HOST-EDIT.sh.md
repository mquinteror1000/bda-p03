## 02-crea-contenedor-HOST-EDIT.sh

ejecución

```shellsession
martin@pc-bdx-mqr:/unam/bda/practicas/03/host$ sh 02-crea-contenedor-HOST-EDIT.sh 
v1-bda-oradata-mqr
v1-bda-oradata-mqr
bash-5.1$ 
```

En caso de que ya existiera

```shellsession
martin@pc-bdx-mqr:/unam/bda/practicas/03/host$ sh 02-crea-contenedor-HOST-EDIT.sh 
Error: volume v1-bda-oradata-mqr is being used by the following container(s): e3f72b6e18238721201ddc17bdf1481a5aed1511bd54c7d947848ece3dfb3978: volume is being used
Error: volume with name v1-bda-oradata-mqr already exists: volume already exists
[podman] ya existe c1-bda-mqr eliminalo manualmente
```

en ese caso eliminar manualmente

```shellsession
martin@pc-bdx-mqr:/unam/bda/practicas/03/host$ podman container rm c1-bda-mqr 
c1-bda-mqr
```
