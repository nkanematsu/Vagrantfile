#!/bin/sh

# Etc
sudo yum -y update
sudo yum -y install vim gcc libcurl-devel git java-1.7.0-openjdk-devel.x86_64

# firewall
sudo systemctl stop firewalld
sudo chkconfig firewalld off

# SELinux
sudo setenforce 0
sudo sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

# Apache
sudo yum -y install httpd httpd-devel
sudo cp -f /vagrant/httpd.conf /etc/httpd/conf/httpd.conf
sudo systemctl start httpd
sudo chkconfig httpd on
sudo chmod 755 /var/log/httpd

# Ruby
sudo yum -y install ruby ruby-devel rubygems

# Elasticsearch
sudo cp /vagrant/elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
sudo yum -y install elasticsearch
sudo systemctl start elasticsearch
sudo chkconfig elasticsearch on

# Kibana
curl -L -O https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz
tar zxvf kibana-3.1.0.tar.gz
sudo mv kibana-3.1.0 /var/www/html/kibana

# Fluenrd
curl -L http://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
sudo gem install json --no-ri --no-rdoc
sudo gem install fluentd --no-ri --no-rdoc
sudo td-agent-gem install fluent-plugin-elasticsearch
sudo touch /var/log/td-agent/access_log.pos
sudo chown td-agent:td-agent /var/log/td-agent/access_log.pos
sudo chmod 755 /var/log/td-agent/access_log.pos
sudo sh -c "cat /vagrant/td-agent.conf >> /etc/td-agent/td-agent.conf"
sudo /etc/init.d/td-agent start
