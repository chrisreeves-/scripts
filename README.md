<h2> Overview </h2>

This is just a small collection of bash scripts I have put together over the last year to help with administration
of Linux based servers.

<h2> Decriptions: </h2>

1. backupdatabase.sh = Connects to the local mySQL server, does a backup of the database you specify to /backups/%database%
2. backupwebsite.sh = Asks for website domain, tars the website to /backups/$domain with the date appended to the tar file
3. createmysqldb.sh = Asks for mysql creds & db vars, creates db with vars and grants user "grant all priv"
4. createvhost.sh = Asks for domain, creates folder & logs, creates file conf file for site, enables site, restarts Apache
and creates simple html landing page.
5. generatesshkeys.sh = Creates 4096 ssh key, creates authorized_keys file, imports new key to authorized_keys
6. getsshkeys.sh = Asks for host and username, scp to get file from server and appends .server, change file mod to 400, then
adds details to config file
7. instwordpress.sh = Asks for website domain and mysql cred vars, creates vhost & logs & apache conf & enables domain.
Creates mysql user and db, downloads latest version of WP, reconfigs wp-config and resalts, cleans up files
8. removedatabase.sh = Asks for mysql creds & db name, removes user and db & flushes
9. removevhost.sh = Asks for domain, disables site, restarts Apache, removes website files, logs and conf.
10. sendsshkeys.sh = Asks for server to send to, scp root key to server and append file with .server
11. update_upgrade.sh = Uses aptitude to update then upgrade
