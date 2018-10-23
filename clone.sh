#!/bin/bash

read -p "请输入虚拟机数量:" n
[ $n -le 0 ] && exit
j=1
i=1
while [ $j -le $n ]
 do
   if [ ! -e /etc/libvirt/qemu/host${i}.* ] && [ ! -e /var/lib/libvirt/images/host${i}.* ]; then
       
      cd /var/lib/libvirt/images && qemu-img create -b node_new.qcow2 -f qcow2 host${i}.img 20G &>/dev/null
      cd /etc/libvirt/qemu && sed "s,node,host${i}," node.xml > host${i}.xml  
      cd /etc/libvirt/qemu
      virsh define  host${i}.xml  &>/dev/null
      sleep 0.3
      [ $? -eq 0 ] && echo -e "\033[32m虚拟机host$i 创建成功[OK]\033[0m" ||  echo -e "\033[31m虚拟机host$i 创建失败[NG]\033[0m"
      let j++
   else 
         let i++
	 continue
   fi
 done
