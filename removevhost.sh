#!/bin/bash
echo -e "Please specify domain name: \c "
read domain
echo -e "Please specify the root vhost location *WITHOUT* trailing / example: /var/www/vhosts"
read vhost
a2dissite $domain
service apache2 restart
rm -rf $vhost/$domain
rm -rf /var/log/apache2/$domain*.*
rm -rf /etc/apache2/sites-available/$domain
echo "Removed $domain, log files and conf file
