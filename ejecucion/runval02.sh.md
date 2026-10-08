## runval02.sh

```shellsession
[alicia@h1-bda-agn 03]$ sh runval02.sh

SQL*Plus: Release 23.0.0.0.0 - Production on Wed Oct 7 18:57:12 2026
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
Fecha .................... 2026-10-07 18:57:13
Usuario OS ............... alicia
Usuario BD ............... SYSTEM
Hostname ................. h1-bda-agn.fi.unam
Contenedor ............... CDB$ROOT
Asignatura ............... bda
Semestre .................. 2027-1
Práctica .................. 03
PDB agnbda_s1 ............... con_id=3, open_time=07/10/2026 18:50:33, tamaño=807 MB
========================================================
✅ [PASS] 01 - Conexión aterrizó en el contenedor esperado (CDB$ROOT): con_name = CDB$ROOT
✅ [PASS] 02 - La base de datos es una CDB (arquitectura Multitenant): v$database.cdb = YES
✅ [PASS] 03 - Juego de caracteres de la CDB: NLS_CHARACTERSET = AL32UTF8
✅ [PASS] 04 - Juego de caracteres nacional de la CDB: NLS_NCHAR_CHARACTERSET = AL16UTF16
✅ [PASS] 05 - Modo de apertura de la PDB agnbda_s1: open_mode = READ WRITE
✅ [PASS] 06 - Estado persistente (save state) de la PDB agnbda_s1: Estado OPEN guardado correctamente
✅ [PASS] 07 - Usuario del sistema operativo distinto a root y oracle: Usuario de ejecución: alicia


🏆 RESUMEN: 7/7 validaciones correctas
FVH: 9ff0b67d9253ac5b2fdb6705bb8021040ea2a9c3c72a0fa44b707643cfac4d29
==============: Fin de captura :=======================


==> Limpiando objetos de validación en CDB$ROOT...
==> Conectando a agnbda_s1 vía alias de servicio...
Connected.
==> Creando objetos de validación en agnbda_s1..
No errors.
No errors.
No errors.
No errors.
No errors.
No errors.
No errors.
No errors.
==> Validando desde agnbda_s1..


========================================================
Validación de resultados 📋 (Tomar captura desde aquí).
========================================================
Fecha .................... 2026-10-07 18:57:14
Usuario OS ............... alicia
Usuario BD ............... SYSTEM
Hostname ................. h1-bda-agn.fi.unam
Contenedor ............... AGNBDA_S1
Asignatura ............... bda
Semestre .................. 2027-1
Práctica .................. 03
PDB agnbda_s1 ............... con_id=3, open_time=07/10/2026 18:50:33, tamaño=807 MB
========================================================
✅ [PASS] 01 - Conexión aterrizó en el contenedor esperado (agnbda_s1): con_name = AGNBDA_S1
✅ [PASS] 02 - Modo de apertura de la PDB agnbda_s1: open_mode = READ WRITE


🏆 RESUMEN: 2/2 validaciones correctas
FVH: faa274f176d07a3d73fb57bd755b9140ddb171220a03c15d143b7242bbe025f8
==============: Fin de captura :=======================


==> Limpiando objetos de validación en CDB$ROOT...

Disconnected from Oracle Database 23ai Free Release 23.0.0.0.0 - Develop, Learn, and Run for Free
Version 23.8.0.25.04

```
