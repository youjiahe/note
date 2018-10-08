##################################################################################
集群与存储 5天

存储
iscsi  #共享存储
ceph   #分布式存储；云存储的方式
LB集群  #负载均衡集群
HA集群  #高可用集群
##################################################################################
Cluster day1
存储

1.存储技术与应用
  1.1 存储的目标
  1.2 存储技术分类
2.iscsi应用
3.设备文件管理方法
  3.1 devfs
  3.2 udev
      3.2.1 udev作用
      3.2.2 udev应用
4.Mulipath多路径
   4.1 基础知识
        4.1.1 多路径概述
        4.1.2 多路径主要功能
   4.2 配置案例
        4.2.1 拓扑规划
        4.2.2 准备共享存储
        4.2.3 访问共享存储
        4.2.4 多路径设备
        4.2.5 多路径配置概述
        4.2.6 多路径设备识别符
        4.2.7 获取WWID
        4.2.8 指定获取WWID的方法
        4.2.9 为多路径设备配置别名
        4.2.10 起服务并验证
##################################################################################
●存储技术与应用
  +存储的目标
    &存储是根据不同的应用环境通过采取合理、安全、有效的方式
     将数据保存到某些介质上并能保证有效访问
    &保证数据的完整性、安全性
    &数据临时或者长期驻留的媒介
  +存储技术分类
   &SCSI小型计算机系统接口 ---不共享
   &DAS直连式存储    ---不共享
     #讲存储设备他哦难过SCSI接口或光纤通道直接连到计算机上
     #不能实现数据与其他主机的共享
     #占用服务器操作系统资源，如CPU、IO等
     #数据量越大，性能越差
   &NAS网络技术存储
     #一种专用数据存储的服务器，以数据为中心，将存储设备与服务器彻底分离，集中管理数据、
     #从而释放带宽、提高性能、降低总拥有成本、保护投资
     #用户通过TCP/IP协议访问数据----采用标准的NFS/HTTP/CIFS
     #存储大小是固定的
   &SAN存储区域网络
     #通过光纤交换机、光纤路由器、光纤集线器等设备将磁盘阵列、磁带等存储设备与相关服务器连接起来
     #因此形成高速专网网络
     #组成部分：路由器、光纤交换机；接口—SCSI、FC；通信协议：如IP、SCSI
     #因为是通过网络连接的，所以传输不受距离影响
   &Fibre Channel
     组成：
      — 光纤
     — HBA(主机总先适配置器)
     — FC交换机
   &ISCSI技术
     #可以在IP网络上构建SAN
     #将存储行业广泛应用的SCSI接口技术与IP网络相结合
      —优势：1）相对FC SAN ISCSI实现的IP SAN成本低
             2）解决了传输效率、存储容量、兼容性、开放性、安全性等问题
             3）没有距离限制
             4）基于IP协议技术的标准
##################################################################################             
iscsi技术应用
●环境：关闭NetworkManager/Selinux
●配置iscsi
 +装包
  服务端targetcli
  客户端iscsi-initiator-utils
       ISCSI HBA #光纤模块
 +创建存储设备  #配置存放在 /etc/target/saveconfig.json
  &iqn命名：iqn.yyyy-mm.<reverse domain>[:comment]
   &创建后端存储
   &创建target磁盘组
   &创建访问控制acls
   &创建关联luns，绑定后端存储
   &创建监听地址，开放网络接口
   &查看配置
    ~]# cat /etc/target/saveconfig.json
 +前端配置使用  (客户端)
   &指定客户端名称(与服务端指定的需要一致) 
   &发现设备
    man iscsiadm 
    iscsiadm --mode discoverydb --type sendtargets --portal 192.168.4.51 --discover
   &登入设备
    iscsiadm --mode node --targetname iqn.2018-10.cn.tedu.storage51:vdb --portal 192.168.4.51:3260 -l
   &登出设备
   
    iscsiadm --mode node --targetname iqn.2018-10.cn.tedu.storage51:vdb --portal 192.168.4.51:3260 -u
   &查看分区信息  lsblk
   &分区 fdisk /dev/sda
   &格式化分区 mkfs.ext4 /dev/sda1
   &挂载使用  mount /dev/sda1 /var/www/html
##################################################################################      
设备文件管理方法
●devfs
  &linux早期使用的静态管理方法
  &/dev下会有大量静态文件
  &内核版本2.6.13开始被完全取代
●udev
  &只有连接到系统的设备才会添加静态文件
  &与主、次设备编号无关
  &位设备提供持久、一致的名字  #内核根据类型，加载先后顺序，决定设备名称      
##################################################################################      
udev
●udev作用
  +从内核受到添加/移除硬件事件时，udev将会分析
    & /sys目录下的信息  
    & /etc/udev/rules.d目录中的规则
  +基于分析结果,udev会：
    & 处理设备命名
    & 决定要创建哪些设备文件或链接
    & 决定如何设置属性
    & 决定触发哪些事件
        
##################################################################################
udev的应用   
●udev事件监控  
 ~]# udevadm monitor --property        #监视设备信息 
 
 ~]# udevadm monitor --help
 udevadm monitor [--property] [--kernel] [--udev] [--help]
 
 ~]# udevadm --help
 udevadm [--help] [--version] [--debug] COMMAND [COMMAND OPTIONS]
 Send control commands or test the device manager.
 Commands:
  info          Query sysfs or the udev database
  trigger       Request events from the kernel
  settle        Wait for pending udev events
  control       Control the udev daemon
  monitor       Listen to kernel and udev events
  test          Test an event run
  test-builtin  Test a built-in command
   
●获取已经识别设备的硬件信息
 ~]# udevadm info --help
  udevadm info [OPTIONS] [DEVPATH|FILE]
  &-q:指定查找对象 【path/name/symlink/all/property】
  &-n:匹配名称
  &-p:匹配设备绝对路径
  &-a:查看所有属性
      
●如何编写udev规则文件  #从上述命令结果中查找，找出不变的信息
  +文件位置及格式
    /etc/udev/rules.d/<rule_name>.rules
  +规则格式
    <match-key><option><value>[,...]<assignment-key><op>value[,...]
  +操作符
    & == : 匹配
    & != : 不匹配
    & = : 指定赋予的值
    & += : 添加新值
    & := : 指定值，且不允许被替换    
  +例子：    
    & ACTION=="add"
    & KERNEL=="sd[a-z]1"
    & BUS=="scsi"
    & DRIVER!="ide-cdrom"
    & PROGRAM=="myapp.pl",RESULT=="test"
    
    & NAME="udisk"
    & SYMLINK+="data1"
    & OWNER="student"
    & MODE=""
         
  +实例：
  新建iscsi链接名为 /dev/iscsi/vdb
  &查看设备绝对路径
   ~]# udevadm info -q path -n /dev/sdb1  #获取设备信息
   /devices/platform/host9/session7/target9:0:0/9:0:0:0/block/sdb/sdb1
  &以设备绝对路径，查看所有信息
   ~]# udevadm info -q all -p /devices/platform/host9/session7/target9:0:0/9:0:0:0/block/sdb/sdb1 -a   #获取对应路径所有信息 
 looking at device '/devices/platform/host9/session7/target9:0:0/9:0:0:0/block/sdb/sdb1':
    SUBSYSTEM=="block"
    ATTR{size}=="10483712"
    ATTRS{model}=="dishb           "
    ATTRS{vendor}=="LIO-ORG "
 &编写规则文件  
  ~]# cat /etc/udev/rules.d/50.isci51.rules
    SUBSYSTEM=="block", ATTR{size}=="10483712", ATTRS{model}=="dishb           ", ATTRS{vendor}=="LIO-ORG "，SYMLINK+="iscsi/vdb"

●如何编写udev的配置文件
  vim /etc/udev/udev.conf
  & udev_root:创建设备文件位置，默认/dev
  & udev_rules:udev规则文件位置，默认为 /etc/udev/rules.d/
  & udev_log:syslog优先级，缺省为err      
##################################################################################      
Multi_path
●多路径概述
   &当服务器到某一存储设备有多条路径时，每条路径都会识别为一个单独的设备
   &多路径允许将服务器节点和存储阵列间的多个 I/O路径配置为一个单一设备
   &这些I/O路径时可包含独立电缆、交换器和控制器的实体SAN链接、
   &多路径集合了I/O路径，并生成有这些集合路径组成的新设备
●多路径主要功能
  +冗余
    & 主备模式，高可用
  +改进的性能
    & 主主模式，负载均衡

●配置案例
 +环境
  client50   eth0:192.168.4.50; eth1:192.168.2.50      
  storage51  eth0:192.168.4.51; eth1:192.168.2.51
  storage51 创建一个iscsi
 +客户端client50发现iscsi
   通过两个IP地址发现      
 +装包           #client50
  ~]# yum -y install device-mapper-multipath
 +创建配置文件 #client50
  ~]# mpathconf --user_friendly_names n  #不使用友好名称识别
 +获取wwid    #全球时别符
  ~]# /usr/lib/udev/scsi_id --whitelisted -d /dev/sdb 
   36001405c69b5d0a295f4c74b535e10d6
  ~]# /usr/lib/udev/scsi_id -g -d /dev/sdc    #白名单也可以用选项"-g"代替
   36001405c69b5d0a295f4c74b535e10d6      
    #可以看到时一样的wwid，说明两个ip识别回来的iscsi是同一块磁盘
 +修改配置文件
  ~]# vim /etc/multipath.conf
    <----------------------------------------------------------------------    
    G---最后一行
    multipaths {
            multipath {
                  wwid "36001405c69b5d0a295f4c74b535e10d6"
                  alias mpatha                   
            }
    }
    ---------------------------------------------------------------------->
 +起服务
  ~]# systemctl restart multipathd
  ~]# systemctl enable multipathd
 +查看分区信息
  ~]# ls /dev/mapper/mpatha
   /dev/mapper/mpatha
   
  [root@client50 ~]# lsblk
   NAME          MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
   sda             8:0    0    5G  0 disk  
   sdb             8:16   0    5G  0 disk  
   └─mpatha      253:2    0    5G  0 mpath 
   └─mpatha1   253:3    0    5G  0 part  
   sdc             8:32   0    5G  0 disk  
   └─mpatha      253:2    0    5G  0 mpath 
   └─mpatha1   253:3    0    5G  0 part  

 +查看多路径信息
  ~]# multipath -rr   #重新加载多路径信息；会识别哪些路径正在运行
  ~]# multipath -ll   #查看多路径信息；

      
[root@client50 ~]# mpathconf --help
usage: /usr/sbin/mpathconf <command>

Commands:
Enable: --enable 
Disable: --disable
Only allow certain wwids (instead of enable): --allow <WWID>
Set user_friendly_names (Default y): --user_friendly_names <y|n>
Set find_multipaths (Default y): --find_multipaths <y|n>
Load the dm-multipath modules on enable (Default y): --with_module <y|n>
start/stop/reload multipathd (Default n): --with_multipathd <y|n>
select output file (Default /etc/multipath.conf): --outfile <FILE>      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
