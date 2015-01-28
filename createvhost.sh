#!/bin/bash
echo -e "Please specify domain name: \c "
read domain
echo -e "Please specify the root vhost location *WITHOUT* trailing / example: /var/www/vhosts"
read vhost
mkdir -p $vhost/$domain
chown www-data:www-data $vhost/$domain -R
touch /var/log/apache2/$domain-error.log
touch /var/log/apache2/$domain-access.log
touch /etc/apache2/sites-available/$domain
echo -e "<VirtualHost *:80>" >> /etc/apache2/sites-available/$domain
echo -e "       ServerName $domain" >> /etc/apache2/sites-available/$domain
echo -e "       ServerAlias www.$domain" >> /etc/apache2/sites-available/$domain
echo -e "       DocumentRoot $vhost/$domain" >> /etc/apache2/sites-available/$domain
echo -e "               <Directory $vhost/$domain>" >> /etc/apache2/sites-available/$domain
echo -e "                       Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/sites-available/$domain
echo -e "                       AllowOverride all" >> /etc/apache2/sites-available/$domain
echo -e "               </Directory>" >> /etc/apache2/sites-available/$domain
echo -e "       ErrorLog /var/log/apache2/$domain-error.log" >> /etc/apache2/sites-available/$domain
echo -e "       CustomLog /var/log/apache2/$domain-access.log combined" >> /etc/apache2/sites-available/$domain
echo -e "</VirtualHost>" >> /etc/apache2/sites-available/$domain
a2ensite $domain
/etc/init.d/apache2 restart
touch $vhost/$domain/index.html
echo -e "<!DOCTYPE html>" >> $vhost/$domain/index.html
echo -e "<html>" >> $vhost/$domain/index.html
echo -e "<body>" >> $vhost/$domain/index.html
echo -e "<h1> Welcome to $domain</h1>" >> $vhost/$domain/index.html
echo -e "<p>This is the test page of $domain</p>" >> $vhost/$domain/index.html
echo -e "</body>" >> $vhost/$domain/index.html
echo -e "</html>" >> $vhost/$domain/index.html
echo "Created site $domain located at $vhost/$domain"
