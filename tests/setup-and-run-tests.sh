#!/bin/bash

set +x

user=$1
host=$2
port=$3
tmp_dir="tmpsnaps-ups"

#get the name of snap to install - for now only amd64 snap is tested
snap=$(find "$(pwd)" -name ubuntu-personal-store\*.snap)

SSH_OPTS="-o StrictHostKeyChecking=no"
SSH_OPTS="$SSH_OPTS -p $port $user@$host"

ssh ${SSH_OPTS} "if [ -d $tmp_dir ]; then rm -rf $tmp_dir; fi; mkdir $tmp_dir;"

cd tests
./remote-install-snap.sh $user $host $port $snap $tmp_dir || { echo "Error: unable to deploy snap"; exit 1; }
scp -P $port ./run_tests.sh  $user@$host:~/$tmp_dir/
ssh ${SSH_OPTS} "cd ~/$tmp_dir && chmod +x run_tests.sh && ./run_tests.sh"

