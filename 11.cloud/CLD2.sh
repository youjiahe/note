云计算部署与管理
CLOUD DAY02

1.Openstack概述
   1.1 云计算简介
        1.1.1 什么云计算
      1.1.2 IaaS
      1.1.3 PasS
      1.1.4 SaaS       
   1.2 Openstack简介 
        1.2.1 什么是Openstack
      1.2.2 Openstack主要组件
      1.2.3 Openstack版本
      1.2.4 Openstack结构图
3.Openstack环境准备
   3.1 准备两台虚拟机
    openstack   nova01
   3.2 根分区的扩容 50G
   3.3 准备系统资源(CPU,内存，网卡，磁盘)
   3.4 配置yum
  3.5 NTP时间同步
   3.6 真机配置DNS
4.部署openstack 
   4.1 基础环境准备
     【IP/yum/卷组/公钥/额外软件包/检查openstack环境部署】
   4.2 安装Openstack
   4.3 网络配置
        4.3.1 网络拓扑
        4.3.2 配置外部OVS网桥
        4.3.3 配置外部OVS网桥端口
        4.3.4 验证OVS配置
##################################################################################   
Openstack概述
●什么是云计算
 & 基于互联网的相关服务的增加、使用和交付模式
 & 这种模式提供可用的、便捷的、按需的网络访问,进入可配置的计算资源共享池
 & 这些资源能够被快速提供,只需投入很少的管理工作,或与服务供应商进行很少的交互
 & 通常涉及通过互联网来提供懂态易扩展且经常是虚拟化的资源   
##################################################################################
●IaaS  #阿里云、华为云；广义说的云
 & IaaS(Infrastructure as a Service),基础设施即服务
 & 提供给消费者的服务是对所有计算基础设施的利用,
   包括处理CPU、内存、存储、网络和其它基本的计算
   资源,用户能够部署和运行任意软件,包括操作系统
   和应用程序
 & IaaS通常分为三种用法:公有云、私有云和混合云
##################################################################################
●PaaS  #网购网站；淘宝
 & PaaS (Platform-as-a-Service),意思是平台即服务
 & 以服务器平台戒者开发环境作为服务迚行提供就成为了PaaS
 & PaaS运营商所需提供的服务,不仅仅是单纯的基础
    平台,还针对该平台的技术支持服务,甚至针对该平
    台而迚行的应用系统开发、优化等服务
 & 简单地说,PaaS平台是指云环境中的应用基础设施
    服务,也可以说是中间件即服务
################################################################################## 
●SaaS  #安卓市场
 & SaaS(Software-as-a-Service)软件即服务,是一种
    通过Internet提供软件的模式,厂商将应用软件统一部
    署在自己的服务器上,客户可以根据自己实际需求,通
    过互联网向卹商定购所需的应用软件服务
 & 用户不用再购买软件,而是向提供商租用基于Web的软
    件,来管理企业经营活劢,不用对软件迚行维护,提供
    商会全权管理和维护软件,同时也提供软件的离线操作
    和本地数据存储
##################################################################################
Openstack简介 
●什么是Openstack
 & OpenStack是一个由NASA(美国国家航空航天局)
   和Rackspace合作研发并发起的项目
 & OpenStack是一套IaaS解决方案  #重点
 & OpenStack是一个开源的云计算管理平台
 & 以Apache许可证为授权
##################################################################################
Openstack主要组件(7大组件)
● Horizon   #Openstack页面配置工具
   – 用于管理Openstack各种服务的、基于web的管理接口
   – 通过图形界面实现创建用户、管理网络、启动实例等操作
● Keystone  #认证
   – 为其他服务提供认证和授权的集中身份管理服务
   – 也提供了集中的目录服务
   – 支持多种身份认证模式,如密码认证、令牌认证、以及AWS(亚马逊Web服务)登陆
   – 为用户和其他服务提供了SSO认证服务
● Neutron/Quantum   #网络管理
   – 一种软件定义网络服务
   – 用于创建网络、子网、路由器、管理浮动IP地址
   – 可以实现虚拟交换机、虚拟路由器
   – 可用于在项目中创建VPN
● Cinder    #块存储
   – 为虚拟机管理存储卷的服务
   – 为运行在Nova中的实例提供永久的块存储
   – 可以通过快照迚行数据备份
   – 经常应用在实例存储环境中,如数据库文件
● Nova      #虚拟机管理
   – 在节点上用于管理虚拟机的服务
   – Nova是一个分布式的服务,能够与Keystone交互实现
      认证,与Glance交互实现镜像管理
   – Nova被设计成在标准硬件上能够迚行水平扩展
    – 启动实例时,如果有则需要下载镜像
● Glance    #镜像管理
   – 扮演虚拟机镜像注册的角色
   – 允许用户为直接存储拷贝服务器镜像
   – 这些镜像可以用于新建虚拟机的模板
● Swift     #对象存储管理
##################################################################################
Openstack环境准备_系统资源
●真机
  禁用selinux
  禁用防火墙
  systemctl stop firewalld
  systemctl mask firewalld
  
●利用我们昨天做的 node.qcow2 文件和node.xml 创建两台虚拟机
  openstack   50G
  nova01      50G
  [root@room11pc19 images]# qemu-img create -b node.qcow2 -f qcow2 openstack.img 50
  [root@room11pc19 images]# qemu-img create
   -b node.qcow2 -f qcow2 nova01.img 50G

●对上述两台虚拟机做根分区的扩容
 lsblk
 growpart /dev/vda 1
 xfs_growfs /
 lsblk
##################################################################################
准备系统资源
修改后的xml文件 请见文件《xml_details》
●调整内存(修改xml文件，重启)
 & openstack   8.5G以下   
  [root@room11pc19 qemu]# virsh edit openstack  
     <memory unit='KiB'>8848000</memory>               # <!--最大内存-->
     <currentMemory unit='KiB'>8848000</currentMemory> # <!--使用的内存--> 
  [root@room11pc19 qemu]# virsh destroy openstack
  [root@room11pc19 qemu]# virsh start openstack
 & nova01      6.5G
 
●添加一块磁盘(修改xml文件，重启)
 & 真机,创建新镜像作为后端盘,并创建10G前端盘
  [root@room11pc19 images]# qemu-img create -f qcow2  disk.qcow2 20G
  [root@room11pc19 images]# qemu-img create -b \ 
   disk.qcow2 -f qcow2 disk.img 10G
 & 修改openstack.xml文件添加硬盘 
    <disk type='file' device='disk'>  <!--添加硬盘vdb-->
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/disk.img'/> <!--添加的镜像disk.img-->
      <target dev='vdb' bus='virtio'/>
    </disk>
  [root@room11pc19 images]# virsh dominfo openstack
  
●添加网卡(openstack,nova01都添加)
 & 修改openstack.xml文件添加硬盘 
    </interface>
    <interface type='bridge'>      <!--添加网卡设备；mac，address删除-->
      <source bridge='private1'/>  <!--指定网桥private1-->
      <model type='virtio'/>
    </interface>
 & [root@openstack ~]# ifconfig -a  #列出所有
################################mysql51-12.qcow2  mysql52.qcow2     rh7_node12.qcow2
mysql51-13.qcow2  mysql53-10.qcow2  rh7_node13-1.qcow2
mysql51-14.qcow2  mysql53-1.qcow2   rh7_node13-2.qcow2
mysql51-15.qcow2  mysql53-2.qcow2   rh7_node13.img
mysql51-16.qcow2  mysql53-3.qcow2   rh7_node13.qcow2
mysql51-17.qcow2  mysql53-4.qcow2   rh7_node14.img
mysql51-18.qcow2  mysql53-5.qcow2   rh7_node1.img
##################################################
Openstack环境准备_YUM
●配置yum仓库   
  1. CentOS7-1708 光盘内容作为仓库源
   2. 配置 RHEL7-extars 内容加入仓库源
  3. RHEL7OSP-10 光盘中包含多个目录,每个目录都
      是仓库源(可以使用脚本生成)
      
●使用以下脚本创建yum，并且把repo文件发到虚拟机openstack、nova01
#!/bin/bash
rm -rf ./rhel7_extras.repo ./rhel7osp.repo
echo "[rhel7_extra]
name=rhel7_extra
baseurl=ftp://192.168.1.254/RHEL7-extras
enable=1
gpgcheck=0"  > rhel7_extras.repo

fn="tutututu.txt"
ls  /var/ftp/RHEL7OSP-10/ | sed  -n '/^r/p' > $fn
n=0
for i in `cat $fn`
do
  echo "[rhel7osp$n]
name=rhel7_extra
baseurl=ftp://192.168.1.254/RHEL7OSP-10/$i
enable=1
gpgcheck=0"  >> rhel7osp.repo
let n++
done

●客户端写repo文件，并监测
  [root@openstack ~]# yum repolist | grep repolist
  repolist: 10,731
  [root@nova01 ~]# yum repolist | grep repolist
  repolist: 10,731
##################################################################################
Openstack环境准备_设置DNS服务器
●设置DNS服务器
  – openstack 安装时候需要使用外部 dns 来解析域名,并且
     还需要外部时间服务器来保证所有节点的时间保持一致
  – 我仧需要创建一个 dns 服务器,并且为主机提供域名解析
  – 将 openstack.tedu.cn 域名对应的 IP 解析到我仧的安装
    openstack 的服务器
  • 注:DNS 服务器丌能不 openstack 安装在同一台主机上

[root@room11pc19 ~]# vim /etc/named.conf #改以下内容，其他不改
opions {
        listen-on port 53 { 192.168.1.254; };
        allow-query     { any; };
        forwarders { 61.144.56.100; };   
          #广州电信DNS
        dnssec-enable no;
        dnssec-validation no;
}

●真机解析域名 www.baidu.com
[root@room11pc19 ~]# dig @192.168.1.254 www.baidu.com
; <<>> DiG 9.9.4-RedHat-9.9.4-61.el7_5.1 <<>> @192.168.1.254 www.baidu.com
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 10913
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 4, ADDITIONAL: 5

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.baidu.com.			IN	A

;; ANSWER SECTION:
www.baidu.com.		132	IN	CNAME	www.a.shifen.com.
www.a.shifen.com.	209	IN	A	14.215.177.39
www.a.shifen.com.	209	IN	A	14.215.177.38

;; AUTHORITY SECTION:
shifen.com.		167723	IN	NS	ns2.baidu.com.
shifen.com.		167723	IN	NS	dns.baidu.com.
shifen.com.		167723	IN	NS	ns4.baidu.com.
shifen.com.		167723	IN	NS	ns3.baidu.com.

;; ADDITIONAL SECTION:
dns.baidu.com.		99295	IN	A	202.108.22.220
ns2.baidu.com.		99295	IN	A	61.135.165.235
ns3.baidu.com.		99295	IN	A	220.181.37.10
ns4.baidu.com.		99295	IN	A	220.181.38.10

;; Query time: 1 msec
;; SERVER: 192.168.1.254#53(192.168.1.254)
;; WHEN: 三 10月 17 09:51:33 CST 2018
;; MSG SIZE  rcvd: 237

●两台虚拟机(openstack/nova01)配置DNS
  [root@openstack ~]# cat /etc/resolv.conf
  ; generated by /usr/sbin/dhclient-script
  nameserver 192.168.1.254
  [root@nova01 ~]# cat /etc/resolv.conf
  ; generated by /usr/sbin/dhclient-script
  nameserver 192.168.1.254
  
●配置hosts
  [root@openstack ~]# tail -2 /etc/hosts
  192.168.1.100 openstack 
  192.168.1.101 nova01

  [root@nova01 ~]# tail -2 /etc/hosts
  192.168.1.100 openstack 
  192.168.1.101 nova01
##################################################################################
Openstack环境准备_NTP服务
●用真机做服务器
  & 配置/etc/chrony.conf 
  [root@room11pc19 ~]# head -9 /etc/chrony.conf |tail -5
  #server 2.centos.pool.ntp.org iburst
  server ntp1.aliyun.com iburst
  bindacqaddress 0.0.0.0
  allow all 
  cmdallow 127.0.0.1
 & 起服务
  [root@room11pc19 ~]# systemctl restart chronyd
 & 查看是否连到外网NTP
 [root@room11pc19 ~]# chronyc sources -v
  210 Number of sources = 1
  
    .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
   / .- Source state '*' = current synced, '+' = combined , '-' = not combined,
  | /   '?' = unreachable, 'x' = time may be in error, '~' = time too variable.
  ||                                                 .- xxxx [ yyyy ] +/- zzzz
  ||      Reachability register (octal) -.           |  xxxx = adjusted offset,
  ||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
  ||                                \     |          |  zzzz = estimated error.
  ||                                 |    |           \
  MS Name/IP address         Stratum Poll Reach LastRx Last sample               
  ===================================================
  ^* 120.25.115.20                 2   6   377    42   -418us[ -739us] +/- 5611us

[root@room11pc19 ~]# chronyc sources -v
●客户端指定服务器
  [root@openstack ~]# sed -n '6p' /etc/chrony.conf
   server 192.168.1.254 iburst
  [root@nova01 ~]# sed -n '6p' /etc/chrony.conf
   server 192.168.1.254 iburst
##################################################################################
基础环境准备总结
●配置IP地址
  & 配置eth0为公共网络,网络地址192.168.1.0/24
  & 配置eth1为隧道接口,网络地址192.168.4.0/24
  & 关闭NetworkManager服务
  & 禁用 SELINUX
  & 卸载 firewalld
●配置yum客户端
  & 将 CentOS7-1708 光盘作为基础的yum源
  & 将 RHEL7-extars 光盘作为扩展的yum源
  & 将 RHEL7OSP-10 光盘中所有目录作为yum源
●配置卷组
  & Openstack为虚拟机提供的云硬盘,本质上是本地的逻辑卷
  & 逻辑卷创建于名为cinder-volumes的卷组
  & 没有物理卷可以使用 vdb 文件替代
  – pvcreate /dev/vdb
  – vgcreate cinder-volumes /dev/vdb
●导入公钥
  & 安装openstack期间,系统会要求密钥验证
  & 我仧手工导入系统密钥
  & 密钥文件在光盘中提供
##################################################################################
●安装额外软件包
  & 安装openstack期间,有些软件包所依赖的软件包,并没有在安装过程中安装
  & 这些软件包需提前安装
  & 本地RPM包也可以通过yum迚行安装
 [root@nova ~]# yum install -y \
qemu-kvm \
libvirt-client \
libvirt-daemon
libvirt-daemon-driver-qemu \
python-setuptools #python 安装工具

##################################################################################
●检查openstack环境部署
• 是否禁用selinux
• 是否卸载firewalld和NetworkManager
• 检查配置主机网络参数(静态IP)
• 检查配置主机yum源(12个)
• 检查cinder-volumes卷组是否已经创建
• 检查公钥是否导入
• 查看相关软件包是否安装
##################################################################################
●安装openstack
  & 创建应答文件
   [root@openstack ~]# yum install -y openstack-packstack
   [root@openstack ~]# packstack --gen-answer-file answer.ini
  & 修改应答文件
   [root@openstack ~]# vim answer.txt
   11 CONFIG_DEFAULT_PASSWORD=Taren1    #配置默认密码
   42 CONFIG_SWIFT_INSTALL=n   #禁用swift 对象存储模块 （要使用cinder-volumes卷组）
   75 CONFIG_NTP_SERVERS=192.168.1.254  #NTP服务器地址
   98	CONFIG_COMPUTE_HOSTS=192.168.1.11,192.168.1.12
   102 CONFIG_NETWORK_HOSTS=192.168.1.11,192.168.1.12
   554 CONFIG_CINDER_VOLUMES_CREATE=n   #禁用自动创建 cinder-volumns 卷组
   840 CONFIG_NEUTRON_ML2_TYPE_DRIVERS=flat,vxlan  #设置网络支持协议
   876 CONFIG_NEUTRON_ML2_VXLAN_GROUP=239.1.1.5    #设置组播地址
   910 CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS=physnet1:br-ex #设置虚拟交换机
   921 CONFIG_NEUTRON_OVS_BRIDGE_IFACES=br-ex:eth0 #设置虚拟交换机所连接的物理网卡
   936 CONFIG_NEUTRON_OVS_TUNNEL_IF=eth1  #设置隧道网络使用的网卡
   1179 CONFIG_PROVISION_DEMO=n           #禁用测试的DEMO

  & 根据应答文件安装openstack 
  & 一键部署Openstack
   • 如果前期环境准备无误,只要耐心等待安装结束即可
   • 根据主机配置丌同,安装过程需要20分钟左右戒更久
   • 如果出现错误,根据屏幕上给出的日志文件迚行排错
   [root@openstack ~]# packstack --answer-file answer.txt
##################################################################################   
网络配置
●查看br-ex网桥配置（br-ex为OVS网桥设备）
[root@openstack ~]# cat /etc/sysconfig/network-scripts/ifcfg-br-ex 

●查看br-ex网桥配置
[root@openstack network-scripts]# cat ifcfg-br-ex
ONBOOT=yes
NM_CONTROLLED="no"
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.254
DEVICE=br-ex
NAME=br-ex
DEVICETYPE=ovs
OVSBOOTPROTO=static
TYPE=OVSBridge

●查看eth0网卡配置
[root@openstack network-scripts]# cat ifcfg-eth0
DEVICE=eth0
NAME=eth0
DEVICETYPE=ovs
TYPE=OVSPort      #变为虚拟交换机的一个端口
OVS_BRIDGE=br-ex  
ONBOOT=yes
BOOTPROTO=none   

●验证OVS配置 #OVS是虚拟交换机
[root@openstack ~]# ovs-vsctl show
##################################################################################
管理项目
1）浏览器访问
  [root@openstack conf.d]# firefox 192.168.1.1  //访问失败
2）需要改配置文件并重新加载
  [root@openstack ~]# cd /etc/httpd/conf.d/
  [root@openstack conf.d]# vi 15-horizon_vhost.conf
     35   WSGIProcessGroup apache
     36   WSGIApplicationGroup %{GLOBAL}     //添加这一行
  [root@openstack conf.d]# apachectl  graceful  //重新载入配置文件
3）查看用户名密码
[root@openstack ~]# cat keystonerc_admin 
unset OS_SERVICE_TOKEN
    export OS_USERNAME=admin
    export OS_PASSWORD=05c7898388e64e09
    export OS_AUTH_URL=http://192.168.1.100:5000/v2.0
    export PS1='[\u@\h \W(keystone_admin)]\$ '
    
export OS_TENANT_NAME=admin
export OS_REGION_NAME=RegionOne

##################################################################################
●基本概念
• 项目:一组隔离的资源和对象。由一组关联的用户迚行管理
• 在旧版本里,也用租户(tenant)来表示
• 根据配置的需求,项目对应一个组织、一个公司或是一个使用客户等
• 项目中可以有多个用户,项目中的用户可以在该项目
●创建、管理虚拟资源
• 具有admin角色的用户可以创建项目
• 项目相关信息保存到MariaDB中

##################################################################################
●缺省情况下,packstack安装的openstack中有两个
独立的项目
– admin:为admin账户创建的项目
– services:不安装的各个服务相关联
##################################################################################
通过图形配置

##################################################################################
●命令行接口基础
• 初始化环境变量
  [root@openstack ~]# source keystonerc_admin 
  [root@openstack ~(keystone_admin)]# opens
  openssl                         openstack-keystone-sample-data
  openstack                       
  [root@openstack ~(keystone_admin)]# openstack user list #查看项目
+----------------------------------+------------+
| ID                               | Name       |
+----------------------------------+------------+
| 6bbfb06c820840c5ad12d46a10a25759 | admin      |
| 800a58b1e0534e588272d724f7f527ba | neutron    |
| 17780f0173a94c388efbc9caf10aa27a | gnocchi    |
| d7ec3e55f1284f9d82c9bfc2e3ec6cae | aodh       |
| 9f697819fe2443de84ae5270fcc0edf9 | nova       |
| 56a2d651c8ae48f082c1099a32b995cc | glance     |
| be1bff5d03da44b691df06afcccb0327 | ceilometer |
| ff7cd9576a7f4e7a8280011c7e263ec1 | cinder     |
| 301f11cf7d7a4bcca6d405c20682ceed | nb         |
+----------------------------------+------------+
##################################################################################
管理项目
步骤一：浏览器访问openstack
●浏览器访问
  [root@openstack conf.d]# firefox 192.168.1.1  //访问失败
●需要改配置文件并重新加载
  [root@openstack ~]# cd /etc/httpd/conf.d/
  [root@openstack conf.d]# vi 15-horizon_vhost.conf
     35   WSGIProcessGroup apache
     36   WSGIApplicationGroup %{GLOBAL}     //添加这一行
  [root@openstack conf.d]# apachectl  graceful  //重新载入配置文件














