 ############################################
Shell
Shell是在linux内核与用户之间的解释其程序（类比汽车)
Bash是某一厂家做出来的解释器程序（类比某一款型号汽车）

查看shell解释器程序  cat /etc/shells
[root@room11pc19 ~]# cat /etc/shells
/bin/sh
/bin/bash
/sbin/nologin
/usr/bin/sh
/usr/bin/bash
/usr/sbin/nologin
/bin/tcsh
/bin/csh
]

Ksh
Exit 退出
Yum -y install ksh  #也是一种解释器，可以解释linux命令
                          #[没有了颜色提示，没有了上下键调出历史命令，没有tab]

Useradd/usermod    -s #指定用户解释器程序 

 #############################################
Bash 基本特性
Tab 补全 
历史命令
命令别名
标准输入输出
重定向
管道

  ##########################################
Shell的使用方式
交互式：  ——————命令行

非交互式： ——————脚本

 #############################################
快捷键
[root@server0 ~]# at 20:00        #在20：00 执行计划程序
at> ls
at> cd /
at> <EOT>                         #Ctrl+D 结束执行
job 1 at Fri Aug 10 20:00:00 2018


Ctrl+s  冻结挂起终端


TAB  补齐命令，选项[RHEL6不能补齐（补齐选项需要bash-completion软件包）]，路径，文件名

 #############################################
历史命令
[root@server0 ~]# grep -i histsize /etc/profile
HISTSIZE=1000                                #安全考虑，不能太多

[root@server0 ~]#HISTSIZE=10  #临时修改历史命令记录

统计历史命令行数
[root@server0 ~]# history | wc -l
15

 ##########################################
清除历史命令
[root@server0 ~]# history -c
[root@server0 ~]# > .bash_history #历史命令存放的文件

 ###########################################
系统定义的默认别名
[root@server0 ~]# alias
alias cp='cp -i'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'


 #############################################
重定向输出
-  >  :覆盖重定向输出  （stdin)
-  >> :追加重定向输出
-  2> :错误重定向
-  &> :混合重定向

[root@server0 ~]# ls nb.txt /etc/fstab >a.txt 2>1.txt
                     #正确的输出，错误的输出分别存在不一样的文件。比&>, 更灵活]
[root@server0 ~]# cat 1.txt
ls: 无法访问nb.txt: 没有那个文件或目录
[root@server0 ~]# cat a.txt
/etc/fstab


 #############################################
重定向输入
< 文件名

案例：发邮件
mail -s 'passwd'  student < /etc/passwd

###########################################
管道  |

借助于管道符“|”，可以将一条命令的标准输出交给另一条命令处理，在一条命令行内可依次使用多个管道。

 #############################################
规范的shell脚本构成
脚本构成（需要的解释器，作者信息[写邮箱，在企业里面需要]）
注释信息（步骤、思路、用途、变量含义）
可执行的语句

 ###########################################
shell脚本的执行
相对路径 ：./hello.sh      
绝对路径：/root/hello.sh

无权限情况下：(在脚本前加上解释器程序）
             bash hello.sh
             ksh  hello.sh[都会打开子进程]
             source[不会打开子进程、

经常用于刷新历史命令记录条数修改
source /etc/profile] hello.sh

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
sshd───bash——bash——echo——exit  ——> sshd───bash  #退回当前
sshd───bash——echo——exit        ——> sshd          #退出终端

 ########################################
[root@server0 ~]# python
Python 2.7.5 (default, Feb 11 2014, 07:46:25) 
[GCC 4.8.2 20140120 (Red Hat 4.8.2-13)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> i=   55
>>> print i
55
>>>
Ctrl +D退出python

 ###########################################
变量
变量名与其他字符贴在一起时，有显示指定字符需求的时候，可以用 {} 区分开变量
echo ${a}RMB
echo “$a”RMB

环境变量  
查看环境变量相关文件
全局文件为/etc/profile，对所有用户有效；用户文件为~/.bash_profile，仅对指定的用户有效。

$MAIL          #存储当前用户邮件目录
$USER          #存储当前用户
$PATH          #存储命令执行程序
$HOSTNAME   #存储当前主机名
$HOME         #存储当前用户家目录
$PWD          #存储当前路径
$HISTSIZE      #存储当前历史命令记录数量（可以修改）
$UID           #存储当前用户UID
$PS1           #表示Shell环境的一级提示符，即命令行提示符（\u 用户名、\h 主机名、\W 工作目录、\$ 权限标识）：


查看环境变量
[root@server0 ~]# env
查看所有变量，包括env变量
查看自定义变量：set
波多野结衣 #youjiahe=66
波多野结衣 #set | grep youjiahe
youjiahe=66
###########################################
[root@server0 ~]# echo $PS1   #1级命令行
[\u@\h \W]\$
###########################################

换行
ls \[换行]
###########################################

位置变量
$0    #显示脚本/命令本身[]
$$    #显示该脚本的pid

引号对赋值的影响[
[root@server0 ~]#test=11
[root@server0 ~]#echo "$test"
11
[root@server0 ~]#echo '$test'
$test
]
双引号：把内容作为整体
单引号：把内容作为整体，并且屏蔽特殊符号

echo  ab      =  echo  “ab”  
echo  a b     <>  echo   “a b“
echo  “a b”   =  echo   ‘a b’
echo  “$a $b” = echo ‘$a $b’
echo  ab  =echo “ab” =echo ‘ab’

[root@server0 ~]#date +%F
2018-08-10
[root@server0 ~]#date "+%Y-%m-%d %H:%M:%S"
2018-08-10 17:29:37
###########################################
read
read -p "提示信息" n
###########################################
自定义变量不赋值，谁定义，谁赋值（手动赋值）
###########################################
显示输入功能
stty -echo  #关闭显示
stty echo   #开启显示
###########################################
全局变量，局部变量
--自定义变量都是局部变量
[root@room11pc19 ~]# i=33
[root@room11pc19 ~]# echo $i
33
[root@room11pc19 ~]# bash
[root@room11pc19 ~]# echo $i
[自定义变量，为局部变量。因此新建bash后，i就为空]
[root@room11pc19 ~]#

--环境变量，预定以变量，位置变量,等系统自带变量都是全局变量
     
使用export定义全局变量
export PATH=/usr/local/mysql/bin:$PATH













    
