#!/bin/bash

# make root ssh dir
sudo chmod 700 /home/vagrant/.ssh ;
mkdir /root/.ssh 
chmod 700 /root/.ssh 
touch /root/.ssh/authorized_keys 
chmod 600 /root/.ssh/authorized_keys

# sshd_config public key 설정 - manager, worker
sudo sed -i 's|#Port|Port|g' /etc/ssh/sshd_config
sudo sed -i 's|#StrictModes yes|StrictModes yes|g' /etc/ssh/sshd_config
sudo sed -i 's|#PubkeyAuthentication yes|PubkeyAuthentication yes|g' /etc/ssh/sshd_config
sudo sed -i 's|#PasswordAuthentication yes|PasswordAuthentication no|g' /etc/ssh/sshd_config
sudo sed -i 's|#AuthorizedKeysFile|AuthorizedKeysFile|g' /etc/ssh/sshd_config

sudo cat /home/vagrant/authorized_keys >> /root/.ssh/authorized_keys
sudo systemctl restart sshd
echo "ssh complete"
