#!/bin/bash
#PASSWORD=${1:-secret}

create_sdw_admin_user() {
    echo "Creating SQL Developer Web Admin User."

    echo 'create user SDW_ADMIN identified by "'${PASS}'" default tablespace USERS temporary tablespace TEMP' >create_sdw_admin_user.sql
    echo "/" >>create_sdw_admin_user.sql
    echo "alter user SDW_ADMIN quota unlimited on USERS" >>create_sdw_admin_user.sql
    echo "/" >>create_sdw_admin_user.sql
    echo "grant connect, dba, pdb_dba to SDW_ADMIN;" >>create_sdw_admin_user.sql
    echo "/" >>create_sdw_admin_user.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sys/${PASS} AS SYSDBA @create_sdw_admin_user
}

enable_ords_sdw_admin() {
    echo "Enable ORDS for SQL Developer Web Admin User."

    echo "BEGIN" >enable_ords_sdw_admin.sql
    echo "  ORDS.enable_schema(" >>enable_ords_sdw_admin.sql
    echo "    p_enabled             => TRUE," >>enable_ords_sdw_admin.sql
    echo "    p_schema              => 'SDW_ADMIN'," >>enable_ords_sdw_admin.sql
    echo "    p_url_mapping_type    => 'BASE_PATH'," >>enable_ords_sdw_admin.sql
    echo "    p_url_mapping_pattern => 'sdw_admin'," >>enable_ords_sdw_admin.sql
    echo "    p_auto_rest_auth      => FALSE" >>enable_ords_sdw_admin.sql
    echo "  );" >>enable_ords_sdw_admin.sql
    echo "  COMMIT;" >>enable_ords_sdw_admin.sql
    echo "END;" >>enable_ords_sdw_admin.sql
    echo "/" >>enable_ords_sdw_admin.sql

    echo "EXIT" | ${ORACLE_HOME}/bin/sqlplus -s -l sdw_admin/${PASS} @enable_ords_sdw_admin
}

source /etc/profile

unzip -o /files/ords*.zip -d ${ORDS_HOME}

sed -i -E 's:#PASSWORD#:'${PASS}':g' /files/ords_params.properties
sed -i -E 's:#ORACLE_SID#:'${ORACLE_SID}':g' /files/ords_params.properties
cp -rf /files/ords_params.properties ${ORDS_HOME}/params
cd ${ORDS_HOME}
cd ..
CURR_DIR=$(pwd)
cd ${ORDS_HOME}
java -jar ords.war configdir $CURR_DIR
java -jar ords.war install simple

# tune some ORDS default settings
java -jar ords.war set-property jdbc.InitialLimit 6
java -jar ords.war set-property jdbc.MinLimit 6
java -jar ords.war set-property jdbc.MaxLimit 40
java -jar ords.war set-property jdbc.MaxConnectionReuseCount 10000

# sqldev web: ords >= 19.4
if [ ${INSTALL_SQLDEVWEB} == "true" ]; then
    java -jar ords.war set-property feature.sdw true
    java -jar ords.war set-property restEnabledSql.active true
    java -jar ords.war set-property database.api.enabled true
    java -jar ords.war set-property security.verifySSL false
fi

chmod 777 defaults.xml

# copy files
cp -rf ${ORDS_HOME}/ords.war ${TOMCAT_HOME}/webapps/
cp -rf ${ORACLE_HOME}/apex/images ${TOMCAT_HOME}/webapps/i
if [ ! -z "${APEX_PATCH_SET_BUNDLE_FILE}" ]; then
    if ls /files/apexpatch/*/images 1> /dev/null 2>&1; then
        cp -rf /files/apexpatch/*/images/* ${TOMCAT_HOME}/webapps/i/
    fi
fi

# sqldev web: ords >= 19.4
if [ ${INSTALL_SQLDEVWEB} == "true" ]; then
    cd /files
    create_sdw_admin_user
    enable_ords_sdw_admin
fi
