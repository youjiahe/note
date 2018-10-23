#!/bin/bash
    sed -i '/^GATEWAY/d;/^IPADDR/d;/^NETMASK/d' /etc/sysconfig/network-scripts/ifcfg-eth0
    sed -i 's/dhcp/static/' /etc/sysconfig/network-scripts/ifcfg-eth0
    echo  "IPADDR=$1
NETMASK=255.255.255.0
GATEWAY=192.168.1.254"  >> /etc/sysconfig/network-scripts/ifcfg-eth0
systemctl restart network
