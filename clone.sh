#!/bin/bash

read -p "请输入虚拟机数量:" n
[ $n -le 0 ] && exit
j=1
i=1
while [ $j -le $n ]
 do
   if [ ! -e /etc/libvirt/qemu/host${i}* ];then
       
      cd /var/lib/libvirt/images && qemu-img create -b node_new.qcow2 -f qcow2 host${i}.img 20G
      cd /etc/libvirt/qemu && sed "s,node,host${i}," node.xml > host${i}.xml  && virsh define  host${i}.xml
      let j++
   else 
         let i++
	 continue
   fi
 done
