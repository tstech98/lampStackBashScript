#!/bin/bash
#Apache Set Up
echo "Setting up Apache2..."
sudo apt install -y apache2 apache2-utils
sudo systemctl start apache2
sudo systemctl enable apache2
#Trying To Open Ports
if lsof -Pi :80 -sTCP:LISTEN -t >/dev/null ; then
    exit 1
else
    sudo ufw allow http
fi

sudo chown www-data:www-data /var/www/html/ -R
sudo nano /etc/apache2/conf-available/servername.conf
sudo a2enconf servername.conf
sudo stemctl reload apache2
sudo apache2ctl -t
echo "Apache2 set-up complete..."

#MariaDB Set Up
echo "Setting up MariaDB..."
sudo apt install -y mariadb-server mariadb-client
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation

#PHP Set Up
echo "PHP Installing..."
sudo apt install -y php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline
sudo a2enmod php7.4
sudo systemctl restart apache2
sudo nano /var/www/html/info.php

#PHP My Admin Set Up
echo "Installing phpmyadmin GUI..."
sudo apt install phpmyadmin
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin
sudo systemctl reload apache2
file /etc/apache2/conf-enabled/phpmyadmin.conf
sudo ufw allow 80,443/tcp
