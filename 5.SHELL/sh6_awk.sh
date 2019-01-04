#########################################
awk工具
awk编程语言/数据处理引擎
    --创造者:A、W 、K
    --在shell里面主要做数据过滤

基本操作方法
格式：1）awk [选项] ‘[条件]{指令}’
      2）awk [选项] ’BEGIN{指令}{指令}END{指令}’’
特点：1）print时最常用的编辑指令；多条指令用分号；
      2）awk支持打印某一列
      3）处理文本时，若未指定分隔符，默认空格，TAB（制表符）为分隔符。
      4）逐行处理
选项：1）-F 指定分隔符 
      2）-v 定义变量      #awk -v x=$a ‘$1==x’  文件
变量：$0 文本当前行全部内容制作    #只要没有加“”都默认为变量
      $1 文本第一列
      $2 文本第二列
      NR 当前行号
      NF 当前行列数
常量：”常量名” ，打印时需要加上“ ”
条件：1）正则  例子      /正则/   $1~/正则/  $1!~/正则/
      2）数字字符比较    NR==3  $3>=1000 $3!=1000
      3）逻辑判断        &&并且
运算：1）awk ‘BEGIN{print 1+1}’
指令：1）{print 列数1,列数2}   默认指令
      2)if(判断){命令}else{命令}
数组：1)数组名[下标][下标可以是数字，也可以是字符]  a[0]   a[a]   a[192.168.4.7] 
      2)固定打印格式：
       awk ‘BEGIN{a[0]=1;a[1]=2;a[2]=3;for(i in a)print  i,a[i]}’
 #########################################
认识awk指令，变量，常量
例子：
打印t.txt的第1列，第3列
[root@server0 ~]# awk '{print $1,$3}' t.txt   
hello world
ni ma
指定“：”或者“/”作为分隔符，并把第10列过滤出来
[root@svr7 ~]# awk -F"[:/]" '{print $10}' /etc/passwd 
打印出文本行数及列数
[root@server0 ~]# awk '{print NR,NF}' t.txt 
过滤出最后一列
[root@server0 ~]# awk '{print $NF}' t.txt 
打印根分区可用容量
[root@desktop0 ~]# df -h | awk '/\/$/{print $4}' 
打印/etc/passwd全部内容
[root@shell ~]# awk '/bash$/{print}'  /etc/passwd
[root@shell ~]# awk '/bash$/'   /etc/passwd   #可以不加{print}
 ###########################################
tailf 
动态监控，远程失败的记录
[root@server0 ~]# tailf /var/log/secure |  awk '/Failed/{print $11}' 
172.25.0.10
扩展
httpd显示脚本运行结果
cgi-bin/test.html
 ##############################################
awk高及应用
格式：awk [] ’BEGIN{指令}{指令}END{指令}’  文件

BEGIN{}行前处理，执行1次   #适合做初始化
{}逐行处理，读取文件过程中执行，有多少行执行多少次  
END{}行后处理，读取文件结束后执行，执行1次  #适合打印最终结果

特点：只做预处理时可以不加文件
 ################################
例子
计算数值，字符串
[root@svr7 ~]# awk 'BEGIN{print 0.55+0.45+1.8}'
2.8
[root@svr7 ~]# awk 'BEGIN{A=100;print A*100}'
10000
[root@svr7 ~]# awk 'BEGIN{i="I love";j="you";print i,j}'
I love you

输出用户名  UID  家目录，并且对齐    
# awk -F: 'BEGIN{print "用户名 UID 家目录"}{x++;print $1,$3,$6}END{print "总用户量:"x}' /etc/passwd  | column -t[-t:表示基于TAB（制表符）对齐] 
用户名               UID    家目录
root             0      /root
bin              1      /bin
daemon           2      /sbin
adm              3      /var/adm
lp               4      /var/spool/lpd
sync             5      /sbin
 #############################################
认识awk条件：
正则作为条件
/正则/        全行匹配（任何位置包含）
$1~/正则/    第1列匹配, 
$7!~/正则/   第7列不匹配，加上！取反
~：为模糊匹配
==：为精确匹配（条件判断）
例子：
打印含有root的行
[root@shell ~]# awk -F: '/root/'   /etc/passwd
打印仅第1列有root的行
[root@shell ~]# awk -F: '$1~/root/'  /etc/passwd
打印解释器程序不是/sbin/nologin的行
[root@shell ~]# awk -F: '$7!~/.*nologin/'  /etc/passwd
#############################################
数字字符条件
>;  <;  ==;  >=;  !=;  <=;

数字精确匹配
NR==4
$3>=1000
字符串精确匹配
$1==”root”

例子：
打印解释器程序不是/sbin/nologin的行
[root@shell ~]# awk -F: 'NR==4{print}' /etc/passwd
打印/etc/passwd第4行
[root@shell ~]# awk -F: 'NR==4{print}' /etc/passwd
打印系统用户（UID<1000）
[root@shell ~]# awk -F: '$3<1000{print}' /etc/passwd
打印自己创建的用户(UID>=1000)
[root@shell ~]# awk -F: '$3>=1000{print}' /etc/passwd
精确匹配root
[root@shell ~]# awk -F: '$1=="root"'  /etc/passwd
#############################################
逻辑判断条件
$3>1000&&$3<1005
$3>1000||$3<=10

打印UID在（1001-1005）用户
[root@shell ~]# awk -F: '$3>1000&&$3<1006' /etc/passwd

打印UID在1020以上，10以下的
[root@shell ~]# awk -F: '$3>1020||$3<10' /etc/passwd

 ########################################
运算
求出1～100中能被7整除的数
[root@shell ~]# seq 100 | awk '$1%7==0'
 #########################################
awk的if结构指令、
格式：awk  选项  ‘条件{指令}’  文件

例子：awk  -F: ‘{if($3<1000){x++}}END{print x}’  /etc/passwd
awk -F: ‘{if($3<1000){x++}else{y++}}END{print x,y}’ /etc/passwd

if($3<1000){x++}else{y++}
#########################################
awk数组
特点：数组对于电脑来说是一个变量。对于使用者来说是不同的变量
固定打印格式：awk ‘BEGIN{a[0]=1;a[1]=2;a[2]=3;for(i in a)print  i,a[i]}’
例子：
数字下标
awk 'BEGIN{x[0]=9;x[1]=2;print x[1],x[0]}'
awk  ‘BEGIN{print x++}’   #结果0，因为x++是先打印x再++
awk  ‘BEGIN{print ++x}’   #结果1
字符下标 
awk 'BEGIN{a["b"]=123456789 print a["b"]}'
打印
# awk 'BEGIN{a[0]=99;a[1]=77;a[2]=88;for(i in a){print i,a[i]}}'

 #######################################
案例
WEB攻击监控防护
步骤1：
# ll -h  /var/log/httpd/access_log            #httpd的访问日志
0	/var/log/httpd/access_log
# wc -l /var/log/httpd/access_log
0 /var/log/httpd/access_log

步骤2：模拟访问页面次数
# ab -c100 -n1000000 http://192.168.4.254/[
-c100:模拟100人访问
-n10000000：访问次数]   //DOS攻击，

步骤3：统计每个IP访问次数
#awk ‘{ip[$1]++;for(i in ip){print i,ip[i]}}’  a.log

步骤4：对以上结果进行排序，以小到大
#awk ‘{ip[$1]++;for(i in ip){print i,ip[i]}}’  a.log | sort -n
#######################################
sort:默认按首个字符来比较
-n:以数字的形式进行排序,小到大
-r:以数字的形式心经排序，大到小]











#案例综合练习
grep -q           #不输出结果
uptime            #非交互查看CPU负载
rpm -qa | wc -l     #查看系统已安装包的数量
/var/log/secure    #
echo $!            #最后一个后台进程PID





