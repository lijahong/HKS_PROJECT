#!/bin/bash
getdata=$(mysql -u user -ptest123 -h 172.16.2.134 k8sweb -e 'select * from script_script order by id desc limit 1')

vmname=$(echo $getdata | gawk '{print $10}')
keypairname=$(echo $getdata | gawk '{print $11}')
flavor=$(echo $getdata | gawk '{print $12}')
image=$(echo $getdata | gawk '{print $13}')
vmcount=$(echo $getdata | gawk '{print $14}')
workerid=$(echo $getdata | gawk '{print $17}')
projectid=$(echo $getdata | gawk '{print $9}')

ssh 172.16.1.131 "/root/vagrantwork/setvagrant.sh '$vmname' '$keypairname' '$flavor' '$image' '$vmcount' '$workerid' '$projectid' "
