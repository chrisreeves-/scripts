#!/bin/bash
hostname=$HOSTNAME
echo -e "What server are you sending the key to?: \c "
read server
echo -e "What user name do you want to pass credentials as?: \c "
read user
scp /root/.ssh/id_rsa root@$server:/root/.ssh/id_rsa.$hostname
