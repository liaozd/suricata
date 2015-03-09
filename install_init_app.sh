#!/bin/bash
# setup for realpath

MYFULLPATH=`realpath dirname $0`
SRCPATH=`dirname $MYFULLPATH`

# enable inline iptables init to /etc/rc.local
cd $SRCPATH
SHELLPATH=`realpath setup_inline_network.sh`
if [ -f $SHELLPATH ]; then 
    INSERT_LINE="sh $SHELLPATH"
    sed -i "s~^exit 0$~$INSERT_LINE\n&~" /etc/rc.local
fi

# enable suricata init 
cp $SRCPATH/config/suricata.conf /etc/init/

