// vagrantの起動時mountエラー対応
sudo /etc/init.d/vboxadd setup

// Etc
sudo yum -y install vim gcc libcurl-devel git

// firewall
sudo systemctl stop firewalld

// SELinux
sudo sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

// Apache
sudo yum -y install httpd
sudo systemctl start httpd
sudo chmod 755 /var/log/httpd

// Ruby
sudo yum -y install ruby ruby-devel rubygems

// Elasticsearch
sudo vim /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-1.1]
name=Elasticsearch repository for 1.1.x packages
baseurl=http://packages.elasticsearch.org/elasticsearch/1.1/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
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
sudo vim /etc/td-agent/td-agent.conf
<source>
    type tail
    path /var/log/httpd/access_log
    pos_file /var/log/td-agent/access_log.pos
    format apache2
   tag apache.access
</source>

<match apache.access>
    type elasticsearch
   host localhost
   port 9200
    type_name access_log
   logstash_format true
   flush_interval 3s
</match>

