#!/bin/bash
rm -rf ./rhel7_extras.repo ./rhel7osp.repo
echo "[rhel7_extra]
name=rhel7_extra
baseurl=ftp://192.168.1.254/RHEL7-extras
enable=1
gpgcheck=0"  > rhel7_extras.repo
fn="tutututu.txt"
ls  /var/ftp/RHEL7OSP-10/ | sed  -n '/^r/p' > $fn
n=0
for i in `cat $fn`
do
  echo "[rhel7osp$n]
name=rhel7_extra
baseurl=ftp://192.168.1.254/RHEL7OSP-10/$i
enable=1
gpgcheck=0"  >> rhel7osp.repo
let n++
done
