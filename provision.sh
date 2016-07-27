#!/bin/bash
sudo service vboxadd start

echo "Provisioning virtual machine..."
sudo yum update -y

#recommend installing vb-guest plugin.
#vagrant plugin install vagrant-vbguest

#Installing Base Packages.

echo "Installing Git"  
sudo yum install -y git 

echo "Installing Nginx"  
sudo rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
sudo yum install -y nginx


#Installing PHP.

#install PHP and a couple of essential extensions.
echo "Installing PHP"
sudo rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
sudo yum install -y php56w php56w-fpm
    
echo "Installing PHP extensions"
sudo yum install -y curl php56w-curl php56w-gd php56w-mcrypt php56w-mysql php56w-xml

sudo chkconfig php-fpm on
sudo service php-fpm restart

#php-fpm must be run as the vagrant user or session data is ignored in $MAGENTO_HOME/var/session
sudo sed -i 's/user = .*/user = vagrant/g' /etc/php-fpm.d/www.conf
sudo sed -i 's/group = .*/group = vagrant/g' /etc/php-fpm.d/www.conf

#Installing MySQL.

#sudo apt-get install -y debconf-utils

#we can use this tool to tell the MySQL installation process to stop prompting for a password and use the password from the command line instead.

#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password root123"
#sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password root123"

#install MySQL without getting the root password prompts.
sudo rpm -Uvh http://dev.mysql.com/get/mysql57-community-release-el6-7.noarch.rpm

#needed to get yum-config-manager to disable repos from cli
sudo yum install -y yum-utils

#disable mysql 5.7 and enable 5.6 repo
sudo yum-config-manager --disable mysql57-community
sudo yum-config-manager --enable mysql56-community

#install mysql 5.6
sudo yum install -y mysql-community-server
sudo chkconfig mysqld on
sudo service mysqld restart

#Installing and Configuring xdebug

sudo yum install -y php56w-pecl-xdebug
xdebugConfig=/etc/php.d/xdebug.ini
#echo 'zend_extension="'$(find / -name 'xdebug.so')'"'  >> /etc/php5/cli/php.ini
#sudo echo 'xdebug.default_enable = 1' >> /etc/php5/cli/php.ini
sudo echo 'xdebug.remote_enable=1' >> $xdebugConfig
#sudo echo 'xdebug.remote_handler=dbgp' >> /etc/php5/cli/php.ini
#sudo echo 'xdebug.remote_mode=req' >> /etc/php5/cli/php.ini
#sudo echo 'xdebug.remote_host=127.0.0.1' >> /etc/php5/cli/php.ini
#sudo echo 'xdebug.remote_port=9000' >> /etc/php5/cli/php.ini
sudo echo 'xdebug.idekey = "vagrant"' >> $xdebugConfig
sudo echo 'xdebug.remote_autostart = 0' >> $xdebugConfig
sudo echo 'xdebug.remote_log="/var/log/xdebug/xdebug.log"' >> $xdebugConfig


# Project Config changes - putting local config into place.
sudo cp /srv/murad/ops-config/os-local.xml /srv/murad/app/etc/local.xml

#changing folder permission for magento folders
#sudo chmod -R 0777 /srv/murad/var
#sudo chmod -R 0777 /srv/murad/media
#sudo chmod -R 0777 /srv/murad/app
#sudo chmod -R 0777 /srv/murad/downloader

#Generate tls cert - good for 1 year
sudo mkdir -p /etc/pki/tls/www
sudo openssl req -nodes -x509 -sha256 -newkey rsa:4096 -keyout /etc/pki/tls/www/key.pem -out /etc/pki/tls/www/cert.crt -days 365 -subj "/C=US/ST=CA/L=Huntington Beach/O=IT/CN=<nginx-server-name>.sb"

#Configuring Nginx

echo "Configuring Nginx"
sudo rm -f /etc/nginx/conf.d/*
#sudo cp /vagrant/nginx-config/nginx_vhost /etc/nginx/sites-available/nginx_vhost
sudo cp /vagrant/nginx-config/softphusion.sb.conf /etc/nginx/conf.d/softphusion.sb.conf
#sudo ln -s /etc/nginx/sites-available/nginx_vhost /etc/nginx/sites-enabled/
#sudo ln -s /etc/nginx/sites-available/muradupgrade.local.web /etc/nginx/sites-enabled/
#sudo rm -rf /etc/nginx/sites-available/default
sudo service nginx restart

cp /vagrant/<dbname>.sql.gz /home/vagrant/
gzip -d <dbname>.sql.gz


echo "DROP DATABASE IF EXISTS <dbname>; CREATE DATABASE <dbname>;" | mysql -u root
mysql -u root <dbname> < <dbname>.sql

rm -f <dbname>.sql
echo ""
echo ""
echo "Provisioning completed! Please run: vagrant reload"
