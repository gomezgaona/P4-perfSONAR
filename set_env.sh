#!/bin/bash

lab_num=$1
if [ $lab_num == "lab3" ]; then
#Host h1
/home/admin/containernet/util/m h1 disable_offloading.sh h1-eth0 &> /dev/null 
/home/admin/containernet/util/m h1 ifconfig h1-eth0 hw ether 00:00:00:00:00:01
/home/admin/containernet/util/m h1 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h1 arp -s 10.0.0.3 00:00:00:00:00:03
#Host h2
/home/admin/containernet/util/m h2 disable_offloading.sh h2-eth0 &> /dev/null
/home/admin/containernet/util/m h2 ifconfig h2-eth0 hw ether 00:00:00:00:00:02
/home/admin/containernet/util/m h2 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h2 arp -s 10.0.0.3 00:00:00:00:00:03
#Host h3
/home/admin/containernet/util/m h3 disable_offloading.sh h3-eth0 &> /dev/null
/home/admin/containernet/util/m h3 ifconfig h3-eth0 hw ether 00:00:00:00:00:03
/home/admin/containernet/util/m h3 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h3 arp -s 10.0.0.2 00:00:00:00:00:02
elif [ $lab_num == "lab4" ]; then
#Host h1
/home/admin/containernet/util/m h1 disable_offloading.sh h1-eth0 &> /dev/null 
/home/admin/containernet/util/m h1 ifconfig h1-eth0 hw ether 00:00:00:00:00:01
/home/admin/containernet/util/m h1 arp -s 10.0.0.2 00:00:00:00:00:02
#Host h2
/home/admin/containernet/util/m h2 disable_offloading.sh h2-eth0 &> /dev/null
/home/admin/containernet/util/m h2 ifconfig h2-eth0 hw ether 00:00:00:00:00    

:02
/home/admin/containernet/util/m h2 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h2 iptables -I OUTPUT -p icmp --icmp-type destination-unreachable -j DROP
#
elif [ $lab_num == "lab5" ]; then
#Host h1
/home/admin/containernet/util/m h1 disable_offloading.sh h1-eth0 &> /dev/null 
/home/admin/containernet/util/m h1 ifconfig h1-eth0 hw ether 00:00:00:00:00:01
/home/admin/containernet/util/m h1 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h1 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h1 arp -s 10.0.0.4 00:00:00:00:00:04
#Host h2
/home/admin/containernet/util/m h2 disable_offloading.sh h2-eth0 &> /dev/null
/home/admin/containernet/util/m h2 ifconfig h2-eth0 hw ether 00:00:00:00:00:02
/home/admin/containernet/util/m h2 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h2 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h2 arp -s 10.0.0.4 00:00:00:00:00:04
#Host h3
/home/admin/containernet/util/m h3 disable_offloading.sh h3-eth0 &> /dev/null
/home/admin/containernet/util/m h3 ifconfig h3-eth0 hw ether 00:00:00:00:00:03
/home/admin/containernet/util/m h3 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h3 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h3 arp -s 10.0.0.4 00:00:00:00:00:04
#Host h4
/home/admin/containernet/util/m h4 disable_offloading.sh h4-eth0 &> /dev/null
/home/admin/containernet/util/m h4 ifconfig h4-eth0 hw ether 00:00:00:00:00:04
/home/admin/containernet/util/m h4 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h4 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h4 arp -s 10.0.0.3 00:00:00:00:00:03
#Switch s1
#/home/admin/containernet/util/m s1 tc qdisc add dev s1-eth0 root tbf rate 100mbit burst 50000 limit 125000

elif [ $lab_num == "lab6" ]; then
	
	#router r1
	/home/admin/containernet/util/m r1 ifconfig r1-eth0 10.0.0.1/24
	/home/admin/containernet/util/m r1 ifconfig r1-eth1 20.0.0.1/24

	echo "IP addresses configured in the router interfaces"
	
	# Enable IPv4 forwarding	
	/home/admin/containernet/util/m r1 sysctl -w net.ipv4.ip_forward=1 >> /dev/null
	
	echo "IPv4 forwarding enabled"
	
	# Static routes
	#Host perfSONAR1
	docker exec mn.perfSONAR1 disable_offloading.sh perfSONAR1-eth0 &> /dev/null
	docker exec mn.perfSONAR1 ifconfig perfSONAR1-eth0 10.0.0.10/24
	docker exec mn.perfSONAR1 ifconfig perfSONAR1-eth0 hw ether 00:00:00:00:00:01
	docker exec mn.perfSONAR1 ip route add 20.0.0.0/24 via 10.0.0.1

	#Host perfSONAR2
	docker exec mn.perfSONAR2 disable_offloading.sh perfSONAR2-eth0 &> /dev/null
	docker exec mn.perfSONAR2 ifconfig perfSONAR2-eth0 20.0.0.10/24
	docker exec mn.perfSONAR2 ifconfig perfSONAR2-eth0 hw ether 00:00:00:00:00:02
	docker exec mn.perfSONAR2 ip route add 10.0.0.0/24 via 20.0.0.1 
	docker exec mn.perfSONAR1 systemctl stop opensearch 
	
	echo "Static routes configured in perfSONAR nodes"
	
	# Starting opensearch
	docker exec mn.perfSONAR2 systemctl stop opensearch
	docker exec mn.perfSONAR1 systemctl start opensearch
	
	# Link conditions
	# perfSONAR1-->r1
	/home/admin/containernet/util/m r1 tc qdisc add dev r1-eth0 root handle 1: netem delay 20ms
	
	echo "Link conditions established"	
	
elif [ $lab_num == "lab7" ]; then
#Host h1
/home/admin/containernet/util/m h1 disable_offloading.sh h1-eth0 &> /dev/null 
/home/admin/containernet/util/m h1 ifconfig h1-eth0 hw ether 00:00:00:00:00:01
/home/admin/containernet/util/m h1 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h1 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h1 arp -s 10.0.0.4 00:00:00:00:00:04
/home/admin/containernet/util/m h1 arp -s 10.0.0.5 00:00:00:00:00:05
/home/admin/containernet/util/m h1 arp -s 10.0.0.6 00:00:00:00:00:06
/home/admin/containernet/util/m h1 arp -s 10.0.0.7 00:00:00:00:00:07
/home/admin/containernet/util/m h1 arp -s 10.0.0.8 00:00:00:00:00:08
#Host h2
/home/admin/containernet/util/m h2 disable_offloading.sh h2-eth0 &> /dev/null
/home/admin/containernet/util/m h2 ifconfig h2-eth0 hw ether 00:00:00:00:00:02
/home/admin/containernet/util/m h2 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h2 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h2 arp -s 10.0.0.4 00:00:00:00:00:04
/home/admin/containernet/util/m h2 arp -s 10.0.0.5 00:00:00:00:00:05
/home/admin/containernet/util/m h2 arp -s 10.0.0.6 00:00:00:00:00:06
/home/admin/containernet/util/m h2 arp -s 10.0.0.7 00:00:00:00:00:07
/home/admin/containernet/util/m h2 arp -s 10.0.0.8 00:00:00:00:00:08
#Host h3
/home/admin/containernet/util/m h3 disable_offloading.sh h3-eth0 &> /dev/null
/home/admin/containernet/util/m h3 ifconfig h3-eth0 hw ether 00:00:00:00:00:03
/home/admin/containernet/util/m h3 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h3 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h3 arp -s 10.0.0.4 00:00:00:00:00:04
/home/admin/containernet/util/m h3 arp -s 10.0.0.5 00:00:00:00:00:05
/home/admin/containernet/util/m h3 arp -s 10.0.0.6 00:00:00:00:00:06
/home/admin/containernet/util/m h3 arp -s 10.0.0.7 00:00:00:00:00:07
/home/admin/containernet/util/m h3 arp -s 10.0.0.8 00:00:00:00:00:08
#Host h4
/home/admin/containernet/util/m h4 disable_offloading.sh h4-eth0 &> /dev/null
/home/admin/containernet/util/m h4 ifconfig h4-eth0 hw ether 00:00:00:00:00:04
/home/admin/containernet/util/m h4 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h4 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h4 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h4 arp -s 10.0.0.5 00:00:00:00:00:05
/home/admin/containernet/util/m h4 arp -s 10.0.0.6 00:00:00:00:00:06
/home/admin/containernet/util/m h4 arp -s 10.0.0.7 00:00:00:00:00:07
/home/admin/containernet/util/m h4 arp -s 10.0.0.8 00:00:00:00:00:08
#Host h5
/home/admin/containernet/util/m h5 disable_offloading.sh h5-eth0 &> /dev/null
/home/admin/containernet/util/m h5 ifconfig h5-eth0 hw ether 00:00:00:00:00:05
/home/admin/containernet/util/m h5 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h5 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h5 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h5 arp -s 10.0.0.4 00:00:00:00:00:04
/home/admin/containernet/util/m h5 arp -s 10.0.0.6 00:00:00:00:00:06
/home/admin/containernet/util/m h5 arp -s 10.0.0.7 00:00:00:00:00:07
/home/admin/containernet/util/m h5 arp -s 10.0.0.8 00:00:00:00:00:08
#Host h6
/home/admin/containernet/util/m h6 disable_offloading.sh h6-eth0 &> /dev/null
/home/admin/containernet/util/m h6 ifconfig h6-eth0 hw ether 00:00:00:00:00:06
/home/admin/containernet/util/m h6 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h6 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h6 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h6 arp -s 10.0.0.4 00:00:00:00:00:04
/home/admin/containernet/util/m h6 arp -s 10.0.0.5 00:00:00:00:00:05
/home/admin/containernet/util/m h6 arp -s 10.0.0.7 00:00:00:00:00:07
/home/admin/containernet/util/m h6 arp -s 10.0.0.8 00:00:00:00:00:08
#Host h7
/home/admin/containernet/util/m h7 disable_offloading.sh h7-eth0 &> /dev/null
/home/admin/containernet/util/m h7 ifconfig h7-eth0 hw ether 00:00:00:00:00:07
/home/admin/containernet/util/m h7 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h7 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h7 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h7 arp -s 10.0.0.4 00:00:00:00:00:04
/home/admin/containernet/util/m h7 arp -s 10.0.0.5 00:00:00:00:00:05
/home/admin/containernet/util/m h7 arp -s 10.0.0.6 00:00:00:00:00:06
/home/admin/containernet/util/m h7 arp -s 10.0.0.8 00:00:00:00:00:08
#Host h8
/home/admin/containernet/util/m h8 disable_offloading.sh h8-eth0 &> /dev/null
/home/admin/containernet/util/m h8 ifconfig h8-eth0 hw ether 00:00:00:00:00:08
/home/admin/containernet/util/m h8 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h8 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h8 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h8 arp -s 10.0.0.4 00:00:00:00:00:04
/home/admin/containernet/util/m h8 arp -s 10.0.0.5 00:00:00:00:00:05
/home/admin/containernet/util/m h8 arp -s 10.0.0.6 00:00:00:00:00:06
/home/admin/containernet/util/m h8 arp -s 10.0.0.7 00:00:00:00:00:07
elif [ $lab_num == "lab8" ]; then
#Host h1
/home/admin/containernet/util/m h1 disable_offloading.sh h1-eth0 &> /dev/null 
/home/admin/containernet/util/m h1 ifconfig h1-eth0 hw ether 00:00:00:00:00:01
/home/admin/containernet/util/m h1 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h1 arp -s 10.0.0.3 00:00:00:00:00:03
#Host h2
/home/admin/containernet/util/m h2 disable_offloading.sh h2-eth0 &> /dev/null
/home/admin/containernet/util/m h2 ifconfig h2-eth0 hw ether 00:00:00:00:00:02
/home/admin/containernet/util/m h2 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h2 arp -s 10.0.0.3 00:00:00:00:00:03
#Host h3
/home/admin/containernet/util/m h3 disable_offloading.sh h3-eth0 &> /dev/null
/home/admin/containernet/util/m h3 ifconfig h3-eth0 hw ether 00:00:00:00:00:03
/home/admin/containernet/util/m h3 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h3 arp -s 10.0.0.2 00:00:00:00:00:02
elif [ $lab_num == "lab9" ]; then
/home/admin/containernet/util/m h1 ifconfig h1-eth0 hw ether 00:00:00:00:00:01
/home/admin/containernet/util/m h2 ifconfig h2-eth0 hw ether 00:00:00:00:00:02
/home/admin/containernet/util/m h3 ifconfig h3-eth0 hw ether 00:00:00:00:00:03
/home/admin/containernet/util/m h4 ifconfig h4-eth0 hw ether 00:00:00:00:00:04

/home/admin/containernet/util/m h1 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h1 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h1 arp -s 10.0.0.4 00:00:00:00:00:04

/home/admin/containernet/util/m h2 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h2 arp -s 10.0.0.3 00:00:00:00:00:03
/home/admin/containernet/util/m h2 arp -s 10.0.0.4 00:00:00:00:00:04

/home/admin/containernet/util/m h3 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h3 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h3 arp -s 10.0.0.4 00:00:00:00:00:04

/home/admin/containernet/util/m h4 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h4 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h4 arp -s 10.0.0.3 00:00:00:00:00:03

/home/admin/containernet/util/m h1 disable_offloading.sh h1-eth0 &> /dev/null 
/home/admin/containernet/util/m h2 disable_offloading.sh h2-eth0 &> /dev/null 
/home/admin/containernet/util/m h3 disable_offloading.sh h3-eth0 &> /dev/null 
/home/admin/containernet/util/m h4 disable_offloading.sh h4-eth0 &> /dev/null 

#/home/admin/containernet/util/m h2 iptables -I OUTPUT -p icmp --icmp-type destination-unreachable -j DROP
#/home/admin/containernet/util/m h4 iptables -I OUTPUT -p icmp --icmp-type destination-unreachable -j DROP
elif [ $lab_num == "lab10" ]; then
#Host h1
/home/admin/containernet/util/m h1 disable_offloading.sh h1-eth0 &> /dev/null 
/home/admin/containernet/util/m h1 ifconfig h1-eth0 hw ether 00:00:00:00:00:01
/home/admin/containernet/util/m h1 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h1 arp -s 10.0.0.3 00:00:00:00:00:03
#Host h2
/home/admin/containernet/util/m h2 disable_offloading.sh h2-eth0 &> /dev/null
/home/admin/containernet/util/m h2 ifconfig h2-eth0 hw ether 00:00:00:00:00:02
/home/admin/containernet/util/m h2 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h2 arp -s 10.0.0.3 00:00:00:00:00:03
#Host h3
/home/admin/containernet/util/m h3 disable_offloading.sh h3-eth0 &> /dev/null
/home/admin/containernet/util/m h3 ifconfig h3-eth0 hw ether 00:00:00:00:00:03
/home/admin/containernet/util/m h3 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h3 arp -s 10.0.0.2 00:00:00:00:00:02
elif [ $lab_num == "lab11" ]; then
#Host h1
/home/admin/containernet/util/m h1 disable_offloading.sh h1-eth0 &> /dev/null 
/home/admin/containernet/util/m h1 ifconfig h1-eth0 hw ether 00:00:00:00:00:01
/home/admin/containernet/util/m h1 arp -s 10.0.0.2 00:00:00:00:00:02
/home/admin/containernet/util/m h1 arp -s 10.0.0.3 00:00:00:00:00:03
#Host h2
/home/admin/containernet/util/m h2 disable_offloading.sh h2-eth0 &> /dev/null
/home/admin/containernet/util/m h2 ifconfig h2-eth0 hw ether 00:00:00:00:00:02
/home/admin/containernet/util/m h2 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h2 arp -s 10.0.0.3 00:00:00:00:00:03
#Host h3
/home/admin/containernet/util/m h3 disable_offloading.sh h3-eth0 &> /dev/null
/home/admin/containernet/util/m h3 ifconfig h3-eth0 hw ether 00:00:00:00:00:03
/home/admin/containernet/util/m h3 arp -s 10.0.0.1 00:00:00:00:00:01
/home/admin/containernet/util/m h3 arp -s 10.0.0.2 00:00:00:00:00:02
fi
