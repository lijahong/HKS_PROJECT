#!/bin/bash

echo "start destroy"
userdir="userdir${1}"
userpro="userpro${2}"
cd /root/${userdir}/${userpro}
vagrant destroy --force
rm -rf /root/${userdir}/${userpro}
echo "destroy complete"
