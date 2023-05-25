# https://developers.cloudflare.com/support/troubleshooting/restoring-visitor-ips/restoring-original-visitor-ips/

output_file="/etc/apache2/conf-available/remoteip.conf"
ip_addresses=$(curl https://www.cloudflare.com/ips-v4)

if [ ! -f /etc/apache2/conf-available/remoteip.conf ]
then
    echo "Cloudflare remoteip config not found, creating ..."
    echo "RemoteIPHeader CF-Connecting-IP" > "$output_file"
    for ip in $ip_addresses; do
      echo "RemoteIPTrustedProxy $ip" >> "$output_file"
    done
else
    echo "Cloudflare remoteip config found, skipping ..."
fi

sed -i 's/LogFormat \"%h %l %u %t \\\"%r\\\" %>s %O \\\"%{Referer}i\\" \\"%{User-Agent}i\\i\\"" combined/LogFormat "%a %l %u %t \\"%r\\" %>s %O \\"%{Referer}i\\" \\"%{User-Agent}i\\"" combined/g' /etc/apache2/apache2.conf
a2enconf remoteip