#!/bin/bash

logger_create_tablespace(){
    echo "Creating Logger Tablespace."

    if [ ${DB_INSTALL_VERSION} == "12" ]; then
        DATAFILE_SID=${ORACLE_SID}
    fi
    if [ ${DB_INSTALL_VERSION} == "18" ]; then
        DATAFILE_SID=${ORACLE_SID^^}
    fi
    if [ ${DB_INSTALL_VERSION} == "19" ]; then
        DATAFILE_SID=${ORACLE_SID^^}
    fi

    ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA <<EOF
		CREATE TABLESPACE LOGGER_TS DATAFILE '${ORACLE_BASE}/oradata/${DATAFILE_SID}/logger01.dbf' SIZE 50M AUTOEXTEND ON NEXT 10M;
EOF
}

logger_create_user(){
    echo "Creating Logger User."

    echo 'create user LOGGER_USER identified by "'${PASS}'" default tablespace LOGGER_TS temporary tablespace TEMP' > create_user_custom.sql
    echo "/" >> create_user_custom.sql
    echo "alter user LOGGER_USER quota unlimited on LOGGER_TS" >> create_user_custom.sql
    echo "/" >> create_user_custom.sql
    echo "grant connect,create view, create job, create table, create sequence, create trigger, create procedure, create any context to LOGGER_USER" >> create_user_custom.sql
    echo "/" >> create_user_custom.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_user_custom
}

logger_install(){
    echo "Installing Logger."
    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l logger_user/${PASS} @logger_install
}

logger_disable_admin_privs(){
    echo "UPDATE logger_prefs SET logger_prefs.pref_value = 'FALSE' WHERE logger_prefs.pref_name = 'PROTECT_ADMIN_PROCS';" > disable_logger_admin_privs.sql
    echo "COMMIT;" >> disable_logger_admin_privs.sql
    echo "/" >> disable_logger_admin_privs.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l logger_user/${PASS} @disable_logger_admin_privs
}

logger_public_grants(){
    echo "Creating Logger Public Grants."
    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l logger_user/${PASS} @grant_logger_to_user PUBLIC
}

logger_public_synonyms(){
    echo "Creating Logger Public Synonyms."

    echo "create or replace public synonym logger for logger_user.logger;" > create_logger_public_synonyms.sql
    echo "create or replace public synonym logger_logs for logger_user.logger_logs;" >> create_logger_public_synonyms.sql
    echo "create or replace public synonym logger_logs_apex_items for logger_user.logger_logs_apex_items;" >> create_logger_public_synonyms.sql
    echo "create or replace public synonym logger_prefs for logger_user.logger_prefs;" >> create_logger_public_synonyms.sql
    echo "create or replace public synonym logger_prefs_by_client_id for logger_user.logger_prefs_by_client_id;" >> create_logger_public_synonyms.sql
    echo "create or replace public synonym logger_logs_5_min for logger_user.logger_logs_5_min;" >> create_logger_public_synonyms.sql
    echo "create or replace public synonym logger_logs_60_min for logger_user.logger_logs_60_min;" >> create_logger_public_synonyms.sql
    echo "create or replace public synonym logger_logs_terse for logger_user.logger_logs_terse;" >> create_logger_public_synonyms.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_logger_public_synonyms
}

unzip_logger(){
    echo "Extracting Logger"
    mkdir /files/logger
    unzip /files/logger_*.zip -d /files/logger/
}

echo "Installing Logger into DB: ${ORACLE_SID}"
. /home/oracle/.bash_profile
unzip_logger
cd /files/logger
logger_create_tablespace
logger_create_user
logger_install
logger_disable_admin_privs
cd scripts
logger_public_grants
logger_public_synonyms
cd /
