#!/bin/bash
nump() {
       if [ $1 -gt -32766 ] 2>/dev/null ;then
          echo 1
       else
          echo 0
       fi
}
rangeip(){
       if [ $1 -gt 0 ] && [ $1 -le 255 ];then
           echo 1
       else
           echo 0
       fi
}
rangems(){
       if [ $1 -gt 0 ] && [ $1 -le 32 ];then
           echo 1
       else
           echo 0
       fi
}
ip=`echo $1 | sed -nr 's#/.*##p'`
mask=`echo $1 | awk -F'/' '{print $2}'`
lie=`echo  $ip | awk -F. "{print NF}"`
mask_lie=`echo $1 | awk -F'/' '{print NF}'`
[ $lie -ne 4 ] && echo "IP不是4部分,或子网为空"  >&2 && exit 22
[ $mask_lie -ne 2 ] && echo "子网掩码格式错误"  >&2 && exit 21
for i in {1..4}
do   
   case $i in
   1) 
   subip=`echo  $ip |awk -F. '{print $1}'`;;
   2)
   subip=`echo  $ip |awk -F. '{print $2}'`;;
   3)
   subip=`echo  $ip |awk -F. '{print $3}'`;;
   4)
   subip=`echo  $ip |awk -F. '{print $4}'`;;
   *)
   subip=a
   esac
   pd1=`rangeip ${subip}`
   [ $pd1 -ne 1 ] && echo "IP存在非范围数字" >&2 && exit 1
   pd2=`nump ${subip}`
   [ $pd2 -ne 1 ] && echo "IP存在非数字" >&2 && exit 2
done
pd3=`nump $mask`
[ $pd3 -ne 1 ] && echo "子网存在非数字"  >&2 && exit 3
pd4=`rangems $mask`
[ $pd4 -ne 1 ] && echo "子网数字超出范围" >&2 && exit 4
echo $1为合法IP
