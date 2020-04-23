#!/bin/bash

echo "......Checking Scripts......"
if [ ! -f /scripts/create_ca_wallet.sh ]; then
    echo "/scripts/create_ca_wallet.sh not found!"
    exit 1
fi
if [ ! -f /scripts/entrypoint.sh ]; then
    echo "/scripts/entrypoint.sh not found!"
    exit 1
fi
if [ ! -f /scripts/image_setup.sh ]; then
    echo "/scripts/image_setup.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_ame.sh ]; then
    echo "/scripts/install_ame.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_aop.sh ]; then
    echo "/scripts/install_aop.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_apex.sh ]; then
    echo "/scripts/install_apex.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_ca_wallet.sh ]; then
    echo "/scripts/install_ca_wallet.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_logger.sh ]; then
    echo "/scripts/install_logger.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_oosutils.sh ]; then
    echo "/scripts/install_oosutils.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_oracle12ee.sh ]; then
    echo "/scripts/install_oracle12ee.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_oracle18ee.sh ]; then
    echo "/scripts/install_oracle18ee.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_oracle19ee.sh ]; then
    echo "/scripts/install_oracle19ee.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_ords.sh ]; then
    echo "/scripts/install_ords.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_sqlcl.sh ]; then
    echo "/scripts/install_sqlcl.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_ssh.sh ]; then
    echo "/scripts/install_ssh.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_swagger.sh ]; then
    echo "/scripts/install_swagger.sh not found!"
    exit 1
fi
if [ ! -f /scripts/install_tomcat.sh ]; then
    echo "/scripts/install_tomcat.sh not found!"
    exit 1
fi
if [ ! -f /scripts/setenv.sh ]; then
    echo "/scripts/setenv.sh not found!"
    exit 1
fi
#
echo "......Checking Files......"
if [ ! -f /files/db_install_12.rsp ]; then
    echo "/files/db_install_12.rsp not found!"
    exit 1
fi
if [ ! -f /files/db_install_18.rsp ]; then
    echo "/files/db_install_18.rsp not found!"
    exit 1
fi
if [ ! -f /files/db_install_19.rsp ]; then
    echo "/files/db_install_19.rsp not found!"
    exit 1
fi
if [ ! -f /files/ords_params.properties ]; then
    echo "/files/ords_params.properties not found!"
    exit 1
fi
if [ ! -f /files/tomcat-users.xml ]; then
    echo "/files/tomcat-users.xml not found!"
    exit 1
fi
if [ ! -f /files/tomcat.service ]; then
    echo "/files/tomcat.service not found!"
    exit 1
fi
#
echo "......Checking Downloaded Files......"
if ! ls /files/gosu-amd64 1> /dev/null 2>&1; then
    echo "GOSU not found!"
    exit 1
fi
if ! ls /files/OpenJDK11U-jdk_*.tar.gz 1> /dev/null 2>&1; then
    echo "Java not found!"
    exit 1
fi
if [ ${DB_INSTALL_VERSION} == "12" ]; then
    if ! ls /files/linuxx64_12201_database.zip 1> /dev/null 2>&1; then
        echo "Oracle DB 12.2.0.1 not found!"
        exit 1
    fi
fi
if [ ${DB_INSTALL_VERSION} == "18" ]; then
    if ! ls /files/LINUX.X64_180000_db_home.zip 1> /dev/null 2>&1; then
        echo "Oracle DB 18.0.0 not found!"
        exit 1
    fi
fi
if [ ${DB_INSTALL_VERSION} == "19" ]; then
    if ! ls /files/LINUX.X64_193000_db_home.zip 1> /dev/null 2>&1; then
        echo "Oracle DB 19.0.0 not found!"
        exit 1
    fi
fi
if [ ${INSTALL_SQLCL} == "true" ]; then
    if ! ls /files/sqlcl*.zip 1> /dev/null 2>&1; then
        echo "SQLcl not found!"
        exit 1
    fi
fi
if [ ${INSTALL_LOGGER} == "true" ]; then
    if ! ls /files/logger_*.zip 1> /dev/null 2>&1; then
        echo "Logger not found!"
        exit 1
    fi
fi
if [ ${INSTALL_OOSUTILS} == "true" ]; then
    if ! ls /files/oos-utils*.zip 1> /dev/null 2>&1; then
        echo "OOS Utils not found!"
        exit 1
    fi
fi
if [ ${INSTALL_APEX} == "true" ]; then
    if ! ls /files/apex*.zip 1> /dev/null 2>&1; then
        echo "APEX not found!"
        exit 1
    fi
    if ! ls /files/apache-tomcat*.tar.gz 1> /dev/null 2>&1; then
        echo "Tomcat not found!"
        exit 1
    fi
    if ! ls /files/ords*.zip 1> /dev/null 2>&1; then
        echo "ORDS not found!"
        exit 1
    fi
    if [ ${INSTALL_AOP} == "true" ]; then
        if ! ls /files/aop_cloud_v*.zip 1> /dev/null 2>&1; then
            echo "APEX Office Print not found!"
            exit 1
        fi
    fi
    if [ ${INSTALL_AME} == "true" ]; then
        if ! ls /files/ame_cloud_v*.zip 1> /dev/null 2>&1; then
            echo "APEX Media Extension not found!"
            exit 1
        fi
    fi
    if [ ${INSTALL_SWAGGER} == "true" ]; then
        if ! ls /files/swagger-ui*.zip 1> /dev/null 2>&1; then
            echo "Swagger-UI not found!"
            exit 1
        fi
    fi
fi
#
echo "......Validations Done......"
