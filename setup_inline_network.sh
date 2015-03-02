#!/bin/bash

EXTIF="eth1"
INTIF="eth0"

echo "External NIC: $EXTIF"
echo "Internal NIC: $INTIF"

FWVER=`iptables -V | cut -d " " -f2`
echo -e "\nSetup for suricata network. iptables version $FWVER..\n"
iptables -I FORWARD -j NFQUEUE --queue-num 0 #--queue-bypass

# router settings
iptables -t nat -A POSTROUTING -o "$EXTIF" -j MASQUERADE
echo "1" > /proc/sys/net/ipv4/ip_forward
echo "1" > /proc/sys/net/ipv4/ip_dynaddr

# offload the package for internal nic
echo -e "offload $INTIF\n"
ethtool --offload "$INTIF" rx off tx off

