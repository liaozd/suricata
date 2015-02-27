#!/user/bin/env bash

# vim settings
git clone git://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_basic_vimrc.sh

# install packages 
apt-get update
apt-get install -y vim tree sysv-rc-conf python-pip python-dev terminator whois links slurm

# install network monitor app
apt-get install -y tcpick bmon iftop

# install aniable
pip install ansible

# install wireshark
apt-get install -y wireshark
addgroup -quiet -system wireshark
chown root:wireshark /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap 
usermod -a -G wireshark apvera

# install webmin
apt-get install -y perl libnet-ssleay-perl libauthen-pam-perl libpam-runtime openssl libio-pty-perl apt-show-versions python
wget -P ~/Download/ http://www.webmin.com/download/deb/webmin-current.deb
dpkg --install ~/Download/webmin-current.deb

# prepare to install elasticsearch
# add-apt-repository ppa:webupd8team/java
# apt-get update
# apt-get install oracle-java7-installer
# java -version
