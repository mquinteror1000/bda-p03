## runval01.sh

```shellsession
[alicia@h1-bda-agn 03]$ sh runval01.sh 
=====================================================================
      Validación de resultados 📋 (Tomar captura desde aquí)
=====================================================================
Fecha ............................. 2026-10-07 18:53:09
Usuario ........................... alicia
Hostname .......................... h1-bda-agn.fi.unam
Asignatura ........................ bda
Semestre .......................... 2027-1
Práctica .......................... 03
=====================================================================


✅ [PASS] 01 - Uso de un contenedor Docker: Uso de un contenedor Docker correcto
✅ [PASS] 02 - Usuario de ejecución distinto a oracle y root: Usuario de ejecución: alicia
✅ [PASS] 03 - Variables de entorno definidas en /etc/profile.d/99-custom-env.sh: Correcto.
✅ [PASS] 04 - Variable ORACLE_HOSTNAME: ORACLE_HOSTNAME: h1-bda-agn.fi.unam
✅ [PASS] 05 - Variable ORACLE_SID: ORACLE_SID: free
✅ [PASS] 06 - Variable NLS_LANG: NLS_LANG: American_America.AL32UTF8
✅ [PASS] 07 - Status del listener: Status READY encontrado para el listener
✅ [PASS] 08 - Permisos de glogin.sql: Permisos de glogin.sql: -rwxr-xr-x
✅ [PASS] 09 - Configuración del editor en glogin.sql: Editor configurado: define _editor=vim
✅ [PASS] 10 - Personalización del prompt en glogin.sql: Prompt configurado: set sqlprompt '&prompt_value> '
✅ [PASS] 11 - Permisos de tnsnames.ora: Permisos de tnsnames.ora: -rwxr-xr-x
✅ [PASS] 12 - Alias de sqlplus con rlwrap: Alias configurado: alias sqlplus=rlwrap sqlplus
✅ [PASS] 13 - Alias de servicio para la PDB 1: Nombre de servicio encontrado: (SERVICE_NAME = agnbda_s1.fi.unam)

🏆 RESUMEN: 13/13 validaciones correctas
FVH: 98b3dcfd5e65f15452c6be37660829fe638189dc73f2b0098f110fa8afe25c33
================== : Fin de captura : =======================

```
