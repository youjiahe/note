#!/bin/bash
if [ ! -f $1 ]; then
  echo "文件$1不存在"
  exit
fi

[ ! -e /root/.ssh/id_rsa ] && ssh-keygen -N '' -f "/root/.ssh/id_rsa"
rpm -qa | grep pssh 
[ $? -ne 0 ] &&  exit
pssh -A -h $1 "[ ! -d /root/.ssh  ] && mkdir /root/.ssh"
pscp.pssh "-o StrictHostKeyChecking=no" -A  -h $1 /root/.ssh/id_rsa.pub /root/.ssh/
pssh -A -h $1 "cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys"
pscp.pssh -h $1 $1 /root/
