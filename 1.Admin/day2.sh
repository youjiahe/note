
 ##############################################
补充day1
Ip地址配置方式：网络-->属性（有批量方法）
1.手动配置
2.DHCP自动获取IP（前提是网络里必须有DHCO服务器）
3.DNS服务器：作用是将域名解析为对应IP地址，为了方便去记忆网站，网站的推广
4.网关地址：一个网络连接到另一个网络的关口（路由器）
跨网络通信需要先找到本网络出口

 ##############################################
进入服务器的学习
Linux系统简介-----------------什么是Linux？Unix/Linux发展史？ Linux版本及应用？
（给专业维护服务器人员用的，因此不会考虑操作难易，只考虑越来越稳定）
特点：操作难度高，勤练
 ##############################################
Linux是一种操作系统
操作系统：一堆软件集合，计算机硬件正常合理工作
Linux面向服务器领域，WINDOWS面向客户端
 ##############################################
神威太湖之光
Linux服务端占有率高接近99%

 ##############################################
Unix/Linux发展史
   Ken Thomson，Dennis Ritchie 
   Unix诞生1970年1月1日
   UNIX被公司收购，需要付费，因此让一群人有想法写出一个比其更高的系统，因此
Linux诞生（1991年10月 Linus Torwards）

 ##########################################￥###
Linux 简介
Linux系统内核
     版本号：主版本.次版本.修订号
     用户-》内核-》硬件

是一套公开发布的Linux系统    开源的
   --Linux内核+应用程序

Linux发行版本
   -Red Hat Enterprise Linux 5/6/7
 （企业用6比较多）

 ##############################################
  ###############################################
红帽Linux企业版
-简称RHEL（Red Hat Enterprise Linux）
CentOS（社区企业操作系统）
-把红帽自主研发的软件，也集合到RHEL中

 ###############################################
安装RHEL7系统（以后会学如何批量装）
虚拟机安装RHEL7.4操作系统（7.5比7.4汉化多一点，可是企业里环境都是英文的）
整体步骤可以看案例
1.虚拟一个计算机硬件新建一台虚拟机.
2.网络选择Default的话，在一定情况下。能与真机通信
3.隔离网络，虚拟网络，有个概念
4.在企业里面是最小化安装
5.软件包选择“带GUI服务器安装”
6.Root是Linux超级管理员
7.Linux必须创建用户

###############################################
如何使用硬盘

物理硬盘-->分区规划-->格式化-->读/写文档
毛坯房-->打隔段-->装修-->入住

1TB=1000GB
1TiB=1024GiB
家用硬盘一般有7200r/min  服务器级别15000r/min

格式化：赋予数据在空间中，存储的规则（文件系统）
文件系统：EXT4（RHEL6默认）  XFS（RHEL7默认）
          SWAP，交换空间（虚拟内存）：缓解真实物理内存的压力
          （工作当中少用）
###############################################
Linux目录结构
树型结构   根目录



最顶层为根目录（/）
根目录（/）Linux所有数据都在此目录下（Linux系统的起点）
路径：/root/abc/test.txt(开头的“/”是根目录）
/dev: 所有设备相关文件（硬盘，键盘，鼠标）


/dev/sda5
硬盘表示的方法：
Hd：，表示IDE 设备，指硬盘接口类型是长的，较老
Sd，表示SCSI设备 ，接口类型是圆的，常用
Vd，表示虚拟化设别（只在虚拟机出现，虚拟出来的硬盘）

/dev/hda   /dev/hdb  /dev/hdc  /dev/hdd 
/dev/sda1   
/dev/sdb2:SCSI类型设别，第二块硬盘，第二个分区

 ###############################################
RHEL7基本操作
50条操作命令
控制台切换（Ctrl+Alt+Fn）
--tty1
--tty2～6（功能一样，预留使用）
--tty是控制台的意思

在图形命令行，可以鼠标右键，“打开终端”

 #############################################
终端：
查看及切换目录
-pwd（Print working directory
 用途：显示当前所在位置

-cd打开目录

-ls 列出当前目录所有内容   
-格式
常用命令选项
-l：长格式显示

    Cd，ls 相当于WD双击
Etc文件夹里面放了很多系统文件
Ls后，显示出几种颜色、
   蓝色：目录
   黑色：文本文件
   青色：快捷方式

-Clear：清屏  快捷键Ctrl+l

-Cat：查看文本文件内容（看小文件的）
 查看系统版本（进入企业第一件事情）
 ##############################################

命令行的一般格式
-命令字 【选项】（更多的需求）    参数1   参数2
Cat       -n(行号）     /etc/rehat-release  

案例：
[root@localhost etc]# cat -n redhat-release
     1	Red Hat Enterprise Linux Server release 7.4 (Maipo)

[root@localhost etc]# ls -l  /etc/redhat-release
-rw-r--r--. 1 root root 52 6月  29 2017 /etc/redhat-release

[root@localhost etc]# ls -l /boot

[root@localhost etc]# uname -r
3.10.0-693.el7.x86_64


列出CPU处理器信息
-[root@localhost etc]# Lscpu

列出内存
-[root@localhost etc]# cat /proc/meminfo

列出(更改）当前主机名（临时更改）
[root@you ~]# hostname you.Tedu.com^

有点的话，点前显示在主机名提示符
打开新的图形终端窗口会刷新主机名

列出IP地址
Ifconfig
Eht0网卡
Lo：回环
配地址（临时配，断电
[root@you ~]#ifconfig eth0 192.168.1.1
[root@you ~]#ping 192.168.1.1

127.0.0.1 代表本机IP
Ctrl+C 结束正在执行的命令
创建路径

-Mkdir

创建文档
-Touch

-Less看大文件的
按上下键可以滚动，
输入/root  可以全文查找root
按q退出

Head tail（没有写行数 默认10行）
Head -2
Tail -2

Grep工具
用途：输出包含制定字符的所在行
格式：grep 字符串目标文件

 ###############################################绝对路径：以/开始的绝对路径
相对路径：以当前为参照的相对路径

