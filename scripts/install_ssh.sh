#!/bin/bash

# install openssh
yum install -y openssh-server

# set root password
echo 'root:'${PASS} | chpasswd
# generate ssh keys
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

# SSH login fix. Otherwise user is kicked off after login
echo "export VISIBLE=now" >> /etc/profile
sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# copy keys-file, so that we can later ssh without password
if [ -f /files/authorized_keys ]; then
    sed -i 's/#PermitRootLogin yes/PermitRootLogin without-password/' /etc/ssh/sshd_config
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    # set authorized_keys file root
    mkdir /root/.ssh/
    cp /files/authorized_keys /root/.ssh/
    restorecon -r -vv  /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
    # set authorized_keys file oracle
    mkdir /home/oracle/.ssh/
    cp /files/authorized_keys /home/oracle/.ssh/
    chown -R oracle:oinstall /home/oracle/.ssh/
    restorecon -r -vv  /home/oracle/.ssh
    chmod 600 /home/oracle/.ssh/authorized_keys
fi
