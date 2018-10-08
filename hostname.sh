#!/bin/bash
if [ -z $1 ] || [ ! -f $1 ]; then
  echo "文件不存在或者未指定"
  exit 
fi
read -p "主机名前缀:" name
chmod 600 /root/.ssh/*
for i in `cat $1`
do
num=`echo $i | awk -F "." '{print $4}'`
expect << EOF
spawn ssh -o StrictHostKeyChecking=no $i
expect "#" {send "hostnamectl set-hostname $name$num \n"}
expect "#" {send "exit\n"}
EOF
done
