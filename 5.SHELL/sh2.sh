 ##############################################
SHELL运算
整数运算  expr
加：expr $x + 79
减：expr $x - 5
乘：expr $x \* 5
    expr $x ‘*’ 5
除：expr $x /  4

括号$[][
    [root@pvr208 ~]# i=10
    [root@pvr208 ~]# j=20
    [root@pvr208 ~]# echo $i  +  $j
    10 + 20
    [root@pvr208 ~]# expr $i  +  $j
    30
    [root@pvr208 ~]# expr $[i+j]
    30
    [root@pvr208 ~]# i=10
    [root@pvr208 ~]# j=20
    [root@pvr208 ~]# expr $[i+j]
    30
    [root@pvr208 ~]# echo $[i+j]
    30
    [root@pvr208 ~]# expr 9 \*  $[8 + 1] 
    81
] $(())

let工具
    --计算，且不会显结果
--变量不需要加”$”
例子——>[
[root@pvr208 ~]# let x=777+999
[root@pvr208 ~]# echo $x
1776
[root@pvr208 ~]# let y=9
[root@pvr208 ~]# echo $y
9
[root@pvr208 ~]# let z=x+y
[root@pvr208 ~]# echo $z
1785]
--支持简写[
[root@pvr208 ~]# x=5
[root@pvr208 ~]# let x++
[root@pvr208 ~]# echo $x
6
[root@pvr208 ~]# let x--
[root@pvr208 ~]# echo $x
5
[root@pvr208 ~]# let x+=5
[root@pvr208 ~]# echo $x
10
[root@pvr208 ~]# let x+=10
[root@pvr208 ~]# echo $x
20
[root@pvr208 ~]# let x+=80
[root@pvr208 ~]# echo $x
100
[root@pvr208 ~]# let x/=5
[root@pvr208 ~]# echo $x
20
[root@pvr208 ~]# let x%=16
[root@pvr208 ~]# echo $x
4
]

echo
--echo $[x++]
    先显示x再++
--echo $[++x]
先++，再显示

 ############################################
小数运算  bc[]
--交互式，命令行输入bc，回车
--非交互式：
[root@pvr208 ~]# echo "scale=3;1.2+1.800+1.555" | bc
4.555
[root@pvr208 ~]# echo "scale=2;1.2+1.800+1.555" | bc
4.555
[root@pvr208 ~]# echo "scale=2;1.2+1.800+1.55" | bc
4.550
[root@pvr208 ~]# echo "scale=2;3/10" | bc
.30
--bc判断功能
[root@pvr208 ~]# echo "7!=7" | bc
0
[root@pvr208 ~]# echo "7==7" | bc
1
[root@pvr208 ~]# echo "7>1" | bc
1
[root@pvr208 ~]# echo "7>8" | bc
0


总结
整数：expr 数字1 符号 数字2
      echo $[数字1 符号 数字2]
      let 变量=数字1 符号 数字2

 ##############################################
条件判断
[]
[root@pvr208 ~]# [ $USER == root ] 
[root@pvr208 ~]# echo $?
0
[root@pvr208 ~]# [ $USER == named ] 
[root@pvr208 ~]# echo $?
1

test
[root@pvr208 ~]# test $USER == root
[root@pvr208 ~]# echo $?
0
[root@pvr208 ~]# test $USER == named
[root@pvr208 ~]# echo $?
1

一行执行多条命令的情况(不要写太多，规范的为两个）
# A && B               //仅当A成功，执行B
# A || B                 //仅当A失败，执行B
# A ; B                  //执行A 后执行B
# A && B || C[
[root@pvr208 ~]# cd / && ls /ab || ls
ls: 无法访问/ab: 没有那个文件或目录
bin   dev  home  lib64  mnt  proc  run   shell_100  sys   tmp  var
boot  etc  lib   media  opt  root  sbin  srv        test  usr]           
//仅当A成功，B执行；仅当B执行后，且失败，执行C
//仅当A失败，B不执行，执行C
[
[root@pvr208 /]# [ $USER == root ] && echo i || echo j
i
[root@pvr208 /]# [ $USER == named ] && echo i || echo j
j
]

字符串判断  == !=  -z   ! -z[
[root@svr7 ~]# [ ! -z $i ]  && echo "非空值" || echo "空值" 
空值
[root@svr7 ~]# i=11
[root@svr7 ~]# [ ! -z $i ]  && echo "非空值" || echo "空值" 
非空值
]
数字判断，比较的量必须是整数

-eq   //equal
-ne   // not equal 
-gt   //greater than
-ge   //greater or equal
-lt    //less than
-le    //less equal

案例：每分钟执行一次，当终端个数大于等于3时，发邮件到root

如果需要比较小数，
则
echo ‘1.5<5.2’ | bc


文件或目录的判断
-e exits         是否存在
-d dir           是否存在且为目录
-f file           是否存在且为文件
-r read         是否有读权限
-w write        是否有写权限
-x execute     是否有执行权限

 #############################################
多条件判断
--逻辑与 &&
  给定条件都成立，则整个测试结果为真     
  
--逻辑或 || 
  给定条件，有一个成立，则整个测试结果为真

对于简单的操作可以用逻辑与逻辑或来执行命令
 [ ! -d “/media/cdrom” ] && mkdir /media/cdrom 
 [ -d “/media/cdrom” ] ||  mkdir /media/cdrom 

 ##############################################
 if 结构

对于复杂的操作则需要用到if 
if [判断1] && [判断2]； then
  命令1
elif [判断]
  命令
elif [判断]
  命令
else
  命令2
fi

if [判断1] || [判断2]； then
  命令1
else
  命令2
fi

单分支案例：目录是否存在，不存在则创建
双分支案例：ping[
ping -c2 $1 >/dev/null
if [ $? -eq 0 ]; then
   echo "activated"
else
   echo "dead"
fi
]
多分支案例：猜数的大小，等于

补充：free 查看内存实时情况
      /usr 是linux存放软件的地方，类似于windows的programfile文件夹
      ping -c2  192.168.4.207   #指定ping的次数为2次
      ping -i0.1  192.168.4.207 #指定ping的时间间隔为0.1秒
      ping -W1  192.168.4.207   #指定超时等待时间为1秒
      ping -c2 -i0.1 -W1 192.168.4.207


systemctl restart network
补充：/proc/cpuinfo   查看CPU信息，vendor_id行是厂商
