FROM oraclelinux:7.6

MAINTAINER Daniel Hochleitner <dhochleitner@posteo.de>

# environment variables
ENV INSTALL_APEX=true \
    INSTALL_SQLCL=true \
    INSTALL_LOGGER=true \
    INSTALL_OOSUTILS=true \
    INSTALL_AOP=true \
    INSTALL_SWAGGER=true \
    DBCA_TOTAL_MEMORY=2048 \
    ORACLE_SID=orcl \
    SERVICE_NAME=orcl \
    DB_INSTALL_VERSION=19 \
    ORACLE_BASE=/u01/app/oracle \
    ORACLE_HOME12=/u01/app/oracle/product/12.2.0.1/dbhome \
    ORACLE_HOME18=/u01/app/oracle/product/18.0.0/dbhome \
    ORACLE_HOME19=/u01/app/oracle/product/19.0.0/dbhome \
    ORACLE_INVENTORY=/u01/app/oraInventory \
    PASS=oracle \
    ORDS_HOME=/u01/ords \
    JAVA_HOME=/opt/java \
    TOMCAT_HOME=/opt/tomcat \
    APEX_PASS=OrclAPEX1999! \
    APEX_ADDITIONAL_LANG= \
    TIME_ZONE=UTC

# copy all scripts
ADD scripts /scripts/

# copy all files
ADD files /files/

# image setup via shell script to reduce layers and optimize final disk usage
RUN /scripts/install_main.sh

# ssh, database and apex port
EXPOSE 22 1521 8080

# use ${ORACLE_BASE} without product subdirectory as data volume
VOLUME ["${ORACLE_BASE}"]

# entrypoint for database creation, startup and graceful shutdown
ENTRYPOINT ["/scripts/entrypoint.sh"]
