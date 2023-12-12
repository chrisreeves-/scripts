#!/bin/bash
echo -e "Please specify domain name: \c "
read domain
echo -e "Please specify the root vhost location *WITHOUT* trailing / example: /var/www/vhosts"
read vhost
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
mysql -u $mysqllogin -p$mysqlpass -e "CREATE DATABASE $databasename;"
mysql -u $mysqllogin -p$mysqlpass -e "CREATE USER '$databaseuser'@'localhost' IDENTIFIED BY '$databasepass';"
mysql -u $mysqllogin -p$mysqlpass -e "GRANT ALL PRIVILEGES ON $databasename.* TO '$databaseuser'@'localhost' IDENTIFIED BY '$databasepass';"
mysql -u $mysqllogin -p$mysqlpass -e "FLUSH PRIVILEGES;"
mkdir -p /tmp/wordpress
cd /tmp/wordpress
wget http://wordpress.org/latest.tar.gz
tar xvf /tmp/wordpress/latest.tar.gz
mv /tmp/wordpress/wordpress/* $vhost/$domain
chown www-data:www-data $vhost/$domain/wp-content
mv $vhost/$domain/wp-config-sample.php $vhost/$domain/wp-config.php
sed -i s/"define('DB_NAME', 'database_name_here');"/"define('DB_NAME', '$databasename');"/  $vhost/$domain/wp-config.php
sed -i s/"define('DB_USER', 'username_here');"/"define('DB_USER', '$databaseuser');"/  $vhost/$domain/wp-config.php
sed -i s/"define('DB_PASSWORD', 'password_here');"/"define('DB_PASSWORD', '$databasepass');"/ $vhost/$domain/wp-config.php
sed -i "/define('AUTH_KEY'/d" $vhost/$domain/wp-config.php
sed -i "/define('SECURE_AUTH_KEY/d" $vhost/$domain/wp-config.php
sed -i "/define('LOGGED_IN_KEY'/d" $vhost/$domain/wp-config.php
sed -i "/define('NONCE_KEY'/d" $vhost/$domain/wp-config.php
sed -i "/define('AUTH_SALT'/d" $vhost/$domain/wp-config.php
sed -i "/define('SECURE_AUTH_SALT'/d" $vhost/$domain/wp-config.php
sed -i "/define('LOGGED_IN_SALT'/d" $vhost/$domain/wp-config.php
wget -O salts.php https://api.wordpress.org/secret-key/1.1/salt/ 
sed -i -e "/define('NONCE_SALT[^\n]*/{r salts.php" -e "d}" $vhost/$domain/wp-config.php
rm salts.php
rm -rf /tmp/wordpress
