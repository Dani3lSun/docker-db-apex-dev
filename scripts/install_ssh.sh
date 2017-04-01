#!/bin/bash

yum install -y openssh-server

echo 'root:'${PASS} | chpasswd
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
echo "export VISIBLE=now" >> /etc/profile

# copy keys-file, so that we can later ssh without password
if [ -f /files/authorized_keys ]; then
    sed -i 's/#PermitRootLogin yes/PermitRootLogin without-password/' /etc/ssh/sshd_config
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/' /etc/ssh/sshd_config
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    mkdir /root/.ssh/
    mv /files/authorized_keys /root/.ssh/
    restorecon -r -vv  /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
fi
