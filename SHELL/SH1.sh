
● Shell
Shell是在linux内核与用户之间的解释其程序（类比汽车)
Bash是某一厂家做出来的解释器程序（类比某一款型号汽车）

●ksh
Yum -y install ksh     
#也是一种解释器，可以解释linux命令 
#[没有了颜色提示，没有了上下键调出历史命令，没有tab]

●快捷键
Ctrl+D
[root@server0 ~]# at 20:00        #在20：00 执行计划程序
at> ls
at> cd /
at> <EOT>                         #Ctrl+D 结束执行
job 1 at Fri Aug 10 20:00:00 2018

Ctrl+s  #冻结挂起终端

●TAB
TAB  #补齐选项需要bash-completion软件包

●清除历史命令
[root@server0 ~]# history -c
[root@server0 ~]# > .bash_history [历史命令存放的文件]

[root@server0 ~]# grep -i histsize /etc/profile
HISTSIZE=1000                                #安全考虑，不能太多

●重定向
ls nb.txt /etc/fstab >a.txt 2>1.txt
#[正确的输出，错误的输出分别存在不一样的文件。比&>, 更灵活]

●shell脚本的执行
无权限情况下：(在脚本前加上解释器程序）
             bash hello.sh
             ksh  hello.sh[都会打开子进程]
             source[不会打开子进程]

经常用于刷新历史命令记录条数修改
source /etc/profile] hello.sh

sshd───bash——bash——echo——exit  ——> sshd───bash  #退回当前
sshd───bash——echo——exit        ——> sshd         #退出终端

●变量
变量名与其他字符贴在一起时，有显示指定字符需求的时候，可以用 {} 区分开变量
echo ${a}RMB
echo “$a”RMB

●查看环境变量相关文件
全局文件为/etc/profile，对所有用户有效；
用户文件为~/.bash_profile，仅对指定的用户有效。
$MAIL          #存储当前用户邮件目录
$USER          #存储当前用户
$PATH          #存储命令执行程序
$HOSTNAME   #存储当前主机名
$HOME         #存储当前用户家目录
$PWD          #存储当前路径
$HISTSIZE      #存储当前历史命令记录数量（可以修改）
$UID           #存储当前用户UID
$PS1           #表示Shell环境的一级提示符，即命令行提示符（\u 用户名、\h 主机名、\W 工作目录、\$ 权限标识）：
Naruto#PS1='[\u@\h \w]\$'
[root@pvr208 ~]#
[root@pvr208 ~]#echo $PS1
[\u@\h \w]\$

●查看环境变量 :env
[root@server0 ~]# env
●查看所有变量，包括env变量
查看所有变量:set
[root@server0 ~]#youjiahe=66
[root@server0 ~]#set | grep youjiahe
youjiahe=66

●位置变量
$0    #显示脚本/命令本身
$$    #执行该脚本的pid

●引号对赋值的影响
双引号：把内容作为整体
单引号：把内容作为整体，并且屏蔽特殊符号

echo  ab      =  echo  “ab”  
echo  a b     <>  echo   “a b“
echo  “a b”   =  echo   ‘a b’
echo  “$a $b” = echo ‘$a $b’
echo  ab  =echo “ab” =echo ‘ab’

●全局变量，局部变量
--自定义变量都是局部变量
--环境变量，预定以变量，位置变量都是全局变量

