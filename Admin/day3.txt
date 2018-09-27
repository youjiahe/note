  #############################################
回顾day2
做题
 ##############################################
命令行基础
如何编写命令行
。Linux命令：
-用来实现某一功能的命令或程序
 （执行命令时，Linux需要找到对应的执行文件）

-命令的执行依赖于解释器（默认/bin/bash）

    用户----->解释其（翻译官）---->内核------>硬件
解释器存放路径：Ls /etc/shells
[root@you1 bin]# cat /etc/shells 
/bin/sh
/bin/bash
/sbin/nologin
/usr/bin/sh
/usr/bin/bash
/usr/sbin/nologin
/bin/tcsh
/bin/csh


绿色：代表可执行程序
黑底黄字：设备文件(不允许用cat卡看） 

内部命令 外部命令 （了解）

-快速编辑技巧
  TAB自动补全（很重要）
  按一次，前提是唯一才会出现
  连选两次，会列出系统所有
-快捷键盘
 Ctrl+l 清空整个屏幕
 Ctrl+c：结束正在运行的程序
 Esc+.或者Alt. 粘贴上一条命令参数
 ##############################################
Mount挂载操作：让目录成为设备访问点
Umount卸载
显示光盘所有内容
Linux：
   光盘------->光驱设备------->目录（手动/访问点\挂载点）
              /dev/cdrom
访问点：访问设备资源的时候，通过的点
   

Mount /dev/cdrom /dvd（让/dvd 成为/dev/cdrom的访问点）

 ###############################################
常见错误：
1.卸载
  目标忙（主要是当前有终端访问该访问点）
2.挂载
   不允许挂载道根目录下的目录（因为非常重要，挂载完后会变成只读）
   不要以根目录为访问点 （mount /dev/cdrom  /)

 ##############################################
Cd
Cd ～（当前用户家目录）
～（代表家目录）
/root：管理员的家目录
/home：存放所有普通用户家目录的地方
创建用户
Useradd 用户名

.表示当前目录
..表示父命令

Cd ..返回上层目录
Cd../..返回上两层目录

 ##############################################
Ls
常用命令选项
  -l  以长格式
  -A 包括名称以.开头的隐藏文件
  -lh 包括文件大小单位（K G M）
  -ld 显示目录本身详细属性
  -lhd
  -R 连父母目录一起显示

补充命令
Du（统计目录大小）
  Du -s /boot  /etc /home
  Du -sh /boot（有单位）
Du -sh /（会有报错，因为/proc目录是存在内存的，不占用硬盘空间）

  ##############################################
通配符
*任意多个字符
？但个字符
[]  最多0-9
{}


[root@localhost /]# ls /dev/tty{20,21,22,23,30,31,32,33,[0-9]}
/dev/tty0  /dev/tty20  /dev/tty23  /dev/tty31  /dev/tty4  /dev/tty7
/dev/tty1  /dev/tty21  /dev/tty3   /dev/tty32  /dev/tty5  /dev/tty8
/dev/tty2  /dev/tty22  /dev/tty30  /d
ev/tty33  /dev/tty6  /dev/tty9

[root@localhost /]# ls /dev/tty[10-19]
/dev/tty0  /dev/tty1  /dev/tty9

Shell 正则表达式

[root@localhost /]# ls /etc/m*.conf
/etc/man_db.conf  /etc/mke2fs.conf  /etc/mtools.conf

[root@localhost /]#  ls dev/tty{4?,50}
dev/tty40  dev/tty42  dev/tty44  dev/tty46  dev/tty48  dev/tty50
dev/tty41  dev/tty43  dev/tty45  dev/tty47  dev/tty49

 ###########################################
别名的定义：简化复杂的命令

Alias（不要以系统存在的命令作为别名）
Alias hn=‘hostname’  （修改别名）
Unalias（删除别名）
Unalias hn

Alais myls=‘ls -lh’(可以加上选项）

 ###########################################
Mkdir  -p

 ###########################################
Rm 删除（不要删除根下任何一个目录）不要删根目录
常用选项：-r -f：第归删除（含目录），强制删除
Rm -rf 直接删 

递归：目录本身集目录下所有
-force






 ###########################################
Vim 修改文本文件(可以创建文件，不可以创建目录）
文本编辑器
w保存  q退出  
q!请求不保存退出
-如果出现不能保存，则分析是否路径不存在

命令模式   输入模式（编辑模式）   末行模式


 ##############################################
Mv 移动/改名（类似剪切）
重命名： 路径不变即为改名

Cp 复制
 选项 -r 递归
复制目录时必须加上 “-r”选项

. ：当前目录 （适合用于当前路径比较长）

 ##############################################
1.强制覆盖
临时取消别名（加\)： \cp -r /boot/  /opt/
2.多参数的应用，永远会把最后一个 参数作为目标，其他的所有参数作为源（对于cp，mv而言）
3.复制时可以重新命名目标路径文档的名字
只需要在目标路径改文档名字

[root@you1 opt]# cp -r /home/ /etc/shadow /root/ /opt/
[root@you1 opt]# ls /opt/
home  rh  root  shadow


[root@you1 opt]# cp /etc/redhat-release  /opt/red-re
[root@you1 opt]# ls /opt/
home  red-re  rh  root  shadow
[root@you1 opt]# cat /opt/red-re 
Red Hat Enterprise Linux Server release 7.4 (Maipo)

请描述以下含义
[root@you1 opt]# rm -rf /opt/*  #清空/opt/
[root@you1 opt]# cp -r /home/ /opt/test   
                                 #把/home/ 复制到 /opt/，并重命名为test
[root@you1 opt]# cp -r /home/ /opt/test
                                  #把/home/ 复制到 /opt/test/下

验证：
[root@you1 opt]# ls opt
ls: 无法访问opt: 没有那个文件或目录
[root@you1 opt]# ls /opt/
test
[root@you1 opt]# ls /opt/test/
home  lisi  nsd10  you  you2
[root@you1 opt]# 



