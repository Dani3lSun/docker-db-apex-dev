FROM oraclelinux:7.3

MAINTAINER Daniel Hochleitner <dhochleitner@posteo.de>

# environment variables
ENV INSTALL_APEX=true \
    INSTALL_SQLCL=true \
    DBCA_TOTAL_MEMORY=2048 \
    ORACLE_SID=db12c \
    SERVICE_NAME=db12c \
    ORACLE_BASE=/u01/app/oracle \
    ORACLE_HOME=/u01/app/oracle/product/12.2.0.1/dbhome \
    ORACLE_INVENTORY=/u01/app/oraInventory \
    PASS=oracle \
    ORDS_HOME=/u01/ords \
    JAVA_HOME=/opt/java \
    TOMCAT_HOME=/opt/tomcat \
    APEX_PASS=OrclAPEX12c! \
    APEX_ADDITIONAL_LANG= \
    APEX_ADDITIONAL_LANG_NLS= \
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
