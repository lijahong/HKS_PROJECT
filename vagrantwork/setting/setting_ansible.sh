#!/bin/bash
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
#sudo echo "sslverify=0" >> /etc/yum.repos.d/kubernetes.repo
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

systemctl stop firewalld && systemctl disable firewalld
systemctl stop NetworkManager && systemctl disable NetworkManager

cat <<-'EOF' >/etc/sysctl.d/k8s.conf
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

# package install and update
yum -y install ca-certificates openssl nss
yum -y update
yum -y install vim

# Add Docker’s official GPG key
curl -4fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 패키지 캐시 업데이트
sudo yum clean all
sudo yum -y makecache

# ssh install
sudo yum -y install openssh-server
sudo systemctl enable sshd
sudo systemctl start sshd

#ansible install
sudo yum -y install epel-release
sudo yum -y install ansible
