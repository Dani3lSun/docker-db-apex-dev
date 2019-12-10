#!/bin/bash

# add hostname
echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" > /etc/hosts
echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts
echo "127.0.0.1   $HOSTNAME" >> /etc/hosts

# folder permissions
chmod -R 777 /files
chmod -R 777 /scripts

# set timezone
ln -s -f /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# disable SELinux
setenforce disabled
if [ -f /etc/selinux/config ]; then
  sed -i -E 's:SELINUX=enforcing:SELINUX=disabled:g' /etc/selinux/config
fi

# update YUM
yum clean all
yum update -y
yum install -y openssl
