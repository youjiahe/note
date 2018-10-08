#!/bin/bash

exp() {
   expect << EOF
spawn ssh root@$1.$2
expect "password" {send "123456\n"}
expect "#"        {send "touch /7.txt\r"}
expect "#"        {send "exit\r"}
EOF
}
subnet=192.168.4
for i in {1..254}
do
ping -c2 -i0.1 -W1 $subnet.$i &>/dev/null

if [ $? -eq 0 ];then
   exp $subnet.$i &
else
   continue
fi

done
