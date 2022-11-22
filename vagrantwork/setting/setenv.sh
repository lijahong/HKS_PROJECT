#!/bin/bash

echo VM_NAME=$1 > .env
echo KEY_PAIR_NAME=$2 >> .env 
echo CPUS=$3 >> .env
echo MEMORY=$4 >> .env
echo IMAGE=$5 >> .env
echo VM_COUNT=$6 >> .env
echo USERPATH=$8 >> .env

pid=$7

managerip_add=$[ 20 + $pid ]
managerip="211.183.3.$managerip_add"
echo MIP=$managerip >> .env

privatenet="10.10.$pid."
echo PIP=$privatenet >> .env

mport=$[ 30000 + $pid ]
aport=$[ 40000 + $pid ]
wport=$[ 50000 + $pid * 10 ]

echo MPORT=$mport >> .env
echo APORT=$aport >> .env
echo WPORT=$wport >> .env
