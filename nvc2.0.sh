#!/bin/bash
if [ -z $1 ]||[ -z $2 ]||[ -z $3 ];then
   echo "nvc.sh <虚拟机名> <主机名> <eth0 IP> <eth1 IP> <eth2 IP> <eth3 IP>" >&2
   exit 1
fi


/root/sh/ip.sh $3
[ $? -ne 0 ] && exit 1
expect << EOF
spawn virsh console $1
expect "
"   {send "\n"}
expect "login:" {send "root\n"}
expect "密码：" {send "123456\n"}
expect "#"      {send "nmcli connection modify eth0 ipv4.method manual ipv4.addresses $3 connection.autoconnect yes\n"}
expect "#"      {send "nmcli connection up eth0\r"}
expect "#"      {send "hostnamectl set-hostname $2\n"}
expect "#"      {send "wget -O /etc/yum.repos.d/rhel7.repo ftp://192.168.4.254/share/rhel7.repo\n"}
expect "#"      {send "wget ftp://192.168.4.254/share/lnmp_soft.tar.gz"}
expect "#"      {send "yum repolist\n"}
expect "#"      {send "exit\r"}
EOF

ip=`echo $3 | sed -nr 's#/.*##p'`
expect << EOF
spawn ssh -o StrictHostKeyChecking=no $ip
expect "password:"  {send "123456\r"}
expect "#"      {send "mkdir /root/.ssh\n"}
expect "#"      {send "wget ftp://192.168.4.254/share/authorized_keys -O /root/.ssh/authorized_keys\n"}
expect "#"      {send "chmod 600 root/.ssh/authorized_keys\n"}
expect "#"      {send "exit\r"}
set timeout 3
EOF

if [ ! -z $4 ];then
   /root/sh/ip.sh $4
   [ $? -ne 0 ] && exit 2
   expect << EOF
   spawn ssh -o StrictHostKeyChecking=no $ip
   expect "password"  {send "123456\r"}
   expect "#"      {send "nmcli connection add type 802-3-ethernet con-name eth1 ifname eth1 autoconnect yes\r"}
   expect "#"         {send "nmcli connection modify eth1 ipv4.method manual ipv4.addresses $4 connection.autoconnect yes\r"}
   expect "#"         {send "nmcli connection up eth1\n"}
   expect "#"         {send "exit\r"}
EOF

fi

if [ ! -z $5 ];then
   /root/sh/ip.sh $5
   [ $? -ne 0 ] && exit 3
   expect << EOF
   spawn ssh -o StrictHostKeyChecking=no $ip
   expect "password"  {send "123456\r"}
   expect "#"      {send "nmcli connection add type 802-3-ethernet con-name eth2 ifname eth2 autoconnect yes\r"}
   expect "#"         {send "nmcli connection modify eth2 ipv4.method manual ipv4.addresses $5 connection.autoconnect yes\r"}
   expect "#"         {send "nmcli connection up eth2\n"}
   expect "#"         {send "exit\r"}
EOF

fi

if [ ! -z $6 ];then
   /root/sh/ip.sh $6
   [ $? -ne 0 ] && exit 6
   expect << EOF
   spawn ssh -o StrictHostKeyChecking=no $ip
   expect "password"  {send "123456\r"}
   expect "#"      {send "nmcli connection add type 802-3-ethernet con-name eth3 ifname eth3 autoconnect yes\r"}
   expect "#"         {send "nmcli connection modify eth3 ipv4.method manual ipv4.addresses $6 connection.autoconnect yes\r"}
   expect "#"         {send "nmcli connection up eth3\n"}
   expect "#"         {send "exit\r"}
   expect "#"         {send " \n"}
EOF

fi
ssh -X root@$ip
