#!/bin/bash
echo -e "Please specify mySQL login name: \c "
read mysqllogin
echo -e "Please specify mySQL login password: \c "
read mysqlpass
echo -e "Please specify desired database name: \c "
read databasename
echo -e "Please specify desired database username: \c "
read databaseuser
mysql -u $mysqllogin -p$mysqlpass -e "DROP DATABASE $databasename;"
if [ $databaseuser = 'root' ] ;
then echo "Cannot be root"
else
mysql -u $mysqllogin -p$mysqlpass -e "DROP USER '$databaseuser'@'localhost';" ;
fi ;
mysql -u $mysqllogin -p$mysqlpass -e "FLUSH PRIVILEGES;"
echo "Deleted $databasename and $databaseuser from mySQL"
