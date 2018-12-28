#!/bin/bash
if [ -z $1 ]||[ -z $2 ]||[ -z $3 ];then
   echo "nvc.sh <虚拟机名> <主机名> <eth0 IP> <eth1 IP> <eth2 IP> <eth3 IP>" >&2
   exit 1
fi
cd /root/git/sh
\cp ./static_ip.sh /var/ftp/share
\cp /root/.ssh/id_rsa.pub /var/ftp/share/authorized_keys
sleep 0.4
expect << EOF
spawn virsh console $1
expect "
"   {send "\n"}
expect "login:" {send "root\n"}
expect "密码：" {send "1\n"}
expect "Password:" {send "1\n"}
expect "#"      {send "yum -y install wget\n"}
expect "~]#"      {send "ls /root/static_ip.sh ||  wget ftp://192.168.1.254/share/static_ip.sh -O /root/static_ip.sh\n"}
expect "~]#"    {send "bash static_ip.sh $3\n"}
expect "#"      {send "exit\r"}
EOF

expect << EOF
spawn ssh -o StrictHostKeyChecking=no $3
expect "password:"  {send "1\n"}
expect "#"      {send "mkdir /root/.ssh\n"}
expect "#"      {send "wget ftp://192.168.1.254/share/authorized_keys -O /root/.ssh/authorized_keys\n"}
expect "#"      {send "chmod 600 /root/.ssh/authorized_keys\n"}
expect "#"      {send "hostnamectl set-hostname $2\n"}
expect "#"      {send "yum repolist\n"}
expect "#"      {send "exit\r"}
EOF
