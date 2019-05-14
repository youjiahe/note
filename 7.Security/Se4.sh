
##################################################################################
防火墙  #企业里面用的最多的是iptables
RHEL7默认时用firewalld作为防火墙
但firewalld底层还是调用包过滤防火墙iptables

●停止firewalld服务
●装包iptables-services  #如果不装包，则不会开机自启动
##################################################################################
●iptables框架
  1）4表
    fliter       #过滤表
    nat          #地址转换表 
    mangle       #包标记表
    raw          #状态跟踪表，生产环境常闭，因为会大量占用CPU资源
  2）5链
    INPUT        #入站规则
    OUTPUT       #出站规则
    FORWARD      #转发规则
    PREEROUTING  #路由前规则
    POSTROUTING  #路由后规则

●iptables语法
●格式：
   iptables [-t 表名] 选项 [链名] [条件] [-j 目标操作]
●选项： PADFIL
  -I   #插入规则到链开头
  -A   #添加规则到链尾
  -F   #清空fliter表   
  -D   #删除指定行号    
  -L   #查看所有规则    
  -nL  #数字显示端口,必须是nL
  -P   #修改默认规则 【ACCEPT|DROP】
  --line-numbers  #显示行号
●条件：
   协议匹配：-p tcp/icmp/udp #ping是icmp协议
   地址匹配：-s 源地址、-d目标地址
   端口匹配：--sport 源端口 、 --dport 目标端口
   接口匹配：-i 接受数据的网卡、 -o 发送数据的网卡       
●操作：
  ACCEPT
  REJECT
  DROP
  LOG     #用得少，占用磁盘空间。/var/log/message
●注意：
  1）可以不指定表，默认为fliter
  2）可以不指定链，默认是所有链
  3）如果没有找到匹配，执行默认规则  #默认允许
  4）选项/链名/目标操作都是大写
●保存规则：------------------------------------------------------------------------------重要
  service iptables save
   会保存再 /etc/sysconfig/iptables
##################################################################################
主机型防火墙
INPUT
例子:
iptables -t filter -I INPUT -p icmp -j REJECT
iptables -t nat -F                            #清空nat表
iptables -F                                   #清空filter表
iptables -D INPUT 2                           #删除INPUT链的第二行
iptables -p icmp -j LOG /var/log/message      #登陆后记在日志里
iptables -A INPUT -p tcp  -j ACCEPT           #接受所有人访问本机的tcp
iptables -L INPUT                             #查看INPUT链
iptables -P INPUT DROP                        #修改默认规则为DROP
iptables -I INPUT 2 -p icmp -j DROP           #插入第二行
iptables -I INPUT -p tcp --dport 80 -j REJECT         #限制其他机子访问本机的80端口
iptables -I INPUT -p tcp -s 192.168.2.100 -j REJECT   #限制主机192.168.2.100访问自己
iptables -I INPUT -p tcp -d 192.168.2.5 --dport 80 -j REJECT #功能同下
iptables -I INPUT -p tcp -i eth1 --dport 80 -j REJECT #限制其他机子通过192.168.2.5访问80
iptables -I INPUT -p tcp -s 192.168.2.0/24 -j DROP    #对某个网段访问本机tcp，无响应 
##################################################################################
网络型防火墙
FORWARD
●proxy作为路由
[root@proxy ~]# sysctl -a | grep ip_forward  
net.ipv4.ip_forward = 1      #确认proxy的路由参数；1为打开，0为关闭

例子:
iptables -I FORWARD -p tcp --dport 80 -j REJECT #禁止其他机子，通过本机路由到其他机子的80端口
....
route
##################################################################################
案例：
限制其他机子ping本机，允许本机ping其他
●ping过程 
 ping--------->request
 reply<--------pong
●在iptables里面，request包以及reply包的表示
  [root@proxy ~]# iptables -p icmp --help | grep echo
  echo-reply (pong)
  echo-request (ping)
●命令 
iptables -I INPUT -p icmp --icmp-type echo-request -j REJECT
##################################################################################
防火墙扩展规则
可以同时实现多个规则
●格式：
    iptables 选项 链名 -m 扩展模块 --具体扩展条件 -j 目标操作
●模块：
   mac         #mac地址     #不是每个人都懂得改mac地址，所以更安全
   multiport   #多端口指定
   iprange     #ip范围
●扩展条件:

●案例1： 根据MAC地址限制
    iptables -I INPUT -p tcp -m mac --mac 52:54:00:4F:EF:3E -j REJECT
                          #nmap -sP 可以查mac地址
●案例2：限制多个端口访问
 iptables -A INPUT -p tcp -m multiport --dports 1:100,8080 -j REJECT
●案例3：限制ip范围
root@proxy ~]# iptables  -A  INPUT  -p tcp  --dport  22  \
> -m  iprange  --src-range  192.168.4.10-192.168.4.20   -j  ACCEPT
##################################################################################
SNAT

直连路由：
--------------------------------------------------------------------------------------------------
client--4.100-------4.5--proxy--2.5-------2.100--web1
--------------------------------------->
s:4.100         s:4.100        s:4.100    s:4.100  
d:2.100         d:2.100        d:2.100    d:2.100(收下)

                                  <------------------------------------------
s:2.100         s:2.100        s:2.100    s:2.100
d:4.100         d:4.100        d:4.100    d:4.100            
--------------------------------------------------------------------------------------------------

NAT：
---------------------------------------------------------------------------------------------------
client--4.100-------4.5--proxy--2.5-------2.100--web1
--------------------------------------->
s:4.100         s:4.100        s:2.5      s:2.5 
d:2.100         d:2.100        d:2.100    d:2.100(收下)

                                  <------------------------------------------
s:2.100         s:2.100        s:2.100    s:2.100
d:4.100         d:4.100        d:4.100    d:2.5       
---------------------------------------------------------------------------------------------------

iptables -t nat -I POSTROUTING -p tcp -s 192.168.4.0/24 -j SNAT --to-source 192.168.2.5
##################################################################################
虚拟机联网
真机清除所有规则
真机设置NAT：
iptables -t nat -I POSTROUTING -s 192.168.2.0/24 -j SNAT --to-source 176.121.211.192
虚拟机设置DNS,网关
echo "nameserver 8.8.8.8" > /etc/resolv.conf
##################################################################################
如何将本地80 端口的请求转发到8080 端口，当前主机IP 为192.168.2.18
iptables -t nat -I PREROUTING -d 192.168.2.18 -p tcp --dport 80 -j DNAT --to
127.0.0.1:8080











