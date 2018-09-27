  ##############################################
Day3回顾


以下操作千万千万要看好主机名
  ##############################################
Server -作为练习用服务器
Desktop_作为练习用客户机
Classroom -提供网关/DNS/软件素材/DHCP服务器等资源

开机顺序：
首先开启classroom ，再开启server  desktop（因为DHCP在classroom）

 ##############################################
教学环境介绍（红帽公司给到达内的）
1.先重置服务器 
 rht-vmctl reset classroom（先复位classroom，,命令已经包括开机）
 rht-vmctl reset server
 rht-vmctl reset desktop

2.帐号：root 密码：redhat  classroom密码不知道

3.虚拟机基本信息(系统版本，IP地址，主机名）
  server
  1）查看虚拟机操作系统版本：RHEL7.0
  2）查看eth0的IP地址：172.25.0.11\24  (为什么）
  3）查看主机名：server0.example.com
   
  Desktop
  1）查看虚拟机操作系统版本：RHEL7.0
  2）查看eth0的IP地址：172.25.0.10\24  (为什么）
  3）查看主机名：desktop0.example.com

4.默认真机可以与server destop通信

 ##############################################
真机远程管理虚拟机
1.前提可以ping通
2.远程管理指令   ssh 用户名@对方IP地址
                 例子：ssh root@172.250.11
                 （exit退出）
补充说明：1）ssh会给管理过的机器配上唯一的key，第一次登陆时会提示

          2）远程管理在达内教学环境内是无密码验证方式，
  3）在实际工作环境中是有密码的
  4）Ctrl  +shift +t 新开一个终端(可以在同一个窗口打开多个终端）
     远程管理选项  —X（大写）   让本机打开远程的图形程序（如firefox）
     Ssh -X root@172.25.0.11
  
Firewall-config#防火墙的图形工具

 ##############################################
做一个别名，方便远程访问  代替ssh----

如：go系列：goweb  gos god
配置文件：

-永久别名需要更改配置文件 /root/.bashrc（系统级配置文件）   手不要抖！！！！！！！
配置文件设置后需要关闭重启终端

alias gos='ssh -X root@172.25.0.11'
alias god='ssh -X root@172.25.0.10'

 ##############################################
软件包管理

1.关闭虚拟机server添加虚拟的光驱设备
2.显示光盘内容

 ##############################################
零散软件包管理

RPM
---rpm -q   #查询软件是否安装
[root@server0 ~]# rpm -q firefox
firefox-24.5.0-1.el7.x86_64
[root@server0 ~]# rpm -q zip
zip-3.0-10.el7.x86_64
[root@server0 ~]# rpm -q mysql
未安装软件包 mysql 
[root@server0 ~]# rpm -q qq
未安装软件包 qq 

---rpm -ivh #安装软件包(有进度条）
---rpm -i安装软件包（没有进度条）
---rpm -e  #卸载软件包

El7（rhel7软件包不能撞到RHEL6）
 ##############################################
有依赖关系软件包安装
软件包依赖关系

安装某些包时，会遇到
错误：依赖检测异常

 ##############################################
重点 ：（晚自习重复练习）
Yum软件仓库，自动解决依赖关系
服务：为客户端安装软件包，并解决依赖关系

服务端：1.具有众多的软件包 2.仓库清单文件 3.共享的服务（现阶段不需要自己搭建）
http://classroom.example.com/content/rhel7.0/x86_64/dvd/

客户端：发送请求。书写配置文件/etc/yum.repos.d/*.repo(路径默认存在）
        正确的文件与错误的文件会相互影响,因此需要删除操作

[root@server0 ~]# rm -rf /etc/yum.repos.d/*   #删除目录下所有文件
[root@server0 ~]# vim /etc/yum.repos.d/rhel7.repo  #配置客户端文件
[root@server0 ~]# cat /etc/yum.repos.d/rhel7.repo   #查看配置文金阿
[rhel7]             #仓库标识（可随意)
name=rhel7.0        #可随意
baseurl=http://classroom.example.com/content/rhel7.0/x86_64/dvd/
enabled=1           #文件是否启用
gpgcheck=0          #是否检测签名认证 
[root@server0 ~]# yum repolist   #列出仓库信息

 ##############################################
Yum使用加个（-y不用询问是否安装）
   
   Yum -y  install  软件名(httpd  gcc mariadb-server  sssd system-config-kickstart   xeyes

Yum remove
Yum search

 ##############################################
升级Linux内核
   教学环境虚拟机用内核

下载软件包
使用wget(只能下在文件，不能下载目录）
Wget软件包的url网址

Rpm -ivh karnel```````

安装时一定要等待安装完成，因为内核升级是删除旧的内核，安装新的内核

 ##############################################
配置网络

----配置永久的主机名/etc/hostname

[root@server0 ~]# vim /etc/hostname
[root@server0 ~]# exit
登出
Connection to 172.25.0.11 closed.
[root@room11pc31 ~]# gos
Last login: Tue Jul  3 16:12:06 2018 from 172.25.0.250
[root@gos ~]# 

 ##############################################
配置永久ip 子网掩码 网关地址

命令配置
-Nmcli connection 
先识别网卡名  Nmcli connection  show

配置IP 子网掩码 网关
[root@服务器 ~]# nmcli  connection modify  'System eth0'                                         ipv4.method manual                                                              ipv4.addresses '172.25.0.12/24 172.25.0.254'                                    connection.autoconnect yes 

Nmcli connection 修改 ‘网卡识别名称’
Ipv4.方法 手动配置
Ipv4.地址  ‘ip地址/子网掩码  网关地址‘
每次开机自动启用网络配置


                 ipv4. +TAB
ipv4.addresses           ipv4.dns                 ipv4.may-fail
ipv4.dhcp-client-id      ipv4.dns-search          ipv4.method
ipv4.dhcp-hostname       ipv4.ignore-auto-dns     ipv4.never-default
ipv4.dhcp-send-hostname  ipv4.ignore-auto-routes  ipv4.routes


[root@服务器 ~]# cat -n /etc/sysconfig/network-scripts/ifcfg-eth0 
     1	DEVICE=eth0
     2	BOOTPROTO=none
     3	ONBOOT=yes
     4	TYPE=Ethernet
     5	USERCTL=yes
     6	IPV6INIT=no
     7	PERSISTENT_DHCLIENT=1
     8	IPADDR0=172.25.0.12   #已改
     9	PREFIX0=24
    10	GATEWAY0=172.25.0.254
    11	DEFROUTE=yes
    12	IPV4_FAILURE_FATAL=no
    13	NAME="System eth0"
    14	UUID=5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03

激活命令
Nmcli connection up ‘System eth0’

4.网关查看命令
Route\

[root@服务器 ~]# route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         172.25.0.254    0.0.0.0         UG    1024   0        0 eth0
172.25.0.0      0.0.0.0         255.255.255.0   U     0      0        0 eth0

5.配置DNS
[root@服务器 ~]# vim /etc/resolv.conf （DNS永久配置文件）
[root@服务器 ~]# cat /etc/resolv.conf
nameserver 172.25.254.254（教学环境DNS，只能解释3个网址）

验证：nslookup

