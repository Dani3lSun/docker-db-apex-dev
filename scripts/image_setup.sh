#!/bin/bash

# add hostname
echo "127.0.0.1 $HOSTNAME" >> /etc/hosts

# set timezone
ln -s -f /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

# clear folders
chmod -R 777 /files
chmod -R 777 /scripts
