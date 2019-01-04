#!/bin/bash

read -p "虚拟机数量:" n
while [ -z $n ] 
do 
  read -p "虚拟机数量:" n
done  

read -p "虚拟机起始编号：" num

while [ -z $num ] 
do 
  read -p "虚拟机起始编号:" num
done  

read -p "输入 eth0 IP:" ip[0]
#read -p "Input eth1 IP:" ip[1]
#read -p "Input eth2 IP:" ip[2]
#read -p "Input eth3 IP:" ip[3]

start_num=$num
stop_num=$[$num+$n-1]
chmod +x ./ip.sh
./ip.sh ${ip[0]}
[ $? -ne 0 ] && exit
h1=${ip[0]##*.}
h2=${h1%/*}
[ $h2 -eq 0 ] && exit 
cp /root/.ssh/id_rsa.pub /var/ftp/share/authorized_keys
cp ./rhel7.repo /var/ftp/share/
systemctl restart vsftpd
for i in `seq $start_num $stop_num`
do 
#  if [ $i -lt 10 ];then
#     ii="0"$i
#  else
#     ii=$i
#  fi
expect << EOF
spawn virsh console rh7_node$i
expect "
"   {send "\n"}
expect "login:" {send "root\n"}
expect "密码：" {send "123456\n"}
expect "#"      {send "nmcli connection modify eth0 ipv4.method manual ipv4.addresses 192.168.4.$h2/24 connection.autoconnect yes\n"}
expect "#"      {send "nmcli connection up eth0\r"}
expect "#"      {send "hostnamectl set-hostname host${i}\n"}
expect "#"      {send "wget -O /etc/yum.repos.d/rhel7.repo ftp://192.168.4.254/share/rhel7.repo\n"}
expect "#"      {send "yum repolist\n"}
expect "#"      {send "exit\r"}
EOF
expect << EOF
spawn ssh -o StrictHostKeyChecking=no 192.168.4.$h2
expect "password:"  {send "123456\r"}
expect "#"      {send "mkdir /root/.ssh\n"}
expect "#"      {send "wget ftp://192.168.4.254/share/authorized_keys -O /root/.ssh/authorized_keys\n"}
expect "#"      {send "chmod 600 /root/.ssh/authorized_keys\n"}
expect "#"      {send "exit\r"}
set timeout 3
EOF
h2=$[$h2+1]

done &



