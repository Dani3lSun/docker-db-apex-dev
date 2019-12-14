#!/bin/bash

# set environment
. /scripts/setenv.sh

# add hostname
echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
echo "127.0.0.1   $HOSTNAME" >> /etc/hosts

# set timezone
ln -s -f /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# start all components
# ssh
/usr/sbin/sshd
# oracle
if [ ${DB_INSTALL_VERSION} == "12" ]; then
    export ORACLE_HOME=${ORACLE_HOME12}
fi
if [ ${DB_INSTALL_VERSION} == "18" ]; then
    export ORACLE_HOME=${ORACLE_HOME18}
fi
if [ ${DB_INSTALL_VERSION} == "19" ]; then
    export ORACLE_HOME=${ORACLE_HOME19}
fi
gosu oracle bash -c "${ORACLE_HOME}/bin/lsnrctl start"
gosu oracle bash -c 'echo startup\; | ${ORACLE_HOME}/bin/sqlplus -s -l / as sysdba'
# tomcat
if [ ${INSTALL_APEX} == "true" ]; then
    gosu tomcat bash -c "${TOMCAT_HOME}/bin/startup.sh"
fi

# Infinite wait loop, trap interrupt/terminate signal for graceful termination
trap "gosu oracle bash -c 'echo shutdown immediate\; | ${ORACLE_HOME}/bin/sqlplus -S / as sysdba'" INT TERM
while true; do sleep 1; done
;;
