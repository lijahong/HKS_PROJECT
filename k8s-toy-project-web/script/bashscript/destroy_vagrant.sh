#!/bin/bash

projectid=$1

getdata=$(mysql -u user -ptest123 -h 172.16.2.134 k8sweb -e "select * from script_script where id=${projectid}")

mysql -u user -ptest123 -h 172.16.2.134 k8sweb -e "delete from script_script where id=${projectid}"

pid=$(echo $getdata | gawk '{print $9}')
uid=$(echo $getdata | gawk '{print $17}')

ssh 172.16.1.131 "/root/vagrantwork/deletevagrant.sh '$uid' '$pid'"
