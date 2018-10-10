Cluster day3
Keepalived Keeplived+LVS  HAProxy

1.Keepalived
  1.1 Keepalived 概述
  1.2 Keepalived 运行原理
2.配置HA集群Keepalived
3.配置Keepalived+LVS
4.HAproxy服务器
   4.1

##################################################################################
Keepalived
●Keepalived 概述
  &调度器出现单点故障，如何解决？
  &keepalived最初时为LVS设计的，专门监控各服务器节点的状态
  &Keepalived后来加入了VRRP功能，防止单点故障
●Keepalived 运行原理
  &Keepalived检测每个服务器节点状态
  &服务器节点异常或者工作出现故障，Keepalived将故障节点从集群系统中踢除
  &故障节点恢复后,Keepalived再将其加入到集群系统中
  &所有工作自动完成，无需人工干预
##################################################################################
配置HA集群Keepalived
●案例拓扑
  web55  eth0 192.168.4.55  
  web57  eth0 192.168.4.57 
  VIP 192.168.4.252
●编写网页文件
  主机55和主机57都需要编写 
  [root@web55 ~]# echo "55555"  > /var/www/html/index.html
  [root@web57 ~]# echo "575757"  > /var/www/html/index.html
●装包
   #高可用软件再每个节点都需要安装
  [root@web55 ~]# yum -y install keepalived
  [root@web57 ~]# yum -y install keepalived
●配置
 +web55    
  [root@web55 ~]# cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak  #备份
  [root@web55 ~]# vim /etc/keepalived/keepalived.conf
  <------------------------------------------------------------------
 ! Configuration File for keepalived   in

  global_defs {                  #全局配置
   notification_email {
     acassen@firewall.loc        #收件人
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc  #发件人
   smtp_server 192.168.200.1
   smtp_connect_timeout 30
   router_id LVS_DEVEL
   vrrp_skip_check_adv_addr
#   vrrp_strict             #增加注释，因为开启时会拒绝访问VIP
   vrrp_garp_interval 0
   vrrp_gna_interval 0
  }

  vrrp_instance webha {      #修改，高可用集群名称，同一集群需要一致
    state MASTER
    interface eth0              
    virtual_router_id 51     #同一集群需要一致
    priority 150             #修改，优先级高的作为主服务器
    advert_int 1             
    authentication {
        auth_type PASS       #同一集群需要一致
        auth_pass 123456     #修改，同一集群需要一致
     }
    virtual_ipaddress {      #修改，可以设置多个
        192.168.4.252
     }
   }
   以下都不要 1000dd
   ------------------------------------------------------------------>
      
 +web57
  [root@web57 ~]# cp /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak  #备份
  [root@web57 ~]# vim /etc/keepalived/keepalived.conf
  <------------------------------------------------------------------
 ! Configuration File for keepalived   in

  global_defs {                  #全局配置
   notification_email {
     acassen@firewall.loc        #收件人
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc  #发件人
   smtp_server 192.168.200.1
   smtp_connect_timeout 30
   router_id LVS_DEVEL
   vrrp_skip_check_adv_addr
#   vrrp_strict              #增加注释，因为开启时会拒绝访问VIP
   vrrp_garp_interval 0
   vrrp_gna_interval 0
  }

  vrrp_instance webha {      #修改，高可用集群名称，同一集群需要一致
    state BACKUP             #修改，主机web57作为从库
    interface eth0              
    virtual_router_id 51     #同一集群需要一致
    priority 100             #修改，优先级高的作为主服务器
    advert_int 1             
    authentication {
        auth_type PASS       #同一集群需要一致
        auth_pass 123456     #修改，同一集群需要一致
    }
    virtual_ipaddress {      #修改，可以设置多个
        192.168.4.252
      }
   }
    以下都不要 1000dd
   ------------------------------------------------------------------>
●查看VIP
  [root@web55 ~]# ip addr show | grep 192.168.4
    inet 192.168.4.55/24 brd 192.168.4.255 scope global eth0
    inet 192.168.4.252/32 scope global eth0   #主服务器才能看到
    
  [root@web57 ~]# ip addr show | grep 192.168.4.
    inet 192.168.4.57/24 brd 192.168.4.255 scope global eth0

●起服务
  先起主机55，再起主机57
  [root@web55 ~]# systemctl restart keepalived.service 
  [root@web55 ~]# systemctl enable keepalived.service 
##################################################################################
客户端测试 keepalived集群
●正常测试    
 [root@redis56 ~]# curl 192.168.4.252
  55555
●停服务，测试高可用
 [root@web55 ~]# systemctl stop keepalived.service
 [root@web55 ~]# ip addr show | grep 192.168.4   #可以看到没有VIP了
    inet 192.168.4.55/24 brd 192.168.4.255 scope global eth0 
 [root@web57 ~]# ip addr show | grep 192.168.4.  #可以主机57抢占VIP
    inet 192.168.4.57/24 brd 192.168.4.255 scope global eth0
    inet 192.168.4.252/32 scope global eth0

●客户端再次测试
 [root@redis56 ~]# curl 192.168.4.252
  575757
##################################################################################
搭建Keepalived+LVS
●案例拓扑
  proxy54  eth0-192.168.4.54     #主分发器
  proxy56  eth0-192.168.4.56     #备用分发器
  web52    eth0-192.168.4.52  lo:1-192.168.4.253  #沿用昨天配置，arp内核参数ok，有web
  web53    eth0-192.168.4.53  lo:1-192.168.4.253  #沿用昨天配置，arp内核参数ok，有web
●需求：
  把主机56配置为备用的LVS调度器：当分发器54主机宕机后，客户端主机荏苒可以连接VIP地址192.168.4.253访问网站集群。
●装包
  [root@proxy54 ~]# yum -y install ipvsadm   
  [root@proxy54 ~]# systemctl enable ipvsadm.service
  [root@proxy54 ~]# yum -y install keepalived
  
  [root@proxy56 ~]# yum -y install ipvsadm   
  [root@proxy56 ~]# systemctl enable ipvsadm.service
  [root@proxy56 ~]# yum -y install keepalived
  
●环境配置
   #把昨天配置的proxy54里面的 LVS策略删除，eth0：1删除
  [root@proxy54 ~]# ipvsadm -C
  [root@proxy54 ~]# ifdown eth0:1
  [root@proxy54 ~]# sed -n "12p;18p" /etc/sysconfig/ipvsadm-config
  IPVS_SAVE_ON_STOP="yes"       #设置开机自起动文件为/etc/sysconfig/ipvsadm
  IPVS_SAVE_ON_RESTART="yes"

●主机54修改配置文件  #做 主分发器 主机54的配置文件keepalived.conf
[root@proxy54 ~]# vim /etc/keepalived/keepalived.conf
<--------------------------------------------------------------------
  ! Configuration File for keepalived             in

global_defs {
   notification_email {
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc
   smtp_server 192.168.200.1
   smtp_connect_timeout 30
   router_id LVS_DEVEL
   vrrp_skip_check_adv_addr
#   vrrp_strict                 #默认不启用VIP，需要注释
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 150              #54作为主分发器，优先级高
    advert_int 1              #心跳检查
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.4.253
    }
}

virtual_server 192.168.4.253 80 {   #一个LVS服务，一个virtual_server配置
    delay_loop 6
    lb_algo wrr              #LVS调度算法
    lb_kind DR               #LVS-DR模式
    persistence_timeout 50
    protocol TCP

    real_server 192.168.4.52 80 {  #有多少个集群节点，就配置多少个real_server
        weight 1               
            connect_timeout 3     #对real_server做健康性检查
            nb_get_retry 3
            delay_before_retry 3
    }
    real_server 192.168.4.53 80 {  #有多少个集群节点，就配置多少个real_server
        weight 1               
            connect_timeout 3     #对real_server做健康性检查
            nb_get_retry 3
            delay_before_retry 3
    }    
}
1000dd删除
-------------------------------------------------------------------->
  
●主机56修改配置文件  #做 备用分发器 主机56的配置文件keepalived.conf
                        #可以从主机54拷贝，修改优先级即可
[root@proxy56 ~]# vim /etc/keepalived/keepalived.conf
<--------------------------------------------------------------------
  ! Configuration File for keepalived             in

global_defs {
   notification_email {
     acassen@firewall.loc
     failover@firewall.loc
     sysadmin@firewall.loc
   }
   notification_email_from Alexandre.Cassen@firewall.loc
   smtp_server 192.168.200.1
   smtp_connect_timeout 30
   router_id LVS_DEVEL
   vrrp_skip_check_adv_addr
#   vrrp_strict                 #默认不启用VIP，需要注释
   vrrp_garp_interval 0
   vrrp_gna_interval 0
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100              #修改，56作为主分发器，优先级高
    advert_int 1              #心跳检查
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.4.253
    }
}

virtual_server 192.168.4.253 80 {   #修改，一个LVS服务，一个virtual_server配置
    delay_loop 6
    lb_algo wrr              #修改，LVS调度算法
    lb_kind DR               #修改，LVS-DR模式
    persistence_timeout 50
    protocol TCP

    real_server 192.168.4.52 80 {  #有多少个集群节点，就配置多少个real_server
        weight 1               
            connect_timeout 3     #对real_server做健康性检查
            nb_get_retry 3
            delay_before_retry 3
    }
    real_server 192.168.4.53 80 {  #有多少个集群节点，就配置多少个real_server
        weight 1               
            connect_timeout 3     #对real_server做健康性检查
            nb_get_retry 3
            delay_before_retry 3
    }    
}
1000dd删除
-------------------------------------------------------------------->  

●起服务  
  [root@proxy54 ~]# systemctl restart keepalived
  [root@proxy54 ~]# systemctl enable keepalived
  [root@proxy56 ~]# systemctl restart keepalived
  [root@proxy56 ~]# systemctl enable keepalived
●查看VIP
  [root@proxy54 ~]# ip addr show | grep 192.168.4.
    inet 192.168.4.54/24 brd 192.168.4.255 scope global eth0
    inet 192.168.4.253/32 scope global eth0
  [root@proxy56 ~]# ip addr show | grep 192.168.4
    inet 192.168.4.56/24 brd 192.168.4.255 scope global eth0
  
##################################################################################
客户端测试 keepalived+LVS  
●正常测试  #可以看到，值调度一个服务器；原因是配置文件设置了每50秒轮询一次；请看下面
  [root@client50 ~]# curl 192.168.4.253
  525252
  [root@client50 ~]# curl 192.168.4.253
  525252
  [root@client50 ~]# curl 192.168.4.253
  525252

  [root@proxy54 ~]# ipvsadm -Ln   #可以看到下面 有 persistent 50，这是每50秒轮询一次
   IP Virtual Server version 1.2.1 (size=4096)
   Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
   TCP  192.168.4.253:80 rr persistent 50    
    -> 192.168.4.52:80              Route   1      0          0         
    -> 192.168.4.53:80              Route   1      0          0
    
●解决按时间轮询调度服务器   #两台调度器都配置
  [root@proxy54 ~]# sed -i '/.*persist.*/s/^/#/' /etc/keepalived/keepalived.conf
  #    persistence_timeout 50  
  [root@proxy54 ~]# systemctl restart keepalived
  
  [root@proxy56 ~]# sed -i '/.*persist.*/s/^/#/' /etc/keepalived/keepalived.conf
  #    persistence_timeout 50
  [root@proxy56 ~]# systemctl restart keepalived

●再测试
   [root@client50 ~]# curl 192.168.4.253
   525252
   [root@client50 ~]# curl 192.168.4.253
   535353
   [root@client50 ~]# curl 192.168.4.253
   525252
   [root@client50 ~]# curl 192.168.4.253
   535353
##################################################################################
客户端测试 keepalived+LVS
●停服务，测试高可用  
  [root@proxy54 ~]# systemctl stop keepalived.service 
  [root@proxy54 ~]# ip addr show | grep 192.168.4
    inet 192.168.4.54/24 brd 192.168.4.255 scope global eth0
    
  [root@proxy56 ~]# ip addr show | grep 192.168.4  #主机56抢占VIP
    inet 192.168.4.56/24 brd 192.168.4.255 scope global eth0
    inet 192.168.4.253/32 scope global eth0
##################################################################################
扩展：
●配置keepalived 对lvs服务的real_server 做健康性检查
 
●加上 TCP_CHECK {} 就可以对80端口进行健康性检查 如下  
  
  real_server 192.168.4.52 80 {
        weight 1
        TCP_CHECK {
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
          }
    }
    real_server 192.168.4.53 80 {
        weight 1
        TCP_CHECK {
            connect_timeout 3
            nb_get_retry 3
            delay_before_retry 3
          }
   }
##################################################################################
LVS与HAproxy对比
HAproxy 
  可以基于4/7层的调度
  支持动静分离的调度（部分服务器处理动态页面，部分处理静态页面）
  DR模式时，支持100+台real_server

LVS特点 
  基于端口，基于四层的软件
  DR模式时，支持20台real_server
################################################################################## 
HAproxy服务器
● AProxy简介
  & 它是免费、快速并且可靠的一种解决方案
  & 适用于那些负载特大的web站点,这些站点通常又需要会话保持或七层处理
  & 提供高可用性、负载均衡以及基于TCP和HTTP应用的代理
  
● 衡量负责均衡器性能的因素    #了解
  & Session rate 会话率     
     –  每秒钟产生的会话数
  & Session concurrency 并发会话数  
     –  服务器处理会话的时间越长,并发会话数越多
  & Data rate 数据速率
     –  以MB/s或Mbps衡量
     –  大的对象导致并发会话数增加
     –  高会话数、高数据速率要求更多的内存
  
● HAProxy工作模式  #背
  & mode http
     –  客户端请求被深度分析后再发往服务器
•  mode tcp
–  客户端与服务器之间建立会话,不检查第七层信息
•  mode health
–  仅做健康状态检查,已经不建议使用  
##################################################################################  
HTTP协议解析
● HTTP解析
• 当HAProxy运行在HTTP模式下,HTTP请求
(Request)和响应(Response)均被完全分析和索引,这样便于创建恰当的匹配规则
•  理解HTTP请求和响应,对于更好的创建匹配规则至关重要 
  
● HTTP事务模型
•  HTTP协议是事务驱动的
•  每个请求(Request)仅能对应一个响应(Response)
•  常见模型:
–  HTTP close
–  Keep-alive
–  Pipelining 
  
● HTTP事务模型(续1)
•  HTTP close
–  客户端向服务器建立一个TCP连接
–  客户端发送请求给服务器
–  服务器响应客户端请求后即断开连接
–  如果客户端到服务器的请求不只一个,那么就要不断的
去建立连接
–  TCP三次握手消耗相对较大的系统资源,同时延迟较大  
  
● HTTP事务模型(续2)
•  Keep-alive
–  一次连接可以传输多个请求
–  客户端需要知道传输内容的长度,以避免无限期的等待传输结束
–  降低两个HTTP事务间的延迟
–  需要相对较少的服务器资源
  
● HTTP事务模型(续3)
•  Pipelining
–  仍然使用Keep-alive
–  在发送后续请求前,不用等前面的请求已经得到回应
–  适用于有大量图片的页面
–  降低了多次请求之间的网络延迟  
   
●  HTTP头部信息
•  请求头部信息
–  方法:GET
   URL:http://www.baidu.com/music/88.mp3
–  URI:/music/88.mp3
–  版本:HTTP/1.1 
  
 HTTP头部信息(续1)
•  请求头部信息
–  请求头包含许多有关的客户端环境和请求正文的有用信息,如浏览器所使用的语言、请求正文的长度等 
  
 HTTP头部信息(续2)
•  响应头部信息
–  版本:HTTP/1.1
–  状态码:200
–  原因:OK  
################################################################################## 
搭建HAproxy集群
●案例拓扑
  proxy56  eth0-192.168.4.56
  web55    eth0-192.168.4.55  #有网页文件及服务
  web57    eth0-192.168.4.57  #有网页文件及服务

●环境准备
 [root@proxy56 ~]# systemctl stop keepalived
 [root@proxy56 ~]# systemctl disable keepalived
 [root@proxy55 ~]# systemctl stop keepalived
 [root@proxy55 ~]# systemctl disable keepalived
 [root@proxy57 ~]# systemctl stop keepalived
 [root@proxy57 ~]# systemctl disable keepalived
  
●装包haproxy  
  [root@proxy56 ~]# yum -y install haproxy
●修改配置文件
配置文件说明
•  HAProxy配置参数来源
–  命令行:总是具有最高优先级
–  global部分:全局设置进程级别参数
–  代理声明部分
配置文件说明(续1)
•  配置文件可由如下部分构成:
–  default
为后续的其他部分设置缺省参数
缺省参数可以被后续部分重置 
–  frontend                      #做LB集群时需要，与listen功能一样
描述接收客户端侦听套接字(socket)集 
–  backend                       #做LB集群时需要
描述转发链接的服务器集
–  listen
把frontend和backend结合到一起的完整声明

来自于default、listen、frontend和backend


	

 [root@proxy56 ~]# cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
 [root@proxy56 ~]# vim /etc/haproxy/haproxy.cfg
 <-----------------------------------------------------------------------------------
global
.. ..
listen	websrv-rewrite	0.0.0.0:80	
cookie	SERVERID	rewrite	
balance	roundrobin	
server	web1	192.168.4.55:80	cookie	\	 
app1inst1	check	inter	2000	rise	2	fall	5 
server	web2	192.168.4.57:80	cookie	\	
app1inst2	check	inter	2000	rise	2	fall	5
#cookie名称 检查 间隔 2000毫秒 重试 2秒 总次数 5次
##################################################################################  
验证健康性检查，高可用
●访问haproxy 服务uri  路径查看realserver主机的健康信息
  firefos 192.168.4.56/admin
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
