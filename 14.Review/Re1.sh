##################################################################################
●网络: VLAN/TRUNK/以太通道/OSPF/NAT/HSRP/动静态路由/ACL
●网络拓扑结构
  接入层: 将终端主机接入网络
  汇聚层: 实现VLAN间通信
  核心层: 接入外网
●IP地址规划\VLAN规划 
   私有地址
  A: 10.0.0.0/8
  B: 172.16.0.0~172.31.0.0/16
  C: 192.168.0.0~192.168.255.0/24 
  
  1教室: 192.168.1.0  vlan1
  2教室: 192.168.2.0  vlan2
 N教室: 192.168.N.0 vlanN
●拓扑配置
 为了不同VLAN网段之间通信,需要在三层交换机上配置三层交换功能
 为了实现交换机各VLAN访问外网,三层交换机上配置路由端口,配置默认路由
 为了实现局域网可以访问外网,路由器也要配置默认路由
 为了可以在路由器上配置到VLAN的汇总路由[ip route 192.168.0.0 255.255.0.0 172.16.1.2 ]
●ACL
 ACL:不允许教室主动连接办公区
 标准: 编号1-99,只检查数据包的源Ip地址
 扩展: 编号100-199, 检查源和目标IP地址及协议 \ 端口号
 命名ACL:也有标准和扩展之分,只不过使用名字而不是数字进行编号
●NAT:为了实现私有地址可以访问互联网,可以在路由器上配置NAT
 静态 : 1对1 
 动态 : 多对多
 PAT : 多对1 1对多
●VLAN
 什么是VLAN?  
 虚拟局域网\是二层交换机的技术\当主机数量非常大时,会发生广播风暴\为了控制广播域划分了VLAN
 what  where  when   why  who  how
 可以根据主机所在的部门或功能划分VLAN,
 为了实现不同交换机上相同VLAN可以通信,需要配置TRUNK;
 为了实现不同VLAN之间通信,需要配置三层交换
●HSRP
 热备份路由协议, 
 CISCO私有协议.可以是的客户端透明使用网关.
 讲多台路由器加入到一个组中,为不同的路由器设置优先级,根据优先级决定谁是活跃路由器,谁是备份路由器.
 用户网关只想虚拟路由器,发往虚拟路由器的数据将活跃路由器转发
●VRRP
 虚拟冗余路由协议.IEIF标准

●以太通道
  可以将多条链路捆绑成一个逻辑口,提供更大的带宽. 配置以太通道时,需要参与的个端口具有一致的物理状态,并且都是中继链路(或术语同一VLAN)
  
●STP生成树协议. 
  为了防止由于物理环路造成的广播风暴,引入了STP
 
●应用层
  物理层  数据链路层  网络层  传输层  会话层  表示层  应用层













