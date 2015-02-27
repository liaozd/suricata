#!/bin/bash

# md5sum /etc/logstash-forwarder/logstash.crt

# /opt/logstash-forwarder/bin/logstash-forwarder -config /etc/logstash-forwarder/logstash-forwarder.conf

# cp `dirname $0`/config/suricata.conf /etc/init/

# install go to compile logstash-forwarder
cd ~
mkdir -p Downloads
cd Downloads
echo "download to go1.4.2 to" `pwd`
wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.4.2.linux-amd64.tar.gz
echo '\nexport PATH=$PATH:/usr/local/go/bin\n' >> $HOME/.profile


#install logstash-forwarder 64bit
echo "git clone logstash-forwarder repos to" `pwd`
git clone https://github.com/elasticsearch/logstash-forwarder.git
cd logstash-forwarder/
# compile to a excutable file
go build

DEST='/opt/logstash-forwarder/bin/'
mkdir -p $DEST 
cp logstash-forwarder $DEST

# get logstash.key
apt-get install -y sshpass
mkdir -p /etc/logstash-forwarder
sshpass -p "v1rtual@!" scp azureuser@collector.apvera.net:/etc/logstash/logstash.crt /tmp/
mv /tmp/logstash.crt /etc/logstash-forwarder/


#Create Log Forwarder configuration file
CONF="/etc/logstash-forwarder/logstash-forwarder.conf"
echo '{' > $CONF
echo '  "network": {' >> $CONF
echo '    "servers": [ "collector.apvera.net:5000" ],' >> $CONF
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
