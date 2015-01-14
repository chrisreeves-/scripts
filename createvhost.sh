#!/bin/bash
echo -e "Please specify domain name: \c "
read domain
mkdir -p /var/www/vhosts/$domain
chown www-data:www-data /var/www/vhosts/$domain -R
touch /var/log/apache2/$domain-error.log
touch /var/log/apache2/$domain-access.log
touch /etc/apache2/sites-available/$domain
echo -e "<VirtualHost *:80>" >> /etc/apache2/sites-available/$domain
echo -e "       ServerName $domain" >> /etc/apache2/sites-available/$domain
echo -e "       ServerAlias www.$domain" >> /etc/apache2/sites-available/$domain
echo -e "       DocumentRoot /var/www/vhosts/$domain" >> /etc/apache2/sites-available/$domain
echo -e "               <Directory /var/www/vhosts/$domain>" >> /etc/apache2/sites-available/$domain
echo -e "                       Options Indexes FollowSymLinks MultiViews" >> /etc/apache2/sites-available/$domain
echo -e "                       AllowOverride all" >> /etc/apache2/sites-available/$domain
echo -e "               </Directory>" >> /etc/apache2/sites-available/$domain
echo -e "       ErrorLog /var/log/apache2/$domain-error.log" >> /etc/apache2/sites-available/$domain
echo -e "       CustomLog /var/log/apache2/$domain-access.log combined" >> /etc/apache2/sites-available/$domain
echo -e "</VirtualHost>" >> /etc/apache2/sites-available/$domain
a2ensite $domain
/etc/init.d/apache2 restart
touch /var/www/vhosts/$domain/index.html
echo -e "<!DOCTYPE html>" >> /var/www/vhosts/$domain/index.html
echo -e "<html>" >> /var/www/vhosts/$domain/index.html
echo -e "<body>" >> /var/www/vhosts/$domain/index.html
echo -e "<h1> Welcome to $domain</h1>" >> /var/www/vhosts/$domain/index.html
echo -e "<p>This is the test page of $domain</p>" >> /var/www/vhosts/$domain/index.html
echo -e "</body>" >> /var/www/vhosts/$domain/index.html
echo -e "</html>" >> /var/www/vhosts/$domain/index.html
