 ##############################################
家目录漫游

共享文件夹
Network file system 网络文件系统
 -由NFS服务器把指定文件夹共享给客户机
  NFS服务器：Classroom.example.com
 -客户端：访问共享
1.查看服务端的共享 
-showmount -e classroom.example.com
Export list for classroom.example.com:
/home/guests 172.25.0.0/255.255.0.0

2.访问共享文件夹
[root@server0 ~]#mount classroom.example.com:/home/guest  /nsd 
[root@server0 ~]# umount /nsd
[root@server0 ~]# ls /nsd
[root@server0 ~]# mkdir /home/guests
[root@server~]# mount classroom.example.com:/home/guests /home/guests
[root@server0 ~]# ls /home/guests
ldapuser0   ldapuser12  ldapuser16  ldapuser2   ldapuser5  ldapuser9
ldapuser1   ldapuser13  ldapuser17  ldapuser20  ldapuser6
ldapuser10  ldapuser14  ldapuser18  ldapuser3   ldapuser7
ldapuser11  ldapuser15  ldapuser19  ldapuser4   ldapuser8
[root@server0 ~]# su - ldapuser0
上一次登录:五 7月  6 10:03:37 CST 2018pts/0 上
 #############################################
 附加权限：（最不常用的一个）
Set UID（攻击方用得比较多）
*附属在属主的x位上
-属主的权限标识会变为s
-适用于可执行文件，Set UID可以让使用者具有文件属主的身份及部分权限
-传递所有者身份（相当于尚方宝剑）
命令程序：/usr/bin/命令
红底白字：赋予特殊权限

 ##############################################
附加权限：
Sticky Bit
*附加在其他的人的x位上
-其他人的权限标识会变为t（rwt）
-适用于开放w权限的目录，可以阻止用户滥用w权限（禁止更该别人的文档）


-cp命令不支持管道， 因为有两个参数

 ##############################################
查找文件
*根据条件查找相应文件
-find [目录] [条件1] [-a|o] [条件2]  ([-a|o] 相当于and|or,默认and]   【递归查找】
-常用条件表示：
 -type  类型（f文件(隐藏文件也搜)、d目录、l快捷方式）
 -name “文档名称“  支持通配符
 -size   +|-文件大小(+是大于的意思，-是小于的意思 k M G)
 -user   用户名
 -exec （格式：-exec...{}.....\;)  查找出来的文件在进行额外处理
 -iname 根据文本 查找内容，不区分大小写
 -group 根据所属组
 -maxdepth 限制查找深度（目录层数，若不包括子目录，则 -maxdepth 1）
 (-maxdepth需要放在条件1的位置）
 -mtime （-mtime +|-， +10是10天之前，-10是最近10天内) 根据修改时间,所有时间都是过去时间
  
/var/log  是存放系统日志的地方

*实例：
[root@room11pc19 test]# ls
1.doc   2.doc   3.doc   4.doc   5.doc   6.doc   7.doc
1.html  2.html  3.html  4.html  5.html  6.html  7.html
1.txt   2.txt   3.txt   4.txt   5.txt   6.txt   7.txt
[root@room11pc19 test]# find . -name "*.html" -exec rm -rf  {} \;
[root@room11pc19 test]# ls
1.doc  2.doc  3.doc  4.doc  5.doc  6.doc  7.doc
1.txt  2.txt  3.txt  4.txt  5.txt  6.txt  7.txt

*其他例子：
find /etc  -name "passwd"  -exec  grep  "root" {} \;
find  .  -name  "*.log"  -exec  mv {} .. \;　　
find  .  -name  "*.log"  -exec  cp {}  test3  \;　
find . -name "*.log" -mtime -3 -exec rm {} \; 
  #############################################
Grep 
*根据字符串模式提取字符
-v 取反匹配
-i 忽略大小写匹配
-^word  以字符串开头的内容匹配
[root@server0 ~]# grep ^root /etc/passwd
root:x:0:0:root:/root:/bin/bash

-word$  以字符串作为结尾的内容匹配
[root@server0 ~]# grep bash$ /etc/passwd
root:x:0:0:root:/root:/bin/bash
student:x:1000:1000:Student User:/home/student:/bin/bash
kobe:x:1001:1001::/home/kobe:/bin/bash
james:x:1002:1002::/home/james:/bin/bash
paul:x:1003:1003::/home/paul:/bin/bash

-^$  匹配空行（一般用于去掉空行，与-v一起用）
 
-显示文件有效配置（去掉注释，去掉空） 
-grep -v ^# /etc/login.defs | grep -v ^$
-grep -v ^# /etc/login.defs | grep -v ^$ > /opt/b.txt

 
-\| ：多个字段查找
[natasha@student0 ~]$ grep   '^Date\|^hiya'  /var/spool/mail/natasha 

 ##############################################
Yum服务：为客户端安装软件包，自动解决依赖关系
服务端：1.众多的软件包 ； 2.仓库清单文件 3.共享的服务（Web或FTP）
客户端：书写一个配置文件 /etc/yum.repos.d/*.repo

Set GID是对新增的目录有效的

先用基本权限作修改，满足不了要求在用acl

 ##############################################
用于crontab更改配置文件时，命令最好写绝对路径

查找命令绝对路径
Which  
[root@server0 ~]# which yum
/usr/bin/yum

