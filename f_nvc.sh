#!/bin/bash
old_IFS=$IFS
IFS='\n'
for i in `cat host.txt`
do
  IFS=$old_IFS
  /root/git/sh/nvc.1.sh $i
  old_IFS=$IFS
  IFS='\n'  
done
