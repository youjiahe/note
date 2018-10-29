#!/bin/bash
read -p "复原起始:" st
read -p "复原结束:" sp
[ -z $st -o -z $sp ] && exit 
cd /var/lib/libvirt/images
for i in `seq $st $sp`
do
   rm -rf host$i.img 
   qemu-img create -b node_new.qcow2 -f qcow2 host$i.img 20G
   virsh start host$i
   sleep 0.4
done

