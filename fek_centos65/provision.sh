#!/bin/sh

# Etc
sudo yum -y install vim git java-1.7.0-openjdk gcc libcurl-devel

# firewall
sudo service iptables stop
sudo chkconfig iptables off

# SELinux
sudo setenforce 0
sudo sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

# Apache
sudo yum -y install httpd httpd-devel
sudo cp -f /vagrant/httpd.conf /etc/httpd/conf/httpd.conf
sudo service httpd start
sudo chkconfig httpd on
sudo chmod 755 /var/log/httpd

# Ruby
cd
wget http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.2.tar.gz
tar zxvf ruby-2.2.2.tar.gz
cd ruby-2.2.2
./configure
make
sudo make install
sudo ln -s /usr/local/bin/ruby /usr/bin/ruby

# gem
cd
git clone https://github.com/rubygems/rubygems.git rubygems
cd rubygems
sudo ruby setup.rb
sudo ln -s /usr/local/bin/gem /usr/bin/gem

# Elasticsearch
sudo cp /vagrant/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
sudo yum -y install elasticsearch
sudo service elasticsearch start
sudo chkconfig elasticsearch on

# Fluenrd
curl -L http://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
sudo gem install json --no-ri --no-rdoc
sudo gem install fluentd --no-ri --no-rdoc
sudo td-agent-gem install fluent-plugin-elasticsearch
sudo touch /var/log/td-agent/access_log.pos
sudo chown td-agent:td-agent /var/log/td-agent/access_log.pos
sudo chmod 755 /var/log/td-agent/access_log.pos
sudo /etc/init.d/td-agent start

# Kibana
wget https://download.elastic.co/kibana/kibana/kibana-4.1.0-linux-x86.tar.gz
tar zxvf kibana-4.1.0-linux-x86.tar.gz
cd kibana-4.1.0-linux-x86
sudo ./bin/kibana > /dev/null 2>&1 &
