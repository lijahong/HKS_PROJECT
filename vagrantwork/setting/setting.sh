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

# Extras 저장소 활성화
sudo yum-config-manager --enable extras

# 패키지의 최신 릴리스 설치
sudo yum install container-selinux

# install docker
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl start docker && sudo systemctl enable docker
#k8s
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

sudo yum install -y kubelet-1.21.0-0.x86_64 kubeadm-1.21.0-0.x86_64 kubectl-1.21.0-0.x86_64 --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
sudo sed -i 's/cri//g' /etc/containerd/config.toml
sudo systemctl restart containerd

echo "complete setting"
