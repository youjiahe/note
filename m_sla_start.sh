#!/bin/bash
if [ ! -f $1 ]; then
  echo "文件$1不存在"
  exit
fi
if [  -z $1 ]; then
  echo "需要指定主机列表文件"
  exit
fi
read -p "主库IP地址:" m_ip
read -p "主库binlog日志:" log
read -p "主库binlog日志偏移量:" log_pos
ip=`ifconfig |head -2 | awk '/inet /{print $2}'`
pscp.pssh -h $1 /root/sh/m_sla_reset.sh /root
for i in `cat $1`
do
    [ $ip == $i ] && continue
    [ $i == "$m_ip" ] && continue
    p=${i##*.}
    expect << EOF
spawn ssh -o StrictHostKeyChecking=no $i
expect "#"  {send "sed -i \'/$i/d\' $1\n"}
expect "#"  {send "bash /root/m_sla_reset.sh $m_ip $log $log_pos \n"}
expect "#"  {send "exit\n"}
EOF
done
