#!/usr/bin/env bash
sudo -i

cp -a /etc/network/interfaces /etc/network/interfaces.back


####################################
######## virutalbox settings #######
####################################
echo """
# The virtual internal NIC
auto eth1
iface eth1 inet static
  address 192.168.0.1
  network 192.168.0.0
  netmask 255.255.255.0
  broadcast 192.168.0.255""" >> /etc/network/interfaces

ping -c 3 -W 10 ubuntu.com

config server share internet connection with client
modprobe iptable_nat
echo '1' | sudo tee /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth1 -j ACCEPT
##### vituralbox settings end ######
