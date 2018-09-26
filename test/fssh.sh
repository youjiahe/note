#!/bin/bash
rpm -qa | grep pssh
if [ $? -ne 0 ];then 
   echo "未安装pssh" 
   exit
fi
rpm -qa | grep expect 
if [ $? -ne 0 ];then 
   echo "未安装expect" 
   exit
fi
ip=`ifconfig ens33 | awk '/inet /{print $2}'`
for i in `cat /root/host.txt`
do
    [ $ip == $i ] && continue
    p=${i##*.}
    expect << EOF
spawn ssh -o StrictHostKeyChecking=no $i
expect "#"  {send "sed -i \'/$i/d\' /root/host.txt\n"}
expect "#"  {send "ssh-keygen -N \'\' -f \"/root/.ssh/id_rsa\"\n"}
expect "(y/n)" {send "y\n"}
expect "#"  {send "pscp.pssh -x \"-o StrictHostKeyChecking=no\" -A -h /root/host.txt /root/.ssh/id_rsa.pub /root/.ssh/id_rsa${p}.pub\n"}
expect "Password:" {send "1\n"}
expect "#"  {send "pssh -A -h host.txt \"cat /root/.ssh/id_rsa${p}.pub  >> /root/.ssh/authorized_keys\"\n"}
expect "Password:" {send "1\n"}
expect "#"  {send "exit\n"}
EOF
done
