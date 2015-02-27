#!/usr/bin/env bash
# compile a ELK on a ubuntu machine

add-apt-repository -y ppa:webupd8team/java
apt-get update
debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get -y install oracle-java7-installer 

#Install Apache2 for Kabana
apt-get install -y apache2

#Download ELK Packages
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.4.deb
wget https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.2-1-2c0f5a1_all.deb
wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.2.tar.gz

#Install ELK Packages
dpkg -i elasticsearch*
update-rc.d elasticsearch defaults 95 10
/etc/init.d/elasticsearch start
dpkg -i logstash*
update-rc.d logstash defaults
tar -C /var/www/html -xzf kibana*

#Install ElasticHQ
cd /usr/share/elasticsearch/bin
./plugin -install royrusso/elasticsearch-HQ

#Configure Elasticsearch for Kibana
echo "http.cors.enabled: true" >> /etc/elasticsearch/elasticsearch.yml

#Start Services
service apache2 restart
service elasticsearch start
service logstash start
