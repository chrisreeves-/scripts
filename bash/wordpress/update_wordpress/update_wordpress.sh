fqdn="example.com" # Change to your domain name
full_path="/var/www/hosts/wordpress" # Change to the full path of your wordpress installation

# Download Wordpress CLI if it doesn't exist
if [ -f "/usr/local/bin/wp" ];
then
  echo "Wordpress cli file already exists"
else
  echo "Downloading Wordpress CLI"
  cd /mnt/datadisk/apps; curl --silent -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
fi

# Move Wordpress CLI to PATH
if [ -f "/usr/local/bin/wp" ];
then
  echo "Wordpress cli file already exists"
else
  echo "Move Wordpress CLI to PATH"
  rm -rf /usr/local/bin/wp
  mv /mnt/datadisk/apps/wp-cli.phar /usr/local/bin/wp
fi

# Make Wordpress CLI executable
echo "Making Wordpress CLI executable"
chmod +x /usr/local/bin/wp

# Update Wordpress CLI to latest
wp --allow-root cli update

echo "Make $fqdn writable for the update"
chown www-data:www-data $full_path -R
chmod 777 $full_path -R

# Check Wordpress for new version
echo "Checking for a new version of Wordpress for $fqdn"
wp --allow-root core check-update --path=$full_path

# Update version
wp --allow-root core update --path=$full_path

# Update all plugins
echo "Updating all plugins for $fqdn"
sudo -u ubuntu -i -- wp --allow-root plugin update --path=$full_path --all

# Update all themes
echo "Updating all themes"
sudo -u ubuntu -i -- wp --allow-root theme update --path=$full_path --all

file="wp-config.php"
path=$full_path
chown nobody:nogroup -R $path/*
find $path -type d -exec chmod 755 {} \;
find $path -type f -exec chmod 644 {} \;

# Reapply Wordpress security controls
if test -f "$path/$file"; then
	echo "Detected as a Wordpress website - applying Wordpress security controls"
	chown www-data:www-data -R $path/wp-content/uploads/
	chmod 444 $path/wp-config.php
	chmod 444 $path/.htaccess
else
	echo "Not a Wordpress site, applied non-wordpress controls"
fi