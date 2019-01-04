#!/bin/bash
#斐波那挈数列
a=(0 1)
for i in `seq 0 20` 
do
   a[$[$i+2]]=$[${a[$i]}+${a[$[$i+1]]}]
done
 echo ${a[*]}
