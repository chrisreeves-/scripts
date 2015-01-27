#!/bin/bash
echo -e "Please specify domain name: \c "
read domain
a2dissite $domain
service apache2 restart
rm -rf /var/www/vhosts/$domain
rm -rf /var/log/apache2/$domain*.*
rm -rf /etc/apache2/sites-available/$domain
echo "Removed $domain, log files and conf file
