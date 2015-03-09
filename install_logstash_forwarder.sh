#!/bin/bash

#Install Java
#add-apt-repository -y ppa:webupd8team/java
#apt-get update
#debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
#debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
#apt-get -y install oracle-java7-installer 

#Install Logstash Forwarder 32bit
#cd /tmp/
#wget https://assets.digitalocean.com/articles/logstash/logstash-forwarder_0.3.1_i386.deb
#dpkg -i logstash-forwarder_0.3.1_i386.deb
#cd /etc/init.d/
# link fail
# wget https://raw.github.com/elasticsearch/logstash-forwarder/master/logstash-forwarder.init -O logstash-forwarder

#wget 'https://gist.github.com/mikedevita/178c3a503c3d325ef899/raw/3e5aebc0c2e777879a430dd28382648cc92ce5b4/logstash-forwarder.init' -O logstash-forwarder
#chmod +x logstash-forwarder
#update-rc.d logstash-forwarder defaults

# install GO to compile logstash-forwarder
mkdir -p ~/Downloads
cd ~/Downloads
echo "download to go1.4.2 to" `pwd`
wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz
echo 
tar -C /usr/local -xzf go1.4.2.linux-amd64.tar.gz
echo "uncompressing go1.4.2.linux-amd64.tar.gz ..."
echo -e '\nexport PATH=$PATH:/usr/local/go/bin\n' >> ~/.profile
source ~/.profile

# compile logstash-forwarder 64bit
echo "git clone logstash-forwarder repository to" `pwd`
git clone https://github.com/elasticsearch/logstash-forwarder.git
cd logstash-forwarder/
echo "go compiling ..."
go build

# copy the compile file to bin
DEST='/opt/logstash-forwarder/bin/'
mkdir -p $DEST 
cp logstash-forwarder $DEST

# download logstash.key to probe
mkdir -p /etc/logstash-forwarder
#sshpass -p "v1rtual@!" scp azureuser@collector.apvera.net:/etc/logstash/logstash.crt /tmp/
# apt-get install -y sshpass
scp collector:/etc/logstash/logstash.crt /tmp/
mv /tmp/logstash.crt /etc/logstash-forwarder/

#Create logstash-forwarder configuration file
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

# run
# /opt/logstash-forwarder/bin/logstash-forwarder -config /etc/logstash-forwarder/logstash-forwarder.conf
