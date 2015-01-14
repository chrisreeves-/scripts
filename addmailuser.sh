#!/bin/bash
echo -e "Please specify mail username: \c "
read user
adduser $user
echo -e "$user: $user" >> /etc/aliases
echo Activating new alias
newaliases
