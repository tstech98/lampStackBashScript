#!/bin/bash

#apache set up
echo "Setting up Apache2..."
sudo apt install -y apache2 apache2-utils
sudo systemctl start apache2
sudo systemctl enable apache2
sleep 5
echo "Apache install complete."
echo "Your Apache2 Version: $(apache2 -v)"
sleep 5
echo "Configuring ports..."
sleep 5
#trying to open ports
if lsof -Pi :80 -sTCP:LISTEN -t >/dev/null ; then
    echo "Port 80 is already open!"
    exit 1
else
    echo "Port 80 not open or allowed."
    sleep 5
    echo "Opening port 80 in ufw firewall..."
    sleep 5
    sudo ufw allow http
    echo "Port 80 (http) is now allowed."
fi

sleep 5
sudo chown www-data:www-data /var/www/html/ -R
echo "Enter server name here..."
echo "If no custom DNS set servername to localhost."
echo "Use command ServerName localhost as defualt."
sleep 10
sudo nano /etc/apache2/conf-available/servername.conf
echo "Server name added..."
sudo a2enconf servername.conf
sleep 5
echo "Rebooting apache2."
sudo systemctl reload apache2
sleep 5
echo "Testing apache2..."
sudo apache2ctl -t
echo "Apache2 set-up complete..."
sleep 3
echo "Setting up MariaDB..."
sudo apt install -y mariadb-server mariadb-client
echo "Activating MariaDB..."
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo "Begin MariaDB install..."
sleep 10
sudo mysql_secure_installation
echo "Your MariaDB version is: $(mariadb --version)"
echo "MariaDB setup complete."
sleep 10
echo "PHP Installing..."
sudo apt install -y php7.4 libapache2-mod-php7.4 php7.4-mysql php-common php7.4-cli php7.4-common php7.4-json php7.4-opcache php7.4-readline
echo "PHP packages installed."
echo "enable apache2..."
sudo a2enmod php7.4
sudo systemctl restart apache2
echo "Your php version is: $(php --version)"
echo "Creating php files..."
echo "If testing type <?php phpinfo(); ?>"
sleep 10
sudo nano /var/www/html/info.php
echo "Config complete."
echo "Visit 127.0.0.1/info.php or localhost/info.php"
echo "Your LAMP stack is complete! Woo!"
echo "Installing phpmyadmin GUI..."
sleep 5
sudo apt install phpmyadmin
echo "Adding files to phpmyadmin wizard..."
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/conf-available/phpmyadmin.conf
sudo a2enconf phpmyadmin
sudo systemctl reload apache2
echo "Testing files..."
file /etc/apache2/conf-enabled/phpmyadmin.conf
sleep 5
echo "Opening ufw ports 80 and 443 TCP..."
sudo ufw allow 80,443/tcp
echo "Your myphpadmin is now ready"
