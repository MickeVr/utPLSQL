CLEAR SCREEN
SET TERMOUT OFF
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK OFF 
SET TTITLE OFF
SET SERVEROUTPUT ON SIZE 1000000 FORMAT WRAPPED
SET DEFINE ON

COLUMN nc NOPRINT NEW_VALUE ut_installed
select count(1) nc from user_objects where object_name = 'UT' and object_type='PACKAGE';

COLUMN col NOPRINT NEW_VALUE next_script
select decode(&ut_installed,0,'install.sql',
                 'pearl_log_installed.sql') col from dual;


@@&next_script

EXIT;
