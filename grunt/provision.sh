#!/bin/sh

# Etc
sudo yum -y install gcc libffi-devel vim

# firewall
sudo systemctl stop firewalld
sudo chkconfig firewalld off

# SELinux
sudo setenforce 0
sudo sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

# Apache
sudo yum -y install httpd httpd-devel
sudo systemctl start httpd
sudo chkconfig httpd on

# ruby
sudo yum install -y ruby rubygems ruby-devel
sudo gem install sass --no-ri --no-rdoc
sudo gem install ffi --no-ri --no-rdoc
sudo gem install compass --no-ri --no-rdoc
sudo gem install kss --no-ri --no-rdoc

# nodejs
sudo yum -y install epel-release
sudo yum -y install nodejs npm

# grunt
sudo npm install -g grunt-cli

# app
sudo cp -rf /vagrant/html/* /var/www/html/
cd /var/www/html
