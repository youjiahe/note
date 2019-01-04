#!/bin/bash
while :
do
   netstat -untlp | grep :80 &>/dev/null
   [ $? -ne 0 ] && systemctl stop keepalived || systemctl start keepalived
   sleep 5
done

