#!/bin/bash
if [ ! -z $1 ] && [ $1 -gt 0 ] && [ $1 -lt 255 ];then
    sed -i '/^GATEWAY/d;/^IPADDR/d;/^NETMASK/d' /etc/sysconfig/network-scripts/ifcfg-eth0
    sed -i 's/dhcp/static/' /etc/sysconfig/network-scripts/ifcfg-eth0
    echo  "IPADDR=192.168.1.$1
NETMASK=255.255.255.0
GATEWAY=192.168.1.254"  >> /etc/sysconfig/network-scripts/ifcfg-eth0

else 
    echo '主机位[1-254]'  
fi
systemctl restart network
