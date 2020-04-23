#!/bin/bash

aop_create_user(){
    echo "Creating AOP User."

    echo 'create user AOP identified by "'${PASS}'" default tablespace USERS temporary tablespace TEMP' > create_user_custom.sql
    echo "/" >> create_user_custom.sql
    echo "alter user AOP quota unlimited on USERS" >> create_user_custom.sql
    echo "/" >> create_user_custom.sql
    echo "grant connect, create cluster, create dimension, create indextype, create job, create materialized view, create operator, create procedure, create sequence, create session, create synonym, create table, create trigger, create type, create view to AOP;" >> create_user_custom.sql
    echo "/" >> create_user_custom.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_user_custom
}

aop_create_workspace(){
    echo "Creating AOP APEX Workspace"

    echo 'DECLARE' > create_workspace.sql
    echo 'l_workspace_id NUMBER;' >> create_workspace.sql
    echo 'BEGIN' >> create_workspace.sql
    echo "APEX_INSTANCE_ADMIN.ADD_WORKSPACE (p_workspace => 'AOP', p_primary_schema => 'AOP');" >> create_workspace.sql
    echo "COMMIT;" >> create_workspace.sql
    echo "SELECT workspace_id INTO l_workspace_id FROM apex_workspaces WHERE workspace = 'AOP';" >> create_workspace.sql
    echo "wwv_flow_api.set_security_group_id(p_security_group_id => l_workspace_id);" >> create_workspace.sql
    echo "apex_util.create_user(p_user_name => 'ADMIN', p_web_password => '"${APEX_PASS}"', p_email_address => 'admin@docker.local', p_change_password_on_first_use => 'N', p_developer_privs => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL', p_default_schema => 'AOP', p_allow_app_building_yn => 'Y', p_allow_sql_workshop_yn => 'Y', p_allow_websheet_dev_yn => 'Y', p_allow_team_development_yn => 'Y');" >> create_workspace.sql
    echo "END;" >> create_workspace.sql
    echo "/" >> create_workspace.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_workspace
}

aop_install_db(){
    echo "Installing AOP"

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l aop/${PASS} @install
    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l aop/${PASS} @aop_db_sample_obj
    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l aop/${PASS} @aop_db_sample_pkg
}

aop_install_apex(){
    echo "Creating AOP APEX Application"

    APEX_SCHEMA=`sqlplus -s -l sys/${PASS} AS SYSDBA <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
SELECT ao.owner FROM all_objects ao WHERE ao.object_name = 'WWV_FLOW' AND ao.object_type = 'PACKAGE' AND ao.owner LIKE 'APEX_%';
EXIT;
EOF`

    echo "begin" > install_aop_app.sql
    echo "apex_application_install.set_workspace('AOP');" >> install_aop_app.sql
    echo "apex_application_install.generate_offset;" >> install_aop_app.sql
    echo "apex_application_install.set_schema('AOP');" >> install_aop_app.sql
    echo "apex_application_install.set_application_id(150);" >> install_aop_app.sql
    echo "end;" >> install_aop_app.sql
    echo "/" >> install_aop_app.sql
    if [ "$APEX_SCHEMA" = "APEX_050000" ]; then
        echo "Install AOP Sample App for APEX 5.0.x"
        echo "@@apex_version_5.0/aop_sample_apex_app.sql" >> install_aop_app.sql
    elif [ "$APEX_SCHEMA" = "APEX_050100" ]; then
        echo "Install AOP Sample App for APEX 5.1.x"
        echo "@@apex_version_5.1/aop_sample_apex_app.sql" >> install_aop_app.sql
    elif [ "$APEX_SCHEMA" = "APEX_180100" ]; then
        echo "Install AOP Sample App for APEX 18.x - 19.1"
        echo "@@apex_version_18.x_19.1/aop_sample_apex_app.sql" >> install_aop_app.sql
    elif [ "$APEX_SCHEMA" = "APEX_180200" ]; then
        echo "Install AOP Sample App for APEX 18.x - 19.1"
        echo "@@apex_version_18.x_19.1/aop_sample_apex_app.sql" >> install_aop_app.sql
    elif [ "$APEX_SCHEMA" = "APEX_190100" ]; then
        echo "Install AOP Sample App for APEX 18.x - 19.1"
        echo "@@apex_version_18.x_19.1/aop_sample_apex_app.sql" >> install_aop_app.sql
    elif [ "$APEX_SCHEMA" = "APEX_190200" ]; then
        echo "Install AOP Sample App for APEX 19.2"
        echo "@@apex_version_19.2_20.x/aop_sample_apex_app.sql" >> install_aop_app.sql
    elif [ "$APEX_SCHEMA" = "APEX_200100" ]; then
        echo "Install AOP Sample App for APEX 20.1"
        echo "@@apex_version_19.2_20.x/aop_sample_apex_app.sql" >> install_aop_app.sql
    fi

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l aop/${PASS} @install_aop_app
}


aop_public_grants(){
    echo "Creating AOP Public Grants."

    echo "grant execute on aop.aop_api20_pkg to PUBLIC;" > create_aop_public_grants.sql
    echo "grant execute on aop.aop_convert20_pkg to PUBLIC;" >> create_aop_public_grants.sql
    echo "grant execute on aop.aop_plsql20_pkg to PUBLIC;" >> create_aop_public_grants.sql
    echo "grant execute on aop.aop_settings20_pkg to PUBLIC;" >> create_aop_public_grants.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l aop/${PASS} @create_aop_public_grants
}

aop_public_synonyms(){
    echo "Creating AOP Public Synonyms."

    echo "create or replace public synonym aop_api20_pkg for aop.aop_api20_pkg;" > create_aop_public_synonyms.sql
    echo "create or replace public synonym aop_convert20_pkg for aop.aop_convert20_pkg;" >> create_aop_public_synonyms.sql
    echo "create or replace public synonym aop_plsql20_pkg for aop.aop_plsql20_pkg;" >> create_aop_public_synonyms.sql
    echo "create or replace public synonym aop_settings20_pkg for aop.aop_settings20_pkg;" >> create_aop_public_synonyms.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_aop_public_synonyms
}

aop_unzip(){
    echo "Extracting AOP"
    mkdir /files/aop
    unzip /files/aop_cloud_v*.zip -d /files/aop/
}

echo "Installing AOP into DB: ${ORACLE_SID}"

. /home/oracle/.bash_profile
aop_unzip

cd /files/aop/v*/db
aop_create_user
aop_create_workspace
aop_install_db
aop_public_grants
aop_public_synonyms

cd /files/aop/v*/apex
aop_install_apex

cd /
