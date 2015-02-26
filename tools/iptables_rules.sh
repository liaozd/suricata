# refrush
iptables -F

# DROP anything
iptables -I INPUT -i wlan0 -p tcp -s 0/0 -j DROP

# Allow SSH
iptables -I INPUT -i wlan0 -p tcp -s 0/0 --dport 22 -j ACCEPT

# enable ICMP ping incoming client request
iptables -I INPUT -i wlan0 -p icmp --icmp-type 8 -s 0/0 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

iptables -I INPUT -i wlan0 -p icmp --icmp-type 0 -d 0/0 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Disable outgoing ICMP request
iptables -A OUTPUT -p icmp --icmp-type echo-request -j DROP
# OR
iptables -A OUTPUT -p icmp --icmp-type 8 -j DROP

# Disable incoming ICMP request
iptables -A INPUT -p icmp --icmp-type 8 -j DROP

# Stateful packet inspection
# save checking time if connect already established.
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
