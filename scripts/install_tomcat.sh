#!/bin/bash

mkdir ${TOMCAT_HOME}
groupadd tomcat
useradd -M -s /bin/nologin -g tomcat -d ${TOMCAT_HOME} tomcat

cd /files
tar -xzf apache-tomcat*.tar.gz -C ${TOMCAT_HOME} --strip-components=1
sed -i -E 's:#PASSWORD#:'${PASS}':g' /files/tomcat-users.xml
mv /files/tomcat-users.xml ${TOMCAT_HOME}/conf
chown -R tomcat:tomcat ${TOMCAT_HOME}
sed -i -E 's:#JAVA_HOME#:'${JAVA_HOME}':g' /files/tomcat.service
sed -i -E 's:#TOMCAT_HOME#:'${TOMCAT_HOME}':g' /files/tomcat.service
mv /files/tomcat.service /etc/systemd/system/tomcat.service

# create setenv.sh
echo 'export CATALINA_HOME="'${TOMCAT_HOME}'"' > ${TOMCAT_HOME}/bin/setenv.sh
echo 'export JAVA_HOME="'${JAVA_HOME}'"' >> ${TOMCAT_HOME}/bin/setenv.sh
echo 'export CATALINA_OPTS="$CATALINA_OPTS -Xms256m"' >> ${TOMCAT_HOME}/bin/setenv.sh
echo 'export CATALINA_OPTS="$CATALINA_OPTS -Xmx512m"' >> ${TOMCAT_HOME}/bin/setenv.sh
echo 'export CATALINA_OPTS="$CATALINA_OPTS -server"' >> ${TOMCAT_HOME}/bin/setenv.sh
echo 'export CATALINA_OPTS="$CATALINA_OPTS -XX:PermSize=128m"' >> ${TOMCAT_HOME}/bin/setenv.sh
echo 'export CATALINA_OPTS="$CATALINA_OPTS -XX:MaxPermSize=256m"' >> ${TOMCAT_HOME}/bin/setenv.sh
chmod a+x ${TOMCAT_HOME}/bin/setenv.sh

# fix some tomcat settings
echo 'tomcat.util.http.parser.HttpParser.requestTargetAllow=|' >> ${TOMCAT_HOME}/conf/catalina.properties
sed -i -E 's/(allow=").*(")/allow=".*"/g' ${TOMCAT_HOME}/webapps/manager/META-INF/context.xml
sed -i -E 's/(allow=").*(")/allow=".*"/g' ${TOMCAT_HOME}/webapps/host-manager/META-INF/context.xml

# add to path
echo 'export CATALINA_HOME="'${TOMCAT_HOME}'"' > ${TOMCAT_HOME}/.profile
echo 'export JAVA_HOME="'${JAVA_HOME}'"' >> ${TOMCAT_HOME}/.profile
chmod a+x ${TOMCAT_HOME}/.profile
