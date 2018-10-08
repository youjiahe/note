#!/bin/bash
sbn="176.121.211"
i=180
while [ $i -le 254 ]
do
   ping -c1 -i0.1 -W1  "$sbn.$i" &>/dev/null
   n=$?
    [ $n -eq 0 ] && echo "$sbn.$i开机" && let n1++ 
   let i++
done  
echo "共$n1台服务器开机"
