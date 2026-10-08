## launch

```sellsession
martin@pc-bdx-mqr:/unam/bda/practicas/03/container$ agnDockerBda1
c1-bda-agn
bash-5.1# launch
Verificando el listener...
Iniciando el listener...

LSNRCTL for Linux: Version 23.0.0.0.0 - Production on 07-OCT-2026 19:03:02

Copyright (c) 1991, 2025, Oracle.  All rights reserved.

Starting /opt/oracle/product/23ai/dbhomeFree/bin/tnslsnr: please wait...

TNSLSNR for Linux: Version 23.0.0.0.0 - Production
System parameter file is /opt/oracle/product/23ai/dbhomeFree/network/admin/listener.ora
Log messages written to /opt/oracle/diag/tnslsnr/h1-bda-agn/listener/alert/log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=h1-bda-agn.fi.unam)(PORT=1521)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=h1-bda-agn.fi.unam)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 23.0.0.0.0 - Production
Start Date                07-OCT-2026 19:03:04
Uptime                    0 days 0 hr. 0 min. 0 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/oracle/product/23ai/dbhomeFree/network/admin/listener.ora
Listener Log File         /opt/oracle/diag/tnslsnr/h1-bda-agn/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=h1-bda-agn.fi.unam)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=EXTPROC1521)))
The listener supports no services
The command completed successfully
Verificando el estado de la instancia...
Iniciando la instancia...
ORACLE instance started.

Total System Global Area 1603287928 bytes
Fixed Size		    4922232 bytes
Variable Size		  402653184 bytes
Database Buffers	 1191182336 bytes
Redo Buffers		    4530176 bytes
Database mounted.
Database opened.
Cambiando al usuario admin
Last login: Wed Oct  7 18:50:34 CST 2026 on pts/0
[alicia@h1-bda-agn ~]$

```
