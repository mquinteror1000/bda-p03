#!/bin/sh

# cargar variables de entorno
. /etc/profile.d/99-custom-env.sh

GLOGIN=${ORACLE_HOME}/sqlplus/admin/glogin.sql
chmod 755 ${GLOGIN}

cat << EOF > ${GLOGIN}

define _editor=vim

echo "hecho personalizar el prompt de sqlplus"

--personalizar el prompt
define prompt_value=idle
col prompt_name new_value prompt_value
col prompt_name noprint
set heading off
set termout off
select lower(sys_context('userenv','current_user')
||'@'
||sys_context('userenv','db_name'))
as prompt_name
from dual;
set sqlprompt '&prompt_value> '
set heading on
set termout on
col prompt_name print
set trimspool on
EOF
echo "terminado"
