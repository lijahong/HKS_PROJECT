#!/bin/bash
#$1 = vmname
#$2 = keypair name
#$3 = flavor
#$4 = image
#$5 = vmcount
#$6 = workerid
#$7 = projectid

# set flavor
if [ $3 == "x1.small" ]
then
CPUS=2
MEMORY=2048
elif [ $3 == "x1.medium" ]
then
CPUS=2
MEMORY=4096
else 
CPUS=4
MEMORY=4096
fi

# set image
if [ $4 == "centos" ]
then
IMAGE='centos/7'
elif [ $4 == "ubuntu" ]
then
IMAGE='generic/ubuntu1804'
fi

# set dir and project name for vagrant
userdir="userdir$6"
userpro="userpro$7"

# path for activate setenv file at user dir

userpath="${userdir}/${userpro}"

# if userdir is not exist, create userdir
if [ ! -d $userdir ]
then
  mkdir $userdir
fi

# create key-pair
ssh-keygen -q -f /root/vagrantwork/userkey/$2 -N ""
chmod 600 /root/vagrantwork/userkey/$2.pub 
chmod 600 /root/vagrantwork/userkey/$2

# go to project dir
cd $userdir
mkdir $userpro
cd $userpro

# copy setenv file
cp /root/vagrantwork/setting/setenv.sh .

# move key-pair file
mv /root/vagrantwork/userkey/$2.pub .
mv /root/vagrantwork/userkey/$2 .

#vagrant init
vagrant init

# set env
source /root/$userpath/setenv.sh $1 $2 $CPUS $MEMORY $IMAGE $5 $7 $userpath

# get Vagrantfile Template and start make instance
cp /root/vagrantwork/Vagrantfile .
vagrant up --no-provision ; vagrant provision

# delete ansible node
target="${userpro}_${1}_ansible"
virsh destroy $target
virsh undefine $target --remove-all-storage
