#!/bin/bash
subnet="176.121.211"
for i in `seq 180 254`
 do
   ping -c1 -i0.1 -W1 $subnet.$i &>/dev/null
   n=$?
   if [ $n -eq 0 ]; then
      echo "$subnet.$i 主机是活的"
   else
      echo "" &>/dev/null
   fi
 done 
