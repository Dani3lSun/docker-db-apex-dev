#!/bin/bash
cd /files

tar -xzf OpenJDK11U-jdk_*.tar.gz
mv jdk-* ${JAVA_HOME}

echo 'JAVA_HOME='${JAVA_HOME} >> /etc/profile
echo 'PATH=$PATH:$HOME/bin:$JAVA_HOME/bin' >> /etc/profile
echo 'export JAVA_HOME' >> /etc/profile
echo 'export PATH' >> /etc/profile
source /etc/profile

echo "export JAVA_HOME=${JAVA_HOME}" >> /home/oracle/.bash_profile
echo "export JAVA_HOME=${JAVA_HOME}" >> /home/oracle/.bashrc # .bash_profile not executed by docker
echo "export JAVA_HOME=${JAVA_HOME}" >> /root/.bash_profile
echo "export JAVA_HOME=${JAVA_HOME}" >> /root/.bashrc # .bash_profile not executed by docker
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /home/oracle/.bash_profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /home/oracle/.bashrc # .bash_profile not executed by docker
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bash_profile
echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc # .bash_profile not executed by docker
