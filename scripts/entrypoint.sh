#!/bin/bash

# set environment
. /scripts/setenv.sh

# add hostname
echo "127.0.0.1 $HOSTNAME" >> /etc/hosts

# set timezone
ln -s -f /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# start all components
# ssh
/usr/sbin/sshd
# oracle
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
