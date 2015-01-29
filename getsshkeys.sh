#!/bin/bash
hostname=$HOSTNAME
echo "CAUTION!: This will remove the known_hosts file"
echo "Script to get keys from remote server and import into current user"
echo -e "What server are you getting the key from?: \c "
read rserver
echo -e "What credentials do you want to pass to the remote server?: \c "
read ruser
if [ $ruser = root ] ; then
	rm -rf ~/.ssh/known_hosts
	scp $ruser@$rserver:/root/.ssh/id_rsa ~/.ssh/id_rsa.$rserver
	chmod 400 /root/.ssh/id_rsa.$rserver
else
	rm -rf ~/.ssh/known_hosts
	scp $ruser@rserver:/home/$ruser/.ssh/id_rsa ~/.ssh/id_rsa.$rserver
	chmod 400 /root/.ssh/id_rsa.$rserver
fi
if [ ! -f ~/.ssh/config ] ; then
	touch ~/.ssh/config
fi
if
grep -Fxq "Hostname $rserver" ~/.ssh/config
then
	echo "Do not need to update config file"
else
	echo "Updating config file"
	echo "Host $rserver" >> ~/.ssh/config
	echo "  User root" >> ~/.ssh/config
	
	echo "  Hostname $rserver" >> ~/.ssh/config
	echo "  PreferredAuthentications publickey" >> ~/.ssh/config
	echo "  IdentityFile ~/.ssh/id_rsa.$rserver" >> ~/.ssh/config
fi
echo "Added SSH key for $rserver:$ruser"
