## runval02.sh

```shellsession
[martin@h1-bda-mqr 03]$ sh runval02.sh

SQL*Plus: Release 23.0.0.0.0 - Production on Tue Oct 6 20:12:31 2026
Version 23.8.0.25.04

Copyright (c) 1982, 2025, Oracle.  All rights reserved.

==> Conectando como sysdba para otorgar privilegios a system...
Connected.
==> Otorgando privilegio de dbms_crypto en todos los contenedores...
==> Otorgando privilegio de select any dictionary en todos los contenedores...
==> Creando objetos de validación en CDB$ROOT...
Connected.
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
Fecha .................... 2026-10-06 20:12:31
Usuario OS ............... martin
Usuario BD ............... SYSTEM
Hostname ................. h1-bda-mqr.fi.unam
Contenedor ............... CDB$ROOT
Asignatura ............... bda
Semestre .................. 2027-1
Práctica .................. 03
PDB mqrbda_s1 ............... con_id=3, open_time=06/10/2026 19:56:47, tamaño=807 MB
========================================================
✅ [PASS] 01 - Conexión aterrizó en el contenedor esperado (CDB$ROOT): con_name = CDB$ROOT
✅ [PASS] 02 - La base de datos es una CDB (arquitectura Multitenant): v$database.cdb = YES
✅ [PASS] 03 - Juego de caracteres de la CDB: NLS_CHARACTERSET = AL32UTF8
✅ [PASS] 04 - Juego de caracteres nacional de la CDB: NLS_NCHAR_CHARACTERSET = AL16UTF16
✅ [PASS] 05 - Modo de apertura de la PDB mqrbda_s1: open_mode = READ WRITE
✅ [PASS] 06 - Estado persistente (save state) de la PDB mqrbda_s1: Estado OPEN guardado correctamente
✅ [PASS] 07 - Usuario del sistema operativo distinto a root y oracle: Usuario de ejecución: martin


🏆 RESUMEN: 7/7 validaciones correctas
FVH: badfbceb775be8081c6b9435c59cbe682118631dafd49ef31c5a623a20a3e315
==============: Fin de captura :=======================


==> Limpiando objetos de validación en CDB$ROOT...
==> Conectando a mqrbda_s1 vía alias de servicio...
Connected.
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
Fecha .................... 2026-10-06 20:12:32
Usuario OS ............... martin
Usuario BD ............... SYSTEM
Hostname ................. h1-bda-mqr.fi.unam
Contenedor ............... MQRBDA_S1
Asignatura ............... bda
Semestre .................. 2027-1
Práctica .................. 03
PDB mqrbda_s1 ............... con_id=3, open_time=06/10/2026 19:56:47, tamaño=807 MB
========================================================
✅ [PASS] 01 - Conexión aterrizó en el contenedor esperado (mqrbda_s1): con_name = MQRBDA_S1
✅ [PASS] 02 - Modo de apertura de la PDB mqrbda_s1: open_mode = READ WRITE


🏆 RESUMEN: 2/2 validaciones correctas
FVH: ae680091c549a1bd1f357d13ba2042bb1c87f79b69da6576aedc79093d6e825f
==============: Fin de captura :=======================


==> Limpiando objetos de validación en CDB$ROOT...

Disconnected from Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.8.0.25.04
```
