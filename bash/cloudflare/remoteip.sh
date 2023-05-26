# https://developers.cloudflare.com/support/troubleshooting/restoring-visitor-ips/restoring-original-visitor-ips/

output_file="/etc/apache2/conf-available/remoteip.conf"
ip_addresses_v4=$(curl https://www.cloudflare.com/ips-v4)
ip_addresses_v6=$(curl https://www.cloudflare.com/ips-v6)

# Add Cloudflare IPs to the remoteip config
if [ ! -f /etc/apache2/conf-available/remoteip.conf ]
then
    echo "Cloudflare remoteip config not found, creating ..."
    echo "RemoteIPHeader CF-Connecting-IP" > "$output_file"
    for ip in $ip_addresses_v4; do
      echo "RemoteIPTrustedProxy $ip" >> "$output_file"
    done
    for ip in $ip_addresses_v6; do
      echo "RemoteIPTrustedProxy $ip" >> "$output_file"
    done
else
    echo "Cloudflare remoteip config found, skipping ..."
fi

# Enable the Apache mod remoteip module
a2enmod remoteip

# Update the log format
sed -i 's/LogFormat \"%h %l %u %t \\\"%r\\\" %>s %O \\\"%{Referer}i\\\" \\\"%{User-Agent}i\\\"\" combined/LogFormat "%a %l %u %t \\"%r\\" %>s %O \\"%{Referer}i\\" \\"%{User-Agent}i\\"" combined/g' /etc/apache2/apache2.conf

# Enable the remoteip config
a2enconf remoteip

# Test the Apache config
apache2ctl configtest

# If the config test is successful, restart Apache
systemctl restart apache2