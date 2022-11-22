#!/bin/bash

# get compute node cpu idle

compute1idle=$( echo $(ssh 172.16.1.132 'sar 1 3 | grep Average') | gawk '{print $8}')
compute2idle=$( echo $(ssh 172.16.1.133 'sar 1 3 | grep Average') | gawk '{print $8}')

# calculate cpu usage

computeusage1=$( echo " scale=2; 100.00 - $compute1idle " | bc )
computeusage2=$( echo " scale=2; 100.00 - $compute2idle " | bc )

# get rem usage

computemem_1=0
computemem_2=0

for (( i=1;i<=2; i++ ))
do 
ip=$[ 131 + $i ]
computememall=$( ssh 172.16.1.$ip 'free -m | grep Mem')
total=$( echo $computememall | gawk '{print $2}' )
free=$( echo $computememall | gawk '{print $4}' )
cache=$( echo $computememall | gawk '{print $6}' )

used=$[$total - $free - $cache]
usage=$( echo " scale=2; $used / $total" | bc )

if [ $i -eq 1 ]
then
computemem_1=$(echo $usage)
else
computemem_2=$(echo $usage)
fi
done

#calculate
com1=$( echo " $computeusage1 + $computemem_1 " | bc )
com2=$( echo " $computeusage2 + $computemem_2 " | bc )

#set float to int
com1_resource=$( echo "scale=2; $com1 * 100" | bc )
com2_resource=$( echo "scale=2; $com2 * 100" | bc )

com1_resource=${com1_resource%.*}
com2_resource=${com2_resource%.*}

#set node
if [[ $com1_resource -gt $com2_resource ]]
then
com_ip=172.16.1.133

elif [[ $com1_resource -eq $com2_resource ]]
then
com_ip=172.16.1.132

else
com_ip=172.16.1.132
fi

echo $com_ip
