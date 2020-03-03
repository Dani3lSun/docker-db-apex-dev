#!/bin/bash

echo "--------------------------------------------------"
echo "Environment Vars.................................."
echo "INSTALL_APEX: ${INSTALL_APEX}"
echo "INSTALL_SQLCL: ${INSTALL_SQLCL}"
echo "INSTALL_SQLDEVWEB: ${INSTALL_SQLDEVWEB}"
echo "INSTALL_LOGGER: ${INSTALL_LOGGER}"
echo "INSTALL_OOSUTILS: ${INSTALL_OOSUTILS}"
echo "INSTALL_AOP: ${INSTALL_AOP}"
echo "INSTALL_AME: ${INSTALL_AME}"
echo "INSTALL_SWAGGER: ${INSTALL_SWAGGER}"
echo "INSTALL_CA_CERTS_WALLET: ${INSTALL_CA_CERTS_WALLET}"
echo "DB_INSTALL_VERSION: ${DB_INSTALL_VERSION}"
echo "DBCA_TOTAL_MEMORY: ${DBCA_TOTAL_MEMORY}"
echo "ORACLE_SID: ${ORACLE_SID}"
echo "SERVICE_NAME: ${SERVICE_NAME}"
echo "ORACLE_BASE: ${ORACLE_BASE}"
echo "ORACLE_HOME12: ${ORACLE_HOME12}"
echo "ORACLE_HOME18: ${ORACLE_HOME18}"
echo "ORACLE_HOME19: ${ORACLE_HOME19}"
if [ ${DB_INSTALL_VERSION} == "12" ]; then
    export ORACLE_HOME=${ORACLE_HOME12}
fi
if [ ${DB_INSTALL_VERSION} == "18" ]; then
    export ORACLE_HOME=${ORACLE_HOME18}
fi
if [ ${DB_INSTALL_VERSION} == "19" ]; then
    export ORACLE_HOME=${ORACLE_HOME19}
fi
echo "ORACLE_HOME: ${ORACLE_HOME}"
echo "ORACLE_INVENTORY: ${ORACLE_INVENTORY}"
echo "PASS: ${PASS}"
echo "ORDS_HOME: ${ORDS_HOME}"
echo "JAVA_HOME: ${JAVA_HOME}"
echo "TOMCAT_HOME: ${TOMCAT_HOME}"
echo "APEX_PASS: ${APEX_PASS}"
echo "APEX_ADDITIONAL_LANG: ${APEX_ADDITIONAL_LANG}"
echo "TIME_ZONE: ${TIME_ZONE}"
#
#
echo "--------------------------------------------------"
echo "Validations......................................."
./scripts/validations.sh || exit 1
#
echo "--------------------------------------------------"
echo "Image Setup......................................."
./scripts/image_setup.sh
#
echo "--------------------------------------------------"
if [ ${DB_INSTALL_VERSION} == "12" ]; then
    echo "Installing ORACLE Database 12 EE......................"
    ./scripts/install_oracle12ee.sh
fi
if [ ${DB_INSTALL_VERSION} == "18" ]; then
    echo "Installing ORACLE Database 18 EE......................"
    ./scripts/install_oracle18ee.sh
fi
if [ ${DB_INSTALL_VERSION} == "19" ]; then
    echo "Installing ORACLE Database 19 EE......................"
    ./scripts/install_oracle19ee.sh
fi
#
echo "--------------------------------------------------"
echo "Installing JAVA..................................."
./scripts/install_java.sh
#
if [ ${INSTALL_SQLCL} == "true" ]; then
    echo "--------------------------------------------------"
    echo "Installing SQLCL.................................."
    ./scripts/install_sqlcl.sh
fi
#
if [ ${INSTALL_APEX} == "true" ]; then
    #
    echo "--------------------------------------------------"
    echo "Installing ORACLE APEX............................"
    ./scripts/install_apex.sh
    #
    echo "--------------------------------------------------"
    echo "Installing TOMCAT................................."
    ./scripts/install_tomcat.sh
    #
    echo "--------------------------------------------------"
    echo "Installing ORACLE ORDS............................"
    ./scripts/install_ords.sh
    #
    if [ ${INSTALL_AOP} == "true" ]; then
        echo "--------------------------------------------------"
        echo "Installing AOP...................................."
        ./scripts/install_aop.sh
    fi
    if [ ${INSTALL_AME} == "true" ]; then
        echo "--------------------------------------------------"
        echo "Installing AME...................................."
        ./scripts/install_ame.sh
    fi
    if [ ${INSTALL_SWAGGER} == "true" ]; then
        echo "--------------------------------------------------"
        echo "Installing Swagger................................"
        ./scripts/install_swagger.sh
    fi
    if [ ${INSTALL_CA_CERTS_WALLET} == "true" ]; then
        echo "--------------------------------------------------"
        echo "Installing APEX CA SSL Wallet....................."
        ./scripts/install_ca_wallet.sh
    fi
fi
#
if [ ${INSTALL_LOGGER} == "true" ]; then
    #
    echo "--------------------------------------------------"
    echo "Installing OraOpenSource Logger..................."
    ./scripts/install_logger.sh
fi
#
if [ ${INSTALL_OOSUTILS} == "true" ]; then
    #
    echo "--------------------------------------------------"
    echo "Installing OraOpenSource OOS Utils................"
    ./scripts/install_oosutils.sh
fi
#
echo "--------------------------------------------------"
echo "Installing SSH...................................."
./scripts/install_ssh.sh
#
echo "--------------------------------------------------"
echo "Cleanup..........................................."
yum clean all
rm -r -f /tmp/*
rm -r -f /files/*
rm -r -f /var/tmp/*
echo "--------------------------------------------------"
echo "DONE.............................................."
