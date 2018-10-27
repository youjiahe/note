#!/bin/bash
read -p "复原起始:" st
read -p "复原结束:" sp
[ -z $st -o -z $sp ] && exit 
cd /var/lib/libvirt/images
for i in `seq $st $sp`
do
   rm -rf host$i.img 
   cp node_new.qcow2 host$i.img
   virsh start host$i
   sleep 0.4
done

