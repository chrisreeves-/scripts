#!/bin/bash
hostname=$HOSTNAME
echo -e "What server are you sending the key to?: \c "
read server
scp /root/.ssh/id_rsa root@$server:/root/.ssh/id_rsa.$hostname
echo "Sent root ssh key to $server"
