#!/bin/bash
yum -y install bc &>/dev/null

max_cpu_load=`ps aux | sort -r -k 3 | sed -n '2p' | awk '{print $3}'`
max_load_pid=`ps aux | sort -r -k 3 | sed -n '2p' | awk '{print $2}'`

judge=`echo "${max_cpu_load} > 80.5" | bc`

if [ $judge -eq 1 ];then
   kill -9 ${max_load_pid}
fi
