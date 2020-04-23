#!/bin/bash

ame_create_user(){
    echo "Creating AME User."

    echo 'create user AME identified by "'${PASS}'" default tablespace USERS temporary tablespace TEMP' > create_user_custom.sql
    echo "/" >> create_user_custom.sql
    echo "alter user AME quota unlimited on USERS" >> create_user_custom.sql
    echo "/" >> create_user_custom.sql
    echo "grant connect, create cluster, create dimension, create indextype, create job, create materialized view, create operator, create procedure, create sequence, create session, create synonym, create table, create trigger, create type, create view to AME;" >> create_user_custom.sql
    echo "/" >> create_user_custom.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_user_custom
}

ame_create_workspace(){
    echo "Creating AME APEX Workspace"

    echo 'DECLARE' > create_workspace.sql
    echo 'l_workspace_id NUMBER;' >> create_workspace.sql
    echo 'BEGIN' >> create_workspace.sql
    echo "APEX_INSTANCE_ADMIN.ADD_WORKSPACE (p_workspace => 'AME', p_primary_schema => 'AME');" >> create_workspace.sql
    echo "COMMIT;" >> create_workspace.sql
    echo "SELECT workspace_id INTO l_workspace_id FROM apex_workspaces WHERE workspace = 'AME';" >> create_workspace.sql
    echo "wwv_flow_api.set_security_group_id(p_security_group_id => l_workspace_id);" >> create_workspace.sql
    echo "apex_util.create_user(p_user_name => 'ADMIN', p_web_password => '"${APEX_PASS}"', p_email_address => 'admin@docker.local', p_change_password_on_first_use => 'N', p_developer_privs => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL', p_default_schema => 'AME', p_allow_app_building_yn => 'Y', p_allow_sql_workshop_yn => 'Y', p_allow_websheet_dev_yn => 'Y', p_allow_team_development_yn => 'Y');" >> create_workspace.sql
    echo "END;" >> create_workspace.sql
    echo "/" >> create_workspace.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_workspace
}

ame_install_db(){
    echo "Installing AME"

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l ame/${PASS} @install
    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l ame/${PASS} @ame_db_sample_obj
}

ame_install_apex(){
    echo "Creating AME APEX Application"

    APEX_SCHEMA=`sqlplus -s -l sys/${PASS} AS SYSDBA <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
SELECT ao.owner FROM all_objects ao WHERE ao.object_name = 'WWV_FLOW' AND ao.object_type = 'PACKAGE' AND ao.owner LIKE 'APEX_%';
EXIT;
EOF`

    echo "begin" > install_ame_app.sql
    echo "apex_application_install.set_workspace('AME');" >> install_ame_app.sql
    echo "apex_application_install.generate_offset;" >> install_ame_app.sql
    echo "apex_application_install.set_schema('AME');" >> install_ame_app.sql
    echo "apex_application_install.set_application_id(160);" >> install_ame_app.sql
    echo "end;" >> install_ame_app.sql
    echo "/" >> install_ame_app.sql
    if [ "$APEX_SCHEMA" = "APEX_180100" ]; then
        echo "Install AME Sample App for APEX 18.1"
        echo "@@ame_sample_apex_app.sql" >> install_ame_app.sql
    elif [ "$APEX_SCHEMA" = "APEX_180200" ]; then
        echo "Install AME Sample App for APEX 18.2"
        echo "@@ame_sample_apex_app.sql" >> install_ame_app.sql
    elif [ "$APEX_SCHEMA" = "APEX_190100" ]; then
        echo "Install AME Sample App for APEX 19.1"
        echo "@@ame_sample_apex_app.sql" >> install_ame_app.sql
    elif [ "$APEX_SCHEMA" = "APEX_190200" ]; then
        echo "Install AME Sample App for APEX 19.2"
        echo "@@ame_sample_apex_app.sql" >> install_ame_app.sql
    elif [ "$APEX_SCHEMA" = "APEX_200100" ]; then
        echo "Install AME Sample App for APEX 20.1"
        echo "@@ame_sample_apex_app.sql" >> install_ame_app.sql
    fi

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l ame/${PASS} @install_ame_app
}


ame_public_grants(){
    echo "Creating AME Public Grants."

    echo "grant execute on ame.ame_api20_pkg to PUBLIC;" > create_ame_public_grants.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l ame/${PASS} @create_ame_public_grants
}

ame_public_synonyms(){
    echo "Creating AME Public Synonyms."

    echo "create or replace public synonym ame_api20_pkg for ame.ame_api20_pkg;" > create_ame_public_synonyms.sql
    echo "create or replace public synonym ame_api_pkg for ame.ame_api20_pkg;" >> create_ame_public_synonyms.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_ame_public_synonyms
}

ame_unzip(){
    echo "Extracting AME"
    mkdir /files/ame
    unzip /files/ame_cloud_v*.zip -d /files/ame/
}

echo "Installing AME into DB: ${ORACLE_SID}"

. /home/oracle/.bash_profile
ame_unzip

cd /files/ame/v*/db
ame_create_user
ame_create_workspace
ame_install_db
ame_public_grants
ame_public_synonyms

cd /files/ame/v*/apex
ame_install_apex

cd /
