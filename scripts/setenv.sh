#!/bin/bash

# disable SELinux
setenforce disabled

# Prevent owner issues on mounted folders
chown -R oracle:dba ${ORACLE_BASE}
rm -f ${ORACLE_BASE}/product
ln -s /u01/app/oracle-product ${ORACLE_BASE}/product

# Set environment variables
. ~/.bashrc

# Create tnsnames.ora
if [ -f "${ORACLE_HOME}/network/admin/tnsnames.ora" ]
then
    echo "tnsnames.ora found."
else
    echo "Creating tnsnames.ora"
    printf "${ORACLE_SID} =\n\
	(DESCRIPTION =\n\
	 (ADDRESS = (PROTOCOL = TCP)(HOST = $(hostname))(PORT = 1521))\n\
    (CONNECT_DATA = (SERVICE_NAME = ${SERVICE_NAME})))\n" > ${ORACLE_HOME}/network/admin/tnsnames.ora
fi

# Create listener.ora
if [ -f "${ORACLE_HOME}/network/admin/listener.ora" ]
then
    echo "listener.ora found."
else
    echo "SID_LIST_LISTENER =" > ${ORACLE_HOME}/network/admin/listener.ora
    echo "  (SID_LIST =" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "     (SID_DESC =" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "       (SID_NAME = ${ORACLE_SID})" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "       (ORACLE_HOME = ${ORACLE_HOME})" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "     )" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "  )" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "LISTENER =" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "  (DESCRIPTION_LIST =" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "    (DESCRIPTION =" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "      (ADDRESS = (PROTOCOL = TCP)(HOST = $(hostname))(PORT = 1521))" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "      (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1521))" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "    )" >> ${ORACLE_HOME}/network/admin/listener.ora
    echo "  )" >> ${ORACLE_HOME}/network/admin/listener.ora
fi

# fix ownership and access rights
chown oracle:dba ${ORACLE_HOME}/network/admin/tnsnames.ora
chmod 664 ${ORACLE_HOME}/network/admin/tnsnames.ora
chown oracle:dba ${ORACLE_HOME}/network/admin/listener.ora
chmod 664 ${ORACLE_HOME}/network/admin/listener.ora
