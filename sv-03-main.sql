--@Autor(es):       <Nombre del autor o autores>
--@Fecha creación:  dd/mm/yyyy
--@Descripción:     Validación de resultados de la práctica 03. El script crea
--                  los objetos de validación (vcore/vutils/sv-02) en cada
--                  contenedor que se valida — no se asume que ya existan — y
--                  los elimina antes de pasar al siguiente. Conectarse vía el
--                  alias de servicio de cada PDB prueba de punta a punta que
--                  el *listener* y tnsnames.ora están bien configurados: si
--                  cualquiera de los 2 falla, el propio "connect" da error.

whenever sqlerror continue

----------------------------------------------------------------------
-- 1. Para estudiantes:
-- Modificar los valores de las siguientes variables según corresponda
----------------------------------------------------------------------

--Password de sys/system (mismo para ambos en el curso)
define v_password = 'system1'

--Iniciales del estudiante
define v_iniciales = 'mqr'

--asignatura ( bd | bda | bdd )
define v_asignatura = 'bda'

------------------------------------------------------------------------
-- 2. Las variables siguientes ya no requieren cambios
--  No modificar a  partir de este punto
------------------------------------------------------------------------

define v_pdb1 = &v_iniciales.&v_asignatura._s1
define v_pdb2 = &v_iniciales.&v_asignatura._s2
define v_spool = p03-sql-output.txt

spool &v_spool

set verify off
set feedback off
set linesize window

----------------------------------------------------------------------
-- 3. Conectando como sysdba para configurar privilegios para el usuario
-- system, empleado como dueño de todos los objetos de validación
----------------------------------------------------------------------

prompt ==> Conectando como sysdba para otorgar privilegios a system...
connect sys/&v_password as sysdba

prompt ==> Otorgando privilegio de dbms_crypto en todos los contenedores...
grant execute on dbms_crypto to public container=all;

prompt ==> Otorgando privilegio de select any dictionary en todos los contenedores...
grant select any dictionary to system container=all;

----------------------------------------------------------------------
-- Bloque 1: CDB$ROOT
----------------------------------------------------------------------

prompt ==> Creando objetos de validación en CDB$ROOT...
connect system/&v_password
set serveroutput on

--objetos comunes para validar (vcore/vutils)
@sv-00-fx.plb
--objetos específicos de la práctica para validar
@sv-02.plb

prompt ==> Validando en CDB$ROOT...
declare
  v_ok boolean;
begin
  vcore.init('&v_asignatura', vcore.calculate_semester, '03');
  vcore.verify(
    upper(sys_context('userenv', 'con_name')) = 'CDB$ROOT',
    'Conexión aterrizó en el contenedor esperado (CDB$ROOT)',
    'con_name = CDB$ROOT',
    'con_name = ' || sys_context('userenv', 'con_name')
      || ' — el connect anterior pudo haber fallado, dejando la sesión en'
      || ' el contenedor previo. Los resultados de este bloque no son'
      || ' confiables.'
  );
  valida_cdb_multitenant;
  valida_charset_cdb;
  valida_pdb('&v_pdb1');
  valida_pdb_estado_persistente('&v_pdb1');
  if '&v_asignatura' = 'bdd' then
    valida_pdb('&v_pdb2');
    valida_pdb_estado_persistente('&v_pdb2');
  end if;
  vutils.valida_os_user_no_privilegiado;
  v_ok := vcore.finalize;
end;
/

prompt ==> Limpiando objetos de validación en CDB$ROOT...
begin
  vcore.cleanup_validation;
end;
/
drop package if exists vutils;
drop package if exists vcore;

----------------------------------------------------------------------
-- Bloque 2: PDB 1 (todas las asignaturas) — conectar vía alias prueba
-- que el listener y tnsnames.ora funcionan de punta a punta.
----------------------------------------------------------------------

prompt ==> Conectando a &v_pdb1 vía alias de servicio...
connect system/&v_password@&v_pdb1
set serveroutput on

prompt ==> Creando objetos de validación en &v_pdb1...
--objetos comunes para validar (vcore/vutils)
@sv-00-fx.plb
--objetos específicos de la práctica para validar
@sv-02.plb

prompt ==> Validando desde &v_pdb1...
declare
  v_ok boolean;
begin
  vcore.init('&v_asignatura', vcore.calculate_semester, '03');
  vcore.verify(
    upper(sys_context('userenv', 'con_name')) = upper('&v_pdb1'),
    'Conexión aterrizó en el contenedor esperado (&v_pdb1)',
    'con_name = ' || sys_context('userenv', 'con_name'),
    'con_name = ' || sys_context('userenv', 'con_name')
      || ' — el connect anterior pudo haber fallado, dejando la sesión en'
      || ' el contenedor previo. Los resultados de este bloque no son'
      || ' confiables.'
  );
  valida_pdb('&v_pdb1');
  v_ok := vcore.finalize;
end;
/

prompt ==> Limpiando objetos de validación en CDB$ROOT...
begin
  vcore.cleanup_validation;
end;
/
drop package if exists vutils;
drop package if exists vcore;


spool off

-- Checksum de integridad sobre el archivo completo (todas las conexiones
-- ya capturadas en &v_spool vía spool). Se invierte el hash antes de
-- anexarlo, mismo criterio que el resto de los validadores del curso.
!c=$(sha256sum &v_spool | awk '{print $1}'); printf 'CHK:%s\n' "$(printf '%s' "$c" | rev)">>&v_spool

exit
