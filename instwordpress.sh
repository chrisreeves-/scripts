#!/bin/bash
## Create a Wordpress site bash script ##
echo -e "Please specify domain name: \c "
read domain
echo -e "Please specify mySQL login name: \c "
read mysqllogin
echo -e "Please specify mySQL login password: \c "
read mysqlpass
echo -e "Please specify desired database name: \c "
read databasename
echo -e "Please specify desired database username: \c "
read databaseuser
echo -e "Please specify desired database password: \c "
read databasepass
echo ## Creating vhost folders ##
mkdir -p /var/www/vhosts/$domain
chown www-data:www-data /var/www/vhosts/$domain -R
echo ## Creating vhost log files ##
touch /var/log/apache2/$domain-error.log
touch /var/log/apache2/$domain-access.log
echo ## Creating vhost ##
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
echo ## Enabling vhost ##
a2ensite $domain
/etc/init.d/apache2 restart
echo ## Creating Database ##
mysql -u $mysqllogin -p$mysqlpass -e "CREATE DATABASE $databasename;"
mysql -u $mysqllogin -p$mysqlpass -e "CREATE USER '$databaseuser'@'localhost' IDENTIFIED BY '$databasepass';"
mysql -u $mysqllogin -p$mysqlpass -e "GRANT ALL PRIVILEGES ON $databasename.* TO '$databaseuser'@'localhost' IDENTIFIED BY '$databasepass';"
mysql -u $mysqllogin -p$mysqlpass -e "FLUSH PRIVILEGES;"
echo ## Installing Wordpress ##
mkdir -p /tmp/wordpress
cd /tmp/wordpress
wget http://wordpress.org/latest.tar.gz
tar xvf /tmp/wordpress/latest.tar.gz
mv /tmp/wordpress/wordpress/* /var/www/vhosts/$domain
chown www-data:www-data /var/www/vhosts/$domain/wp-content
## Modifying Wordpress Configuration ##
mv /var/www/vhosts/$domain/wp-config-sample.php /var/www/vhosts/$domain/wp-config.php
sed -i s/"define('DB_NAME', 'database_name_here');"/"define('DB_NAME', '$databasename');"/  /var/www/vhosts/$domain/wp-config.php
sed -i s/"define('DB_USER', 'username_here');"/"define('DB_USER', '$databaseuser');"/  /var/www/vhosts/$domain/wp-config.php
sed -i s/"define('DB_PASSWORD', 'password_here');"/"define('DB_PASSWORD', '$databasepass');"/ /var/www/vhosts/$domain/wp-config.php
echo ## Salt Wordpress Configuration ##
sed -i "/define('AUTH_KEY'/d" /var/www/vhosts/$domain/wp-config.php
sed -i "/define('SECURE_AUTH_KEY/d" /var/www/vhosts/$domain/wp-config.php
sed -i "/define('LOGGED_IN_KEY'/d" /var/www/vhosts/$domain/wp-config.php
sed -i "/define('NONCE_KEY'/d" /var/www/vhosts/$domain/wp-config.php
sed -i "/define('AUTH_SALT'/d" /var/www/vhosts/$domain/wp-config.php
sed -i "/define('SECURE_AUTH_SALT'/d" /var/www/vhosts/$domain/wp-config.php
sed -i "/define('LOGGED_IN_SALT'/d" /var/www/vhosts/$domain/wp-config.php
wget -O salts.php https://api.wordpress.org/secret-key/1.1/salt/ 
sed -i -e "/define('NONCE_SALT[^\n]*/{r salts.php" -e "d}" /var/www/vhosts/$domain/wp-config.php
rm salts.php
echo ## Clean Up ##
rm -rf /tmp/wordpress
