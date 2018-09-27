 #############################################
Day4回顾
补充命令：clean all 清除yum生成的所有缓存
Yum repolist读取的时内存的信息，即使/etc/yum.repos.d/*.repo有错误也不会有异常，因此需要执行yum  clean all

Nmcli connection modify时，千万要写子网掩码/24

 #############################################
重定向输出操作(具备创建文本能力）
>：覆盖重定向  
>>：追加重定向
Ls --help > /opt/ls.txt

 Echo，直接修改文本，适用于文本内容只有一行，或者需要在文本最后一行加入内容，与重定向一起用

[root@server0 ~]# echo server0 >> /etc/hostname
[root@server0 ~]# cat /etc/hostname
s
server0
[root@server0 ~]# echo server0 > /etc/hostname
[root@server0 ~]# cat /etc/hostname
server0
[root@server0 ~]# echo 1234
1234

[root@server0 ~]# echo nameserver 172.25.254.254 > /etc/resolv.conf 
[root@server0 ~]# nslookup server.example.com
Server:		172.25.254.254
Address:	172.25.254.254#53

** server can't find server.example.com: NXDOMAIN'

  ############################################
管道操作：将前面命令的输出结果作为参数，较为后面参数处理
注意：管道是操作命令的输出结果
” |“ ：可以连接n条命令，
  Cat -n etc/password  | head -12 | tail -5
  




 ##############################################
管理用户和组

 用户帐号：1.可以登陆操作系统 2.访问控制（不同用户具备不同的权限）
 组帐号：方便管理用户

唯一标识：UID（用户） GID（组）
管理员UID永远为 UID 0
普通用户的UID默认从: UID 1000起始

组：基本组（私有组） 附加组(从属组）
Linux要求一个用户至少属于一个组（windows不一定）

Useradd tom
    基本组由系统自动创建。自己加入（ 会自动创建tom组，并把用户tom加进去，同名组成为该用户的）
附加组是管理员创建的，手动把用户加入

 ##############################################
用户管理
Useradd（创建用户）   usermod（修改用户属性）
-u 用户名 用户UID  -s 登陆shell(指定解释器） -d 家目录路径 -G附加组
用户基本信息存放在/etc/passwd （系统级文件，没了开不了机）

[root@server0 ~]# head -1 /etc/passwd
root:x:0:0:root:/root:/bin/bash
用户名:密码:UID:基本组GID:用户描述信息（可为空）:用户家目录:解释器程序

/sbin/nologin :禁止用户进入操作系统

组创建：groupadd

设置密码：存放在/etcshadow  root不需要知道旧密码就可以更改其他用户密码
交互式：passwd kobe
非交互式：echo 123 | passwd --stdin kobe

/etc/shadow文件：
root:$6$UiGI4Tc2$htsXYn5cJnOqv3P1VLcUSgfjDu2pL5yiJBuua6foZAHdwqeuLHfYUfS/vBn27Wjvoel8EJgtdsMjyquqvKAmf1(加密字符串）:16261(上一次修改密码时间,从1970-1-1起天数):0(密码最短使用期限):99999(密码最长使用期限，99999为永远):7(密码修改提示提前天数):::

切换用户： su - 用户名(管理员无需密码)

？？？
[root@server0 ~]# su - wade
上一次登录：三 7月  4 12:01:33 CST 2018pts/0 上
This account is currently not available.

-bash-4.2$ ls /
bin   dev  home  lib64  mnt  proc  run   srv  tmp  var
boot  etc  lib   media  opt  root  sbin  sys  usr

删除账户：
用userdel 
-userdel -r  连同家目录一同删除（工作环境中尽量不要删除，因为家目录是普通用户存放文件的主要位置）
 ############################################
组管理
管理组帐号：groupadd [-g 组ID] 组名

[root@server0 ~]# grep Lakers /etc/group（系统级配置文件）
Lakers:x:1001:jordon
组名:组的密码占位符:GID:组成员列表

使用gpasswd 进行组管理
--gpasswd -a用户名 组名 （把用户添加到组）
--gpasswd -d 用户名 组名（把用户从组中删除）

 ##############################################
-组属性修改 groupmod（了解）  groupdel（了解）
 #############################################
Tar备份与恢复。打包及压缩
  
作用： 1.方便对零散文档管理  2.减小空间的占用
 
 Linux独有的压缩的格式：
----gzip（低，快） -------------->.gz
----bzip2（中，中）-------------->.bz2
----xz（比例高，慢）-------------->.xz

打包：
 命令：tar 【选项】 /路径/压缩包名字    /被归档压缩的源文件......

打包：
 命令：tar 【选项】 /路径/压缩包名字    -C 释放位置


选项： 打包：-zcf(gz)    -jcf(bz2)  -Jcf(xz)  （f必须放到所有选项最后,而且必须有）
       解包：-xf   [-C  目标文件夹]
       显示包里面的文件清单  -tf
Tar后会提示去除“/” ，是正常的
文字红色：压缩包

打包：
[root@server0 ~]# tar -zcf /opt/test.tar.gz /home/ /etc/passwd
tar: 从成员名中删除开头的“/”
[root@server0 ~]# ls /opt/
1.txt  file  LOL  rh  test.tar.bz2  test.tar.gz  test.tar.xz

解包：
[root@server0 ~]# mkdir /opt/file
[root@server0 ~]# tar -xf /opt/test.tar.gz /opt/file/
tar: /opt/file：归档中找不到
tar: 由于前次错误，将以上次的错误状态退出（少了-C）
[root@server0 ~]# ls /opt/t
ls: 无法访问/opt/t: 没有那个文件或目录
[root@server0 ~]# ls /opt/
1.txt  file  LOL  rh  test.tar.bz2  test.tar.gz  test.tar.xz
[root@server0 ~]# tar -xf /opt/test.tar.gz -C /opt/file/

 ##############################################
NTP时间同步服务（服务三步骤 装包 配置 启服务）
集群：
日志分析：
服务：	NTP服务器为客户提供标准时间
        NTP客户及需要与NTP服务器保持沟通
服务端：classroom.example.com
客户端：server0

1.安装软件（chrony），与服务端沟通时间的软件
2.修改主配置文件  /etc/chrony.conf 
Server .........iburst(是固定格式，中间可以是IP，iburst是快速匹配时间）
#server 0.rhel.pool.ntp.org iburst
#server 1.rhel.pool.ntp.org iburst
#server 2.rhel.pool.ntp.org iburst
server classroom.example.com iburst
3.重启chronyd服务：
  “chronyd”中的“d”：daemon，守护进程
  命令sysytemctl restart chronyd  #重启服务
       sysytemctl enable chronyd #让服务随机自启动

 #############################################
验证：
1.查看时间：date
2.修改时间：date -s “年-月-日期   时：分：秒”
 
 #############################################
Cron计划任务(周期任务）  工作中用得非常多

软件包：cronie crontabs
系统服务：croud
日志文件：/var/log/croud

如何写crontab任务记录
-分 时 日 月 周  任务命令
 *  *  *  *  * 

*：匹配范围内人一时间
,：分隔多个不连续的时间点
-：指定连续时间范围
/n：指定时间频率，每n...

命令：crontab
--编辑crontab -e  [-u 用户名]（会调用VIM编辑器,一个文件可以有多个）
--查看crontab -l   [-u 用户名]
--清除crontab -r   [-u 用户名]

/var/spool/cron/root（计划任务目录）
