#!/bin/bash
if [ ! -f $1 ]; then
  echo "文件$1不存在"
  exit
fi
if [  -z $1 ]; then
  echo "需要指定主机列表文件"
  exit
fi

for i in `cat $1`
do
host=`echo "$i" | awk -F "." '{print $4}'` 
expect <<EOF
spawn ssh -o StrictHostKeyChecking=no $i
expect "#" {send "redis-cli shutdown\n"}
expect "#" {send "sed -i \"70c bind 192.168.4.$host\" /etc/redis/6379.conf\n"}
expect "#" {send "sed -i \"93s/port .*/port 63$host/\" /etc/redis/6379.conf\n"}
expect "#" {send "sed -i \"815s/# //;823s/# //;829s/# //\" /etc/redis/6379.conf\n"}
expect "#" {send "sed -i \"823s/6379/63$host/;829s/15000/5000/\" /etc/redis/6379.conf\n"}
expect "#" {send "sed -i \"8s/6379/63$host/\" /etc/init.d/redis_6379\n"}
expect "#" {send "sed -i \"43c /usr/local/bin/redis-cli -p 63$host -h 192.168.4.$host shutdown\" /etc/init.d/redis_6379\n"}
expect '#' {send "exit\n"}
EOF
done
