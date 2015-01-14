#!/bin/bash
date=(`date +%d-%m-%Y-%I-%M`)
# echo -e "What is the root to the websites: \c "
# read var
echo -e "What is the domain name: \c "
read domain
echo ## Create backup location ##
mkdir -p /backups/$domain
tar cvf /backups/$domain/$domain-$date.tar /var/www/vhosts/$domain
