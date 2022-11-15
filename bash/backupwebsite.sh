#!/bin/bash
date=(`date +%d-%m-%Y-%I-%M`)
echo -e "Please specify the root vhost location *WITHOUT* trailing / example: /var/www/vhosts"
read vhost
echo -e "What is the domain name: \c "
read domain
# Check no response for vhost location
if [ -z $vhost];
  then
    echo "You did not enter a vhost location"
    exit
fi
# Check no response for domain name
if [ -z $domain];
  then
    echo "You did not enter a domain name"
    exit
fi
## Create backup location ##
mkdir -p /backups/$domain
# Compressing and copy to backup location
tar cvf /backups/$domain/$domain-$date.tar $vhost/$domain
# Advising of backup location to user
echo "Backup is stored in /backups/$domain"
