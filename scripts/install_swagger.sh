#!/bin/bash

unzip_and_move(){
  unzip -o swagger-ui*.zip
  mv swagger-ui*/dist ${TOMCAT_HOME}/webapps/swagger-ui
}

cleanup(){
  rm -fr swagger-ui*
  rm -f v3.*.zip
  rm -f insert_apex_platform_pref.sql
}

insert_apex_platform_pref(){
    . /home/oracle/.bash_profile

    APEX_SCHEMA=`sqlplus -s -l sys/${PASS} AS SYSDBA <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
SELECT ao.owner FROM all_objects ao WHERE ao.object_name = 'WWV_FLOW' AND ao.object_type = 'PACKAGE' AND ao.owner LIKE 'APEX_%';
EXIT;
EOF`

    echo "BEGIN" > insert_apex_platform_pref.sql
    echo "    INSERT INTO wwv_flow_platform_prefs(id,name,value,created_on,last_updated_on,pref_desc,security_group_id)" >> insert_apex_platform_pref.sql
    echo "    VALUES(wwv_flow_id.next_val,'SWAGGER_UI_URL','/swagger-ui',SYSDATE,SYSDATE,NULL,10);" >> insert_apex_platform_pref.sql
    echo "    COMMIT;" >> insert_apex_platform_pref.sql
    echo "END;" >> insert_apex_platform_pref.sql
    echo "/" >> insert_apex_platform_pref.sql

    ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA <<EOF
ALTER SESSION SET CURRENT_SCHEMA=${APEX_SCHEMA};
@insert_apex_platform_pref.sql
EXIT;
EOF
}

cd /files
unzip_and_move
insert_apex_platform_pref
cleanup
