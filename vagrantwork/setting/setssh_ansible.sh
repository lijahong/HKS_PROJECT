#!/bin/bash
#$1 = private ip
#$2 = vm count

P_IP=$1
VM_COUNT=$2
echo 'start'

# create known_hosts for root

mkdir /root/.ssh
touch /root/.ssh/known_hosts 

chmod 700 /root/.ssh 
chmod 600 /root/.ssh/known_hosts

# ssh setting

sudo cat <<EOF >> /etc/ssh/ssh_config
Host ${P_IP}*
  Identityfile /root/.ssh/project.pem
EOF

master_ip="${P_IP}10"
sudo ssh-keyscan $master_ip >> /root/.ssh/known_hosts

sudo cat <<EOF > /etc/ansible/hosts 
[master]
$master_ip
[worker]
EOF

for (( i=1 ; i <= $2 ; i++ ))
do
a=$[ 10 + i ]
get_ip="${P_IP}${a}"
sudo ssh-keyscan $get_ip >> /root/.ssh/known_hosts
sudo echo "$get_ip" >> /etc/ansible/hosts 
done

sudo mv /home/vagrant/project.pem /root/.ssh/project.pem
sudo systemctl restart sshd

# setting file for get token

sudo touch result.txt
sudo chmod 777 result.txt

# make kubernetes cluster

kubeip="${P_IP}10"

echo "start cluster"
ansible master -m shell -a 'sudo kubeadm init'
echo "init complete"
ansible master -m shell -a 'kubeadm token create --print-join-command' > result.txt
joinworker=$(cat result.txt | grep 'kubeadm' )
ansible worker -m shell -a "sudo $joinworker"

# get user k8s admin authentication

ansible master -m shell -a "mkdir -p /home/vagrant/.kube ; sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config ; sudo chown 1000:1000 /home/vagrant/.kube/config"

# install k8s list

echo "setting infra"
ansible-playbook /home/vagrant/set_infra.yml
echo "set infra complete...pls wait for boot"
sleep 15
echo "complete"
