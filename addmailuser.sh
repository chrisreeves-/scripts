#!/bin/bash
echo -e "Please specify mail username: \c "
read user
# Check no response
if [ -z $user];
  then
    echo "You did not enter a user name"
    exit
fi
adduser $user
echo -e "$user: $user" >> /etc/aliases
echo Activating new alias
newaliases
echo "Mail user added""
