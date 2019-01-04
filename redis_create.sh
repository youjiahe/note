#!/bin/bash
if [ ! -f $1 ]; then
  echo "文件$1不存在"
  exit
fi
if [  -z $1 ]; then
  echo "需要指定主机列表文件"
  exit
fi
pscp.pssh -h $1 $2 /root
pssh -h $1 "yum -y install gcc gcc-c++"
pssh -h $1 "tar -xf redis-4.0.8.tar.gz"
pssh -h $1 "cd redis-4.0.8/ && make && make install"
