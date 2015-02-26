#!/bin/bash

#Install Java
add-apt-repository -y ppa:webupd8team/java
apt-get update
debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
apt-get -y install oracle-java7-installer 

#Install Logstash Forwarder
cd /tmp/
wget https://assets.digitalocean.com/articles/logstash/logstash-forwarder_0.3.1_i386.deb
dpkg -i logstash-forwarder_0.3.1_i386.deb
cd /etc/init.d/
# link fail
# wget https://raw.github.com/elasticsearch/logstash-forwarder/master/logstash-forwarder.init -O logstash-forwarder
wget 'https://gist.github.com/mikedevita/178c3a503c3d325ef899/raw/3e5aebc0c2e777879a430dd28382648cc92ce5b4/logstash-forwarder.init' -O logstash-forwarder
chmod +x logstash-forwarder
update-rc.d logstash-forwarder defaults

#Download Certificate
apt-get install -y sshpass
mkdir -p /etc/logstash-forwarder
cd /etc/logstash-forwarder

sshpass -p "v1rtual@!" scp azureuser@AP-ELK-SG01.cloudapp.net:/etc/logstash/logstash.crt /tmp/
mv /tmp/logstash.crt /etc/logstash-forwarder/

#Create Log Forwarder configuration file
CONF="/etc/logstash-forwarder/logstash-forwarder.conf"
echo '{' > $CONF
echo '  "network": {' >> $CONF
echo '    "servers": [ "AP-ELK-SG01.cloudapp.net:5000" ],' >> $CONF
echo '    "timeout": 15,' >> $CONF
echo '    "ssl ca": "/etc/logstash-forwarder/logstash.crt"' >> $CONF
echo '  },' >> $CONF
echo '  "files": [' >> $CONF
echo '    {' >> $CONF
echo '      "paths": [ "/var/log/suricata/eve.json" ],' >> $CONF
echo '      "codec": { "type": "json" }' >> $CONF
echo '    }' >> $CONF
echo '   ]' >> $CONF
echo '}' >> $CONF
