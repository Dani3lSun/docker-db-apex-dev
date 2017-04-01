#!/bin/bash
cd /files

tar -xzf jdk-8*.tar.gz
mv jdk1.8* ${JAVA_HOME}
echo 'JAVA_HOME=${JAVA_HOME}' >> /etc/profile
echo 'PATH=$PATH:$HOME/bin:$JAVA_HOME/bin' >> /etc/profile
echo 'export JAVA_HOME' >> /etc/profile
echo 'export PATH' >> /etc/profile
source /etc/profile
