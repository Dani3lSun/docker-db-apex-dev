#!/bin/bash

echo "extracting SQLCL..."
unzip /files/sqlcl*.zip -d /opt > /dev/null
chown -R oracle:oinstall /opt/sqlcl
rm -f /files/sqlcl*.zip

echo "export PATH=/opt/sqlcl/bin:\$PATH" >> /home/oracle/.bash_profile
echo "export PATH=/opt/sqlcl/bin:\$PATH" >> /home/oracle/.bashrc # .bash_profile not executed by docker
echo "export PATH=/opt/sqlcl/bin:\$PATH" >> /root/.bash_profile
echo "export PATH=/opt/sqlcl/bin:\$PATH" >> /root/.bashrc # .bash_profile not executed by docker
