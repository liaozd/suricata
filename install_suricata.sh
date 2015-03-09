#!/usr/bin/env bash
# compile a suricata on a ubuntu machine

MYFULLPATH=`realpath dirname $0`
SRCPATH=`dirname $MYFULLPATH`
mkdir -p ~/Downloads

apt-get update
apt-get upgrade -y

# install tools needed
apt-get install -y vim tree whois links bmon iftop nmap cowsay realpath sysv-rc-conf htop

# vim settings
git clone git://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_basic_vimrc.sh

# install dependence package for suricata
apt-get install -y gcc
apt-get install -y pkg-config
apt-get install -y libjansson*

# install lua
apt-get install -y lua5.2

# for spatch
apt-get install -y coccinelle
apt-get install -y libmagic-dev

cd ~/Downloads
# Pre-installation requirements
# ref: https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Ubuntu_Installation
apt-get -y install libpcre3 libpcre3-dbg libpcre3-dev \
build-essential autoconf automake libtool libpcap-dev libnet1-dev \
libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 \
libgeoip-dev \
make libmagic-dev

# IPS
apt-get -y install libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev libnfnetlink0

# install LuaJIT
cd ~/Downloads
wget http://luajit.org/download/LuaJIT-2.0.3.tar.gz
tar -xvf LuaJIT-2.0.3.tar.gz
cd LuaJIT-2.0.3/
make && make install

# install libcap
cd ~/Downloads
wget http://people.redhat.com/sgrubb/libcap-ng/libcap-ng-0.7.4.tar.gz
tar -xzvf libcap-ng-0.7.4.tar.gz
cd libcap-ng-0.7.4
./configure 
make 
make install

# Cache libs
ldconfig

# TODO wget/curl download the latest version of suricata automatically
# http://unix.stackexchange.com/questions/7641/download-and-install-latest-deb-package-from-github-via-terminal
# https://redmine.openinfosecfoundation.org/projects/suricata/wiki/_logstash_kibana_and_suricata_json_output
# Suricata
cd ~/Downloads
wget http://www.openinfosecfoundation.org/download/suricata-2.1beta3.tar.gz
tar -xvf suricata-2.1beta3.tar.gz
cd suricata-2.1beta3/
./configure --enable-nfqueue --enable-geoip --enable-luajit --prefix=/usr --sysconfdir=/etc --localstatedir=/var
make
make install-full

# enable inline iptables init to /etc/rc.local
cd $SRCPATH
SHELLPATH=`realpath setup_inline_network.sh`
if [ -f $SHELLPATH ]; then 
    INSERT_LINE="sh $SHELLPATH"
    sed -i "s~^exit 0$~$INSERT_LINE\n&~" /etc/rc.local
fi

# enable suricata init 
cp $SRCPATH/config/suricata.conf /etc/init/

# install rule management Oinkmaster
apt-get install -y oinkmaster
# ref: https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Rule_Management_with_Oinkmaster
TOREPLACE="# url = http://www.emergingthreats.net/rules/emerging.rules.tar.gz"
REPLACETO="url = http://rules.emergingthreats.net/open/suricata/emerging.rules.tar.gz"
sed -i "s,$TOREPLACE,$REPLACETO,g" /etc/oinkmaster.conf
mkdir -p /etc/suricata/rules
oinkmaster -C /etc/oinkmaster.conf -o /etc/suricata/rules

#END message
cowsay suricata installation DONE!!

# Disable ubunut GUI
# update-rc.d -f lightdm disable
