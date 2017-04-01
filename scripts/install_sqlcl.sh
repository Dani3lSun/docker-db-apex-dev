#!/bin/bash

echo "extracting SQLCL..."
unzip /files/sqlcl*.zip -d /opt > /dev/null
chown -R oracle:oinstall /opt/sqlcl
rm -f /files/sqlcl*.zip
