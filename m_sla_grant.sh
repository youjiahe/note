#!/bin/bash
if [ ! -f $1 ]; then
  echo "文件$1不存在"
  exit
fi
ip=`ifconfig |head -2 | awk '/inet /{print $2}'`
for i in `cat /root/host.txt`
do
    [ $ip == $i ] && continue
    [ $i == "192.168.4.51" ] && continue
    p=${i##*.}
    expect << EOF
spawn ssh -o StrictHostKeyChecking=no $i
expect "#"  {send "sed -i \'/$i/d\' /root/host.txt\n"}
expect "#"  {send "mysql -uroot -p123456 -e \"grant all on *.* to root@\'%\' identified by \'123456\';\"\n"}
expect "#"  {send "mysql -uroot -p123456 -e \"set global relay_log_purge=off;\"\n"}
expect "#"  {send "exit\n"}
EOF
done
