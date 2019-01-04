Cluster day2
集群及LVS

1.集群及LVS简介
  1.1 什么是集群
  1.2 集群的目的
  1.3 集群分类
  1.4 集群软件
2.LVS集群
  2.1 LVS集群组成
  2.2 LVS术语
  2.3 LVS工作模式
  2.4 LVS调度算法
3.ipvsadm
4.LVS-NAT搭建
   4.1 案例拓扑
   4.2 环境准备
   4.3 配置分发器
   4.4 配置真实服务器
   4.5 客户端测试
5.LVS-DR搭建
   5.1 案例拓扑
   5.2 环境准备
   5.3 配置分发器
   5.4 配置真实服务器
   5.5 客户端测试
##################################################################################
集群及LVS简介
●什么是集群
  &一组通过高速网络互联的计算组，并以单一系统的模式管理
  &将很多服务器集中起来，提供同一个服务，在客户端看起来就像是只有一个服务器
  &任务调度是集群系统中的核心技术

●集群的目的
  &提高性能       #如计算密集型应用，如：天气预报，核试验模拟
  &降低成本       #相对百万美元级的超级计算机，价格便宜
  &提高可扩展性   #只需要增加集群节点即可
  &增强可靠性     #多克节点完成相同的功能，避免单典故张

●集群分类
  &高性能计算集群HPC   #航天航空，军工
  &负载均衡集群(LB集群) #客户端负载在计算机集群中尽可能平均分摊
  &高可用集群(HA集群)   #主备模式，避免单点故障、

●集群软件
  LB： LVS Haproxy nginx
  HA： keepalive
##################################################################################
LVS
●LVS集群组成
 +前端：负载均衡层      #有一台或者多台负载调度器组成
 +中间：服务器群组层    #由一组实际运行应用服务的服务器组成
 +底端：数据共享存储层  #提供共享存储空间的存储区域

●LVS术语
 +Director Server  #调度服务器
 +Real Server     #真实服务器，提供服务的服务器
 +VIP    #虚拟服务器IP地址，公布给客户端访问的IP地址,
 +RIP    #真实服务器IP值地，集群节点上的IP地址
 +DIP    #调度器链接节点服务器的IP地址

●LVS工作模式
 VS/NAT  #通过网络地址转换的实现的虚拟服务器
            #大并发量访问，调度器的性能成为瓶颈
 VS/DR   #节点服务器需要配置VIP，接到分发器请求后，节点服务器直接回应客户端
 VS/TUN  #隧道方式实现虚拟服务器。
            #用于LB集群的调度器，且不是同一台机器，不在同一机房
 LVS/fullNAT  #抗攻击，跨vlan
              解决了跨VLAN的问题。采用这种方式，LVS和RS的部署在VLAN上将不再有任何限制，大大提高了运维部署的便利性。
●LVS调度算法
 +常用:
   &轮询 (rr)
   &加权轮询 (wrr)
   &最少连接 (lc)
   &加权最少连接 (wlc)  
 +了解: 
   &源地址散列
   &目标地址散列
##################################################################################   
ipvsadm用法
●选项
  -A  #添加虚拟服务器
  -E  #编辑虚拟服务器集群属性
  -D  #删除指定虚拟服务器
  -t  #设置VIP
  -s  #指定负载调度算法
  -a  #添加真实服务器
  -d  #删除真实服务器
  -e  #编辑真实服务器集群属性
  -r  #指定真实服务器(Real Server)
  -m  #NAT模式
  -g  #DR模式
  -i  #TUN模式
  -w  #指定权重，默认1
  -Ln #查看配置，可配合 --stats使用
  -S  #保存配置
  -C  #删除全部配置
  -Z  #清空计数器，--stats查不到
  -v  #版本
●创建虚拟服务器
  ipvsadm -A -t 192.168.2.54:80 -s rr 
●创建真实服务器
  ipvsadm -a -t 192.168.2.54:80 -r 192.168.4.52 -m -w 2
  ipvsadm -a -t 192.168.2.54:80 -r 192.168.4.53 -m 
●删除真实服务器
  ipvsadm -d -t 192.168.2.54:80 -r 192.168.4.53 -m 
●查看配置      
  ipvsadm -Ln
  ipvsadm -Ln --stats #详细连接信息(包括连接数，流量)
  watch -n 1 ipvsadm -Ln --stats #动态监控
●清空计数器
  ipvsadm -Z  
●修改调度算法
  ipvsadm -E -t 192.168.2.54:80 -s wrr
●修改调度算法
  ipvsadm -e -t 192.168.2.54:80 -r 192.168.4.52 -m -w 4
●保存配置
  ipvsadm -S
  ipvsadm -S > /etc/sysconfig/ipvsadm  #永久配置
●设置开机自启动
  systemctl enable ipvsadm
##################################################################################
总结：LVS的四种工作模式
LVS/NAT      real-server必须与LVS是同一VLAN,同一网段
             real-server必须指定默认网关是LVS

LVS/DR       real-server必须与LVS是同一VLAN，太容易网段
             real-server必须绑定VIP在环地址上lo:1
             real-server不能响应vip的arp广播

LVS/TUN      real-server 必须绑定vip
             real-server 都必须与 lvs 简历 ipip 隧道连接 

LVS/full-nat RS与LVS不需要在同一VLAN、通过ospf群组实现NAT
        #基于centos 6.x开发的

注：
#Linux系统内核实现的IP隧道技术主要有三种（PPP、PPTP和L2TP等协议或软件不是基于内核模块的）：
ipip、gre、sit 。这三种隧道技术都需要内核模块 tunnel4.ko 的支持。
##################################################################################
LVS-NAT集群搭建
●案例拓扑
  client50  eth0:down;        eth1:192.168.2.50  #客户机
  proxy54   eth0:192.168.4.54 eth1:192.168.2.54  #分法器
  web52     eth0:192.168.4.52 eth1:无IP          #Real Server1
  web53     eth0:192.168.4.53 eth1:无IP          #Real Server2
  storage51 eth0:192.168.4.51    #底端存储，存放两台web网页文件
                                          #51用NFS共享，52，53挂载使用
●环境配置
  +配置以上拓扑，且配置网关
    &两台Real server配置网关       #用route命令
     [root@web52 ~]# systemctl stop NetworkManager  #该服务会影响某些网络配置
     [root@web52 ~]# systemctl disable NetworkManager
     [root@web52 ~]# route add default gw 192.168.4.54 #add-->del,删除网关
     [root@web52 ~]# route -n  #查看到IP 
      #主机53配置同上
    &客户端配置网关为 192.168.2.54   #命令同上
    
  +主机52，53配置web
     #51用NFS共享目录/sharedir，且是单独一块磁盘；52，53挂载使用
    [root@storage51 sharedir]# rm -rf *.html
    [root@storage51 sharedir]# ls
    lost+found
    [root@storage51 sharedir]# echo 123 > test.html 
    [root@web52 ~]# cat /var/www/html/test.html 
     123

  +配置分法器54
    &开启路由转发功能
    [root@proxy54 ~]# sysctl -a | grep ip_forward  
    net.ipv4.ip_forward = 1   #教学环境默认开启
    [root@proxy54 ~]# sysctl -p
    [root@proxy54 ~]# echo "net.ipv4.ip_forward = 1" >>/etc/sysctl.conf 
    [root@proxy54 ~]# sysctl -p
    net.ipv4.ip_forward = 1   
    
●分发器配置
    &创建虚拟服务器
    [root@proxy54 ~]# ipvsadm -A -t 192.168.2.54:80 -s rr 
    &创建真实服务器
    [root@proxy54 ~]# ipvsadm -a -t 192.168.2.54:80 -r 192.168.4.52 -m 
    [root@proxy54 ~]# ipvsadm -a -t 192.168.2.54:80 -r 192.168.4.53 -m 
    &查看配置      
    [root@proxy54 ~]# ipvsadm -Ln
    IP Virtual Server version 1.2.1 (size=4096)
    Prot LocalAddress:Port Scheduler Flags
      -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
    TCP  192.168.2.54:80 rr
      -> 192.168.4.52:80              Masq    1      0          0         
      -> 192.168.4.53:80              Masq    1      0          0
    &修改配置文件，设置开机自启动
    [root@proxy54 ~]# sed -n "12p;18p" /etc/sysconfig/ipvsadm-config
    IPVS_SAVE_ON_STOP="yes"
    IPVS_SAVE_ON_RESTART="yes"
    [root@proxy54 ~]# ipvsadm -S > /etc/sysconfig/ipvsadm

##################################################################################
●测试LVS-NAT集群
 [root@client50 ~]# curl 192.168.2.54/test.html #客户端多次访问网页  
 [root@proxy54 ~]# ipvsadm -Ln --stats          #监控一次 
 [root@proxy54 ~]# watch ipvsadm -Ln --stats    #动态监控以下数据
 Every 2.0s: ipvsadm -Ln --stats                Tue Oct  9 15:45:04 2018

 IP Virtual Server version 1.2.1 (size=4096)
 Prot LocalAddress:Port               Conns   InPkts  OutPkts  InBytes OutBytes
   -> RemoteAddress:Port
 TCP  192.168.2.54:80                     4	 24	  16     1620     2086
   -> 192.168.4.52:80                     2	 12        8	  810     1054
   -> 192.168.4.53:80                     2	 12        8	  810     1032
##################################################################################
LVS-DR集群搭建
需求：客户端访问VIP地址 192.168.4.253 访问网站集群
●案例拓扑
  client50  eth0--192.168.4.50
  proxy54   eth0--192.168.4.54  eth0:1--192.168.4.253/24
  web52     eth0--192.168.4.52  lo:1--192.168.4.253/32
  web53     eth0--192.168.4.53  lo:1--192.168.4.253/32
●环境配置
  +还原LVS-NAT配置(ipvsadm规则，网关)
  +配置以上拓扑
●集群配置
  +配置分发器 54
   & 在本机的eth0接口上绑定VIP地址  #虚拟接口
   [root@proxy54
   [root@proxy54 network-scripts]# cp ifcfg-eth0{,:1}
    #删除UUID,修改以下项，其他不变
   NAME=eth0:1
   DEVICE=eth0:1
   ONBOOT=yes
   IPADDR=192.168.4.253
   PREFIX=24
   [root@proxy54 network-scripts]# ifup eth0:1
  
  +创建集群
   & 创建虚拟服务器
    [root@proxy54 ~]# ipvsadm -A -t 192.168.4.253:80 -s wrr
   & 添加real server  #52权重为1，53权重为2
    [root@proxy54 ~]# ipvsadm -a -t 192.168.4.253:80 -r 192.168.4.52 -g -w 1
    [root@proxy54 ~]# ipvsadm -a -t 192.168.4.253:80 -r 192.168.4.53 -g -w 2
   & 保存配置
    [root@proxy54 ~]# sed -n "12p;18p" /etc/sysconfig/ipvsadm-config
    IPVS_SAVE_ON_STOP="yes"
    IPVS_SAVE_ON_RESTART="yes"
    [root@proxy54 ~]# ipvsadm -S > /etc/sysconfig/ipvsadm  
   & 查看状态信息
    [root@proxy54 ~]# ipvsadm -Ln #可以看到Forward 是Route
    
  +配置real server 52 和 53
   & 修改网络接口的内核参数
    [root@web52 ~]# tail -4 /etc/sysctl.conf #53同理
    net.ipv4.conf.all.arp_ignore=1
    net.ipv4.conf.all.arp_announce=2
    net.ipv4.conf.lo.arp_ignore=1
    net.ipv4.conf.lo.arp_announce=2   
    [root@web52 ~]# systemctl restart systemd-sysctl
    
    @查看值
    [root@web52 ~]# cat /proc/sys/net/ipv4/conf/all/arp_ignore 
      1
    [root@web52 ~]# cat /proc/sys/net/ipv4/conf/all/arp_announce 
      2
    [root@web52 ~]# cat /proc/sys/net/ipv4/conf/lo/arp_ignore 
      1
    [root@web52 ~]# cat /proc/sys/net/ipv4/conf/lo/arp_announce 
      2

   & 在本机的lo接口绑定vip地址 192.168.4.253
    [root@web52 ~]# ifconfig lo:1 192.168.4.253/32 #临时
    [root@web52 ~]# cd /etc/sysconfig/network-scripts/  
    [root@web52 network-scripts]# cat ifcfg-lo:1   #永久
    DEVICE=lo:1
    IPADDR=192.168.4.253   
    NETMASK=255.255.255.255   #掩码为32，即4个255
    NETWORK=192.168.4.253     #网络地址与IP地址一致
    BROADCAST=192.168.4.253   #广播地址与IP地址一致
    ONBOOT=yes
    NAME=lo:1
    [root@web52 network-scripts]# ifup lo:1
         
   & 运行网站服务并编写网页文件
   [root@web52 ~]# echo "525252" > /var/www/html/index.html
   [root@web53 ~]# echo "535353" > /var/www/html/index.html
##################################################################################    
●客户端测试集群配置 
 [root@client50 ~]# curl 192.168.4.253
  525252
 [root@client50 ~]# curl 192.168.4.253
  535353
 [root@client50 ~]# curl 192.168.4.253
  535353
  #可以看到权重分配，两次53，一次52
  
●分发器查看
 [root@proxy54 ~]# ipvsadm -Z
  
  访问web后，再执行以下命令查看信息
 [root@proxy54 ~]# watch -n 1 ipvsadm -Ln --stats
 [root@proxy54 ~]# ipvsadm -Ln --stats
 IP Virtual Server version 1.2.1 (size=4096)
 Prot LocalAddress:Port               Conns   InPkts  OutPkts  InBytes OutBytes
   -> RemoteAddress:Port
 TCP  192.168.4.253:80                    3       18        0     1191        0
   -> 192.168.4.52:80                     1        6        0      397        0
   -> 192.168.4.53:80                     2       12        0      794        0
##################################################################################
扩展
LVS服务做LB集群时，不能对real server做健康性检查
需要写脚本自行检查，去除故障设备

#!/bin/bash
R1="192.168.4.52"
R2="192.168.4.53"
VIP="192.168.4.253"
while :
do
  for i in $R1 $R2  
  do
      nmap -sS -p 80 $i | grep open &>/dev/null
      ns80=$?
      ipvsdam -Ln | grep $i &>/dev/null
      ipvs=$?
        if [ $ns80 -ne 0 ] && [ $ipvs -eq 0 ] ; then
               ipvsadm -d -t $VIP -r $i -g
        elif [ $ns80 -eq 0 ] && [ $ipvs -ne 0 ] ; then
               ipvsadm -a -t $VIP -r $i -g
        else 
               exit
        fi
  done
  sleep 5
done
##################################################################################
LVS-DR工作原理
##################################################################################
LVS-DR生产环境中的拓扑



































