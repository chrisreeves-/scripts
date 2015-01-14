#!/bin/bash
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
mysql -u $mysqllogin -p$mysqlpass -e "CREATE DATABASE $databasename;"
mysql -u $mysqllogin -p$mysqlpass -e "CREATE USER '$databaseuser'@'localhost' IDENTIFIED BY '$databasepass';"
mysql -u $mysqllogin -p$mysqlpass -e "GRANT ALL PRIVILEGES ON $databasename.* TO '$databaseuser'@'localhost' IDENTIFIED BY '$databasepass';"
mysql -u $mysqllogin -p$mysqlpass -e "FLUSH PRIVILEGES;"
