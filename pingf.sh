#!/bin/bash
pingf() {
        ping -c1 -i0.1 -W1 "$1" &>/dev/null
        n=$?
        [ $n -eq 0 ] && echo "$1开机了" || return 1 
        }

subnet="176.121.211"
j=1
n1=0
[ -f /tmp/FFFF.txt ] && rm -rf /tmp/FFFF.txt

for i in `seq $j 254`
do
#   pingf "$subnet.$i" &
   pingf "$subnet.$i" >> /tmp/FFFF.txt &
#   [ $? -eq 0 ] && let n1++  
done

sleep 0.2
cat -n /tmp/FFFF.txt 
n1=`cat /tmp/FFFF.txt | grep -v ^$ |wc -l`
echo "共$n1台服务器开机"
sleep 0.1
rm -rf /tmp/FFFF.txt

