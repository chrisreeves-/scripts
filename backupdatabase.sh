#!/bin/bash
date=(`date +%d-%m-%Y-%I-%M`)
echo -e "Please specify mySQL login name: \c "
read mysqllogin
echo -e "Please specify mySQL login password: \c "
read mysqlpass
mysql -u $mysqllogin -p$mysqlpass -e "SHOW databases;"
echo -e "Please specify desired database name: \c "
read databasename
if [ ! -d /backups/$databasename ] ; then
mkdir -p /backups/$databasename
fi
mysqldump -u $mysqllogin -p$mysqlpass $databasename > /backups/$databasename/$databasename-$date.bak
retval=$?
if [ $retval -ne 0 ]; then
    echo "Return code was not zero but $retval"
else
    echo "Backup was succssful"
fi
echo "Backup is now placed in /backups/%database name%/"
