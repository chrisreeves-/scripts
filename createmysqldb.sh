#!/bin/bash
# Asking questions from user
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
# Check no response for mySQL user name
if [ -z $mysqllogin];
  then
    echo "You did not enter a mySQL login name"
    exit
fi
# Check no response for mysql password
if [ -z $mysqlpass];
  then
    echo "You did not enter a mySQL password"
    exit
fi
# Check no response for database name
if [ -z $databasename];
  then
    echo "You did not enter a database name"
    exit
fi
# Check no response for database username
if [ -z $databaseuser];
  then
    echo "You did not enter a database username"
    exit
fi
# Check no response for database password
if [ -z $databasepass];
  then
    echo "You did not enter a database password"
    exit
fi
# Creating database
mysql -u $mysqllogin -p$mysqlpass -e "CREATE DATABASE $databasename;"
# Creating database user
mysql -u $mysqllogin -p$mysqlpass -e "CREATE USER '$databaseuser'@'localhost' IDENTIFIED BY '$databasepass';"
# Granting permissions for user to database
mysql -u $mysqllogin -p$mysqlpass -e "GRANT ALL PRIVILEGES ON $databasename.* TO '$databaseuser'@'localhost' IDENTIFIED BY '$databasepass';"
# Flushing privileges
mysql -u $mysqllogin -p$mysqlpass -e "FLUSH PRIVILEGES;"
# Advising user of database creation
echo "Created a database called $databasename with grant all privileges for $databaseuser"
