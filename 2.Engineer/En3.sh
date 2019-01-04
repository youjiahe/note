 ##############################################
列表式循环
-for

格式：for 变量名  in 值列表
      do
           命令行
      done

循环两个方面：1.循环的列表值会参与循环体；2.循环列表值不参与循环体；

造数工具：{起点..结束}
touch {0..20}.txt  在当前路径新建0.txt ～20.txt
 ##############################################
系统安全保护
    SElinux安全机制

    美国NSA国家安全局主导开发，一套增强Linux系统安全的强制访问控制体系

SElinux运行模式（重点）
    介绍
    -enforcing(强制)：     #强制禁止系统不安全行为
    -permissive(宽松):     #禁止高度不安全行为，其他的会在后台记录
    -disabled(彻底禁用)：  #完全不管系统不安全行为
    注意：所有模式的进入disabled 模式，都要经过重启系统(复位也要重启）

    模式切换
    1.当前修改
    -查看当前SElinux状态：getenforce
    -强制与宽松临时切换：setenforce 1|0 （0：permissive  1:enforcing)
    2.修改配置文件
   -开机自动配置：修改配置文件：/etc/selinux/config
    修改SELINUX=permissive
 ##############################################
配置用户环境
-alias别名设置
-unalias
-影响当前用户的配置文件：～/.bashrc
-影响所有用户的配置文件：/etc/bashrc
-影响对应用户的配置文件：/home/student/.bashrc
别名的配置需要新开一个终端后，才生效
 


##############################################
防火墙策略管理
一、搭建基本的Web服务
1.Web服务器：虚拟机Server0
（1）安装软件包
      Apache(httpd)   Nginx(用得越来越多，并发访问量大)     Tomcat(java)  
（2）配置
     httpd用默认配置就行（若需更大的并发访问量则需要该配置文件）
（3）起服务
     [root@server0 ~]# systemctl  restart  httpd
     [root@server0 ~]# systemctl  enable httpd
     ln -s '/usr/lib/systemd/system/httpd.service'
     '/etc/systemd/system/multi-user.target.wants/httpd.service'

注意：Web服务在默认情况不允许本机外用户访问
（4）本地访问 172.25.0.11
   出现测试页面。代表服务已经OK，因为防火墙阻止了
（5）书写网页文件
     用于测试
     默认存放网址路径：/var/www/html
     默认网页文件名字：index.html
   
<marquee><font color=red><h1>NSD1806 （简单的html编辑） 

二、搭建FTP服务（FTP经常用来共享文件）
   （1）安装vsftp软件包
         yum info vsftpd    #查看软件包基本信息
         yum -y install vsftpd #装包
   （2）起服务
         [root@server0 ~]# systemctl  restart vsftpd
         [root@server0 ~]# systemctl  enable vsftpd
   （3）本机测试访问服务 
         firefox ftp://172.25.0.11
         默认FTP服务共享路径：/var/ftp

ftp://176.121.211.207/boom.sh  wget下载到本机，再做其它操作

 ##############################################
RHEL防火墙体系
       -防火墙作用：隔离，默认允许出站，过滤入站
       软件防火墙：昂贵，装在路由前面
       硬件防火墙：只能保护本机，与外界隔离

  
    -firewalld
管理工具：firewall-cmd（命令执行）  firewall-config（图形配置工具）
    
-预设安全区域（RHEL6没有区域，RHEL7进行了改善，把规则分成若干区域）
根据所在的网络场所区分，预设保护规则集
1.public： 仅允许访问本机的sshd（远程管理）、ping、DHCP等少数几个服务
2.trusted：允许任何访问
3.block：  阻塞任何来访请求，明确拒绝（该规则会增加服务器负担）
4.drop：   丢弃任何来访的数据包，不给出反应（节省服务器资源，因为不需要回应）
 ###############################################
防火墙判定规则：匹配及停止(源IP，目标IP)
1.查看数据中源IP地址，检查所有区域中，哪个区域中有该源IP地址的规则，则进入该区域
2.如果没有查找到IP地址，则进入默认区域public

防火墙默认区域修改：
虚拟机server0
firewall-cmd --get-default-zone         #查看默认区域

虚拟机server0
firewall-cmd --set-default-zone=block  #修改默认区域位block (会有回应)
虚拟机desktop0
Ping 172.25.0.11                       #不可以通信，有回应，被拒绝

虚拟机server0
firewall-cmd --set-default-zone=drop   #修改默认区域位block (会有回应)
虚拟机desktop0
Ping 172.25.0.11                       #不可以通信，没美有回应

 ##############################################
修改防火墙安全区域服务
firewall-cmd --set-default-zone=public      #把默认区域改为public
firewall-cmd --zone=public --list-all         #查看默认服务
 public (default, active)
  interfaces: eth0
  sources: 
  services: dhcpv6-client ssh
  ports: 
  masquerade: no
  forward-ports: 
  icmp-blocks: 
  rich rules: 


firewall-cmd --zone=public --add-service=http   #添加服务

互联网常见网络协议：
    http:超文本传输协议(Web用的）                端口号：http（80）
    ftp: 文件传输协议                              端口号：ftp（21）
    https:安全超文本传输协议（加密传输）           端口号：https（443）
    DNS：域名解析协议                            端口号：DNS（53） 
    tftp：简单文件传输协议（不经过任何验证）       端口号：tftp（69）
    telent：远程管理协议（专门管理路由器，交换机） 端口号：telent（23）
    smtp：发邮件协议                              端口号：smtp（25）
pop3：收邮件协议                              端口号：pop3（110）
    snmp：互联网管理协议                          端口号：snmp（161）

永久配置安全区域服务 permanent(永久）
用以上命令增加的服务是临时的，因此需要执行下面命令，使得修改永久
firewall-cmd --permanent --zone=public --add-service=http  
                           #把http服务永久加到public规则中，即写道配置文件中）
firewall-cmd --reload      #重新加载防火墙，相当与重启
 #############################################

实现本机端口映射
端口（可以有多个）：编号标识协议（程序，服务）
数据包：源ip地址，目标ip地址，数据，访问端口号（可以让源找到相应的程序，服务）

 #############################################
高级链接
 
