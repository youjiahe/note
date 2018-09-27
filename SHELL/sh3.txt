 ############################################
for结构
for in do done
for i in `seq 5`  等同于  for i in {1..5}
for i in `seq 5 10` 等同于 for i in {5..10}

脚本执行过程  bash -x 
 bash -x ./batchuser.sh userlist.txt 
不换行 -n
echo -n

C语言的风格
for ((i=1;i<=5;i++))
do
   echo $i
done

 ##############################################
while 结构
while 与for的区别：
while是不固定次数的循环，for是固定次数的循环
while适合写死循环

while :
do
 命令
done[shell里面专门用于写死循环]

死循环极大消耗CPU，一个死循环脚本可以消耗100%CPU
写死循环，最好加上sleep ，就不会对CPU有大的影响，因为计算机是纳秒级的
#!/bin/bash
while :
do
 echo nb
 sleep 0.1
done

持续监控CPU消耗的命令
sar -P ALL 1 100[
-P：监控CPU
ALL：监控所有情况
1：每一秒更新一次
100：监控100次]



 #############################################
case 结构
case [
#!/bin/bash
case $1 in
     redhat)       
         echo "fedora";;
     fedora)   
         echo "redhat";;
     *)
   echo "case.sh <redhat|fedora> " >&2
esac]变量 in
模式1）
      命令1;;
模式2）
     命令2;;
.. ..
*)
默认命令序列
esac

 ##########################################
函数
将一些需要重复性执行的脚本定义为函数块，与别名定义类似

结构1：
function 函数名 {
命令
.. ..
}

结构2：
函数名() {
命令
.. ..
}


取消函数
unset 函数名

可以加变量
[root@pc207 shell_100]# mrcd() {
> mkdir $1
> cd $1
> }
[root@pc207 shell_100]# mrcd 666
[root@pc207 666]# ls
[root@pc207 666]# mrcd /66

 ############################################
函数补充：
扩展打印
 echo -e "\033[32mOk\033[0m"[
\033[：开启颜色属性
32m：绿色
OK：显示OK
\033[：打开颜色属性
0m：黑色

----------------------------------
补充：
1m：粗体
42m：绿底
4m：下划线
9m：删除线]
[root@pc207 ~]# echo -e "\033[42mdelay no more\033[0m"
delay no more
[root@pc207 ~]# echo -e "\033[42;31mdelay no more\033[0m"
delay no more       #变成了42m的底色，31m的字体颜色\

批量ping做成函数后 放到后台&  速度会变快
 
死机程序
#！/bin/bash
A(){
A | [管道，把A换成.
A 会以几何级别次数执行]A $
 }
A

 ############################################

系统资源

 ###########################################
中断
break continue





