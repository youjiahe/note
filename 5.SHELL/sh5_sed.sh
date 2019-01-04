##########################################
wait 可以在后台程序执行完后，显示命令行

#############################################
${变量::}  截取
${变量///}  替换
${变量#}  掐头
${变量%}  去尾
${变量:-初始值} 初始值设置

^            #开头
$            #结尾
[]            #集合  
[^]          #集合取反 
.             #匹配任意一个字符
*             #匹配前一个字符出现人任意次
\{n,m\}      #匹配前一个字符出现n-m次
\{n,\}        #
\{n\}
\(\)              #保留(复制)

grep “\.$”  1.txt   #过滤以点结尾的行，“\”可以屏蔽后一个字符的特殊符号


记得总结shell的知识点核心

 ##############################################
扩展正则：（简化基本正则)
5个
{n,m}  #去掉\号，直接指定前一个字符出现 n-m次
？      #0或1次
+      #1次或者以上
()       #分组引用整体，保留（复制）   与\(\)一样的含义
|        #或者
\b       #单词边界
\n       #按顺序把（）内容复制到相应位置    \1 \2 \3

例子：
(ab)*  #过滤ab abab ababab abababab   
(test|taste)  #过滤出test或者taste   需要用egrep过滤
grep “\bthe\b”  a.txt  #过滤指定单词the,前后都没有内容
 ###########################################
基本正则：兼容性强（所有支持正则的软件都支持基本正则），麻烦
扩展正则：兼容性相对差，简单
vim 后输入i 输入a，光标会在
 #######################################
sed
3个选项，2个条件，6个指令
n,i,r ; 行号，正则 ；p d s c a i
总结知识点：
#sed [选项] '条件指令' 文件
选项:
-n 屏蔽默认输出
-r 支持扩展正则
-i 修改源文件
条件：
行号 4 4,5 4~2 4,+10
/正则/
指令：
p 打印
d 删除
s 替换s/旧/新/g
a 追加
i 插入
c 替换行

 ###########################################
sed工具概述
-非交互的(vim是交互的)
-逐行处理
-格式： 
      用法1：前置命令 | sed [选项] ‘条件指令’  
      用法2：sed [选项] ‘条件指令’ 文件     
-条件可以是行号或者/正则/
-没有条件，默认所有条件
-指令可以是增删改查
-默认sed会将所有输出的内容都打印出来，可以使用-n屏蔽默认输出
-选项中可以使用-r选项，让sed支持扩展正则
-选项
-n（屏蔽默认输出，默认sed会输出读取文档的全部内容）
-r（让sed支持扩展正则）
-i（sed直接修改源文件，默认sed只是通过内存临时修改文件，源文件无影响）
-指令
     ：p 打印输出内容
     ：d 删除 （不加-i,是不会修改源文件的；否则只会把删除后的结果显示在屏幕，不会保存）
     ：s 替换
     ：a 追加（后）
     ：i  插入（前）
     ：c 替换一行
-条件
     :行号3   3,5p   3,+10p   1~2p    3~2p
     :正则 /root/
     :没有条件


例子：
1)sed -n '1p;3p' /etc/passwd        #显示/etc/passwd第1行，第3行
2)sed -n '3,5p' /etc/passwd         #打印3到5行
3)sed -n '3p;5p;6p' /etc/passwd     #打印第3和5行和6行：
4)sed -n '3,+10p' /etc/passwd       #打印第3以及后面的10行：
5)sed -n '1~2p' /etc/passwd  #“1”，表示起始行，”2”指的是步长,即打印奇数行
6)sed -n '/root/p' /etc/passwd  #
打印以bash结尾的行：
[root@server0 ~]# sed -n '/bash$/p' passwd 
root:x:0:0:root:/root:/bin/bash
student:x:1000:1000:Student User:/home/student:/bin/bash
打印以bash结尾的行号
[root@server0 ~]# sed -n '/bash$/=' passwd 
1
25
打印最后一行的行号,也就是文件行数
[root@server0 ~]# sed -n '$=' passwd 
39
打印所有内容
[root@server0 ~]# sed -n 'p' passwd
.. .. ..
删除所有空行
[root@server0 ~]# sed '/^$/d' a.txt

 ######################################
字符串替换  
sed ‘s/old/new/g’  文件    #替换文件全部  
sed ‘s/old/new/3’  文件    #替换文件每行第3个
“/”  可以换成“#” “/b” “,” 或者任何

替换每行第一个
[root@server0 ~]# sed 's/2017/xxyy/' 8.txt 
xxyy 2011 2018
xxyy 2017 2024
xxyy 2017 2017
替换每一行全部
[root@server0 ~]# sed 's/2017/xxyy/g' 8.txt 
xxyy 2011 2018
xxyy xxyy 2024
xxyy xxyy xxyy

把/etc/passwd 下的所有/bin/bash 替换为 /sbin/sh
    [root@server0 ~]# sed -n 's#\/bin\/bash#\/sbin\/sh#gp' passwd 
    root:x:0:0:root:/root:/sbin/sh
    student:x:1000:1000:Student User:/home/student:/sbin/sh

给第4行，第7行加上注释
    sed -n ‘4,7s/^./^#/’  a.txt

保留，复制字符
交换第一个字符以及最后一个字符
[root@server0 ~]# cat  b.txt 
hello wang qin
ni hao dai fa bing
[root@server0 ~]# sed -r 's/(^.)(.*)(.$)/\3\2\1/g'  b.txt
nello wang qih
gi hao dai fa binn

 ##############################################
字符增加操作
a:append 追加（后加）
i: insert 插入（前加）
c:替换一行

例子：
[root@server0 ~]# sed '2a xxx’ b.txt     #在第二行后面插入内容
[root@server0 ~]# sed '2i xxx' b.txt      #在第二行前面插入内容
[root@server0 ~]# sed '/root/i xxx' b.txt  #在含有root的所有行前面插入
[root@server0 ~]# sed '/root/c xxx' b.txt  #把含有root的所有行替换为“xxx”

 ##########################################
扩展
选项r，导入
sed -n '1r /etc/hosts'  b.txt
#把/etc/hosts 导入b.txt。并且在b.txt的内容前面插入

sed '$r /etc/hosts'  b.txt
#把/etc/hosts 导入b.txt。并且在b.txt的内容后面插入

选项w，另存为
sed  -n '1,5w /b.txt'   a.txt
#把a.txt中的1到5行，另存到b.txt

选项H复制并追加
1行--->内存——》sed
模式空间---（复制追加）-----保持空间（回车）
选项G
    保持空间（回车）---（复制追加）———模式空间
选项h
    模式空间---（复制追加）-----保持空间
选项g
    保持空间---（覆盖）———模式空间

例子：
[root@server0 ~]# sed '2H;5G' num.txt
1
2
3
4
5

2
6
7
[root@server0 ~]# sed '2h;5g' num.txt
1
2
3
4
2
6
7

