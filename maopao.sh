#!/bin/bash

awk '{ip[$1]++;for(i in ip){print ZZZZ}'

sleep 0.1
n=${#num[*]}
n1=$[$n-1]
n2=$[$n-2]
n3=$[$n-3]
i=0
while :
#for ci in {1..100}
do
  tt=0
  for i in `seq 0 $n1`
  do
     j=$[$i+1]
     a=${num[$i]}
     b=${num[$j]}
     if [ $a -lt $b ];then
        t=${num[$i]}
        num[$i]=${num[$j]}
        num[$j]=$t
        tt=1
     else
        continue
