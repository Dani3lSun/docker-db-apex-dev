#!/bin/bash

oosutils_create_user(){
    echo "Creating OOS Utils User."

    echo 'create user OOSUTILS_USER identified by "'${PASS}'" default tablespace USERS temporary tablespace TEMP' > create_user_custom.sql
    echo "/" >> create_user_custom.sql
    echo "alter user OOSUTILS_USER quota unlimited on USERS" >> create_user_custom.sql
    echo "/" >> create_user_custom.sql
    echo "grant connect, create table, create procedure, create session to OOSUTILS_USER" >> create_user_custom.sql
    echo "/" >> create_user_custom.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_user_custom
}

oosutils_install(){
    echo "Installing OOS Utils."
    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l oosutils_user/${PASS} @install/oos_utils_install
}


oosutils_public_grants(){
    echo "Creating OOS Utils Public Grants."
    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l oosutils_user/${PASS} @install/grant_to_oos_utils PUBLIC
}

oosutils_public_synonyms(){
    echo "Creating OOS Utils Public Synonyms."

    echo "create or replace public synonym oos_util for oosutils_user.oos_util;" > create_oosutils_public_synonyms.sql
    echo "create or replace public synonym oos_util_apex for oosutils_user.oos_util_apex;" >> create_oosutils_public_synonyms.sql
    echo "create or replace public synonym oos_util_bit for oosutils_user.oos_util_bit;" >> create_oosutils_public_synonyms.sql
    echo "create or replace public synonym oos_util_crypto for oosutils_user.oos_util_crypto;" >> create_oosutils_public_synonyms.sql
    echo "create or replace public synonym oos_util_date for oosutils_user.oos_util_date;" >> create_oosutils_public_synonyms.sql
    echo "create or replace public synonym oos_util_lob for oosutils_user.oos_util_lob;" >> create_oosutils_public_synonyms.sql
    echo "create or replace public synonym oos_util_string for oosutils_user.oos_util_string;" >> create_oosutils_public_synonyms.sql
    echo "create or replace public synonym oos_util_totp for oosutils_user.oos_util_totp;" >> create_oosutils_public_synonyms.sql
    echo "create or replace public synonym oos_util_validation for oosutils_user.oos_util_validation;" >> create_oosutils_public_synonyms.sql
    echo "create or replace public synonym oos_util_web for oosutils_user.oos_util_web;" >> create_oosutils_public_synonyms.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_oosutils_public_synonyms
}

oosutils_unzip(){
    echo "Extracting OOS Utils"
    mkdir /files/oosutils
    unzip /files/oos-utils*.zip -d /files/oosutils/
}

echo "Installing OOS Utils into DB: ${ORACLE_SID}"
. /home/oracle/.bash_profile
oosutils_unzip
cd /files/oosutils/oos-utils-*
oosutils_create_user
oosutils_install
oosutils_public_grants
oosutils_public_synonyms
cd /
