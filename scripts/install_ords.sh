#!/bin/bash
#PASSWORD=${1:-secret}
source /etc/profile

unzip -o /files/ords*.zip -d ${ORDS_HOME}

sed -i -E 's:#PASSWORD#:'${PASS}':g' /files/ords_params.properties
sed -i -E 's:#ORACLE_SID#:'${ORACLE_SID}':g' /files/ords_params.properties
cp -rf /files/ords_params.properties ${ORDS_HOME}/params
cd ${ORDS_HOME}
cd ..
CURR_DIR=`pwd`
cd ${ORDS_HOME}
java -jar ords.war configdir $CURR_DIR
java -jar ords.war install simple

# tune some ORDS default settings
sed -i -E '/<\/properties>/d' defaults.xml
echo '<entry key="jdbc.InitialLimit">6</entry>' >> defaults.xml
echo '<entry key="jdbc.MaxConnectionReuseCount">10000</entry>' >> defaults.xml
echo '<entry key="jdbc.MaxLimit">40</entry>' >> defaults.xml
echo '<entry key="jdbc.MinLimit">6</entry>' >> defaults.xml
echo '</properties>' >> defaults.xml
chmod 777 defaults.xml

cp -rf ${ORDS_HOME}/ords.war ${TOMCAT_HOME}/webapps/
cp -rf ${ORACLE_HOME}/apex/images ${TOMCAT_HOME}/webapps/i
