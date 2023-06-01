#!/bin/bash

# Enable Apache mod_headers if not already
package="headers"
if [ $(apache2ctl -M 2>/dev/null | grep -c "$package") -eq 0 ];
then
  echo "Installing $package"
  a2enmod $package
else
  echo "$package is already installed"
fi

# Add Apache2 headers
if grep -q "# CUSTOM: Configure headers" /etc/apache2/apache2.conf; then
    echo "Apache2 headers already exist, skipping ..."
else
    echo "Apache2 headers not found, adding ..."
    echo "" >> /etc/apache2/apache2.conf
    echo "# CUSTOM: Configure headers" >> /etc/apache2/apache2.conf
    echo "Header set X-Content-Type-Options nosniff" >> /etc/apache2/apache2.conf
    echo "Header set Content-Security-Policy \"default-src 'self';\"" >> /etc/apache2/apache2.conf
    echo "Header set Referrer-Policy \"no-referrer\"" >> /etc/apache2/apache2.conf
    echo "Header always set Permissions-Policy \"fullscreen 'none' \"" >> /etc/apache2/apache2.conf
    echo "Header always append X-Frame-Options DENY" >> /etc/apache2/apache2.conf
fi