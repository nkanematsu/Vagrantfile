#!/bin/sh

// vagrantの起動時mountエラー対応
sudo /etc/init.d/vboxadd setup

// Etc
sudo yum -y install vim gcc libcurl-devel git

// firewall
sudo systemctl stop firewalld
sudo chkconfig firewalld off

// SELinux
sudo sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

// Apache
sudo yum -y install httpd
sudo systemctl start httpd
sudo chkconfig httpd on
sudo chmod 755 /var/log/httpd

// Ruby
sudo yum -y install ruby ruby-devel rubygems

// Elasticsearch
sudo cp elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
sudo yum -y install elasticsearch java-1.7.0-openjdk-devel.x86_64
sudo systemctl start elasticsearch
sudo chkconfig elasticsearch on

// Kibana
curl -L -O https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz
tar zxvf kibana-3.1.0.tar.gz
sudo mv kibana-3.1.0 /var/www/html/kibana

// Fluenrd
curl -L http://toolbelt.treasuredata.com/sh/install-redhat-td-agent2.sh | sh
sudo gem install json
sudo gem install fluentd --no-ri --no-rdoc
sudo td-agent-gem install fluent-plugin-elasticsearch
sudo /etc/init.d/td-agent start
sudo touch /var/log/td-agent/access_log.pos
sudo chmod 777 /var/log/td-agent/access_log.pos
sudo cat td-agent.conf >> /etc/td-agent/td-agent.conf

