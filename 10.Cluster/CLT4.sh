1.什么是对象存储，块存储，文件系统存储？  #
2.--image-feature layering ，层级方式创建，是什么意思？
3.磁盘的名字重启后变了，如何修改；从而让ceph集群正常使用？
##################################################################################
Cluster day4
Ceph集群

1.Ceph概述
   1.1 基础知识
       1.1.1 什么是分布式文件系统
       1.1.2 常用分布式文件系统
       1.1.3 什么是ceph
     1.1.4 Ceph组件
   1.2 实验环境准备
2.部署ceph集群
   2.1 准备部署环境
   2.2 部署存储集群
       2.2.1 创建ceph集群
       2.2.2 创建OSD
       2.2.3 验证
3.Ceph块存储
  3.1 什么是块存储
  3.2 块存储集群
      3.2.1 创建镜像
      3.2.2 动态调整大小
      3.2.3 集群内通过KRBD访问
      3.2.4 客户端通过KRBD访问
      3.2.5 创建镜像快照
      3.2.6 使用快照恢复数据
      3.2.7 快照克隆
      3.2.8 客户端撤销磁盘映射
      3.2.9 删除快照与镜像
##################################################################################
Ceph概述
●什么是分布式文件系统
  & 分布式文件系统(Distributed File System)是指文件系统管理的物理存储资源不一定直接连接在本地节点上,而是通过计算机网络与节点相连
  & 分布式文件系统的设计基于客户机/服务器模式

●常用分布式文件系统
  & Lustre    
  & Hadoop    #主流，大数据
  & FastDFS   #主流，国产
  & Ceph      #主流，开源，红帽；今天的实验用的软件包是红帽官方软件
  & GlusterFS
  
●什么是ceph
  & ceph是一个分布式文件系统
  & 具有高扩展、高可用、高性能的特点
  & ceph可以提供对象存储、块存储、文件系统存储
  & ceph可以提供PB级别的存储空间(PB-->TB-->GB)
     –  1024G*1024G=1048576G
  & 软件定义存储(Software Defined Storage)作为存储行业的一大发展趋势,已经越来越受到市场的认可
●ceph组件
  & OSDs
     – 存储设备  #管理磁盘
  & Monitors
     – 集群监控组件
  & MDSs
     – 存放文件系统的元数据(对象存储和块存储不需要该组件)
  & Client
    – ceph客户端
##################################################################################  
实验环境准备 
  & 创建1台客户端虚拟机
  & 创建3台存储集群虚拟机
  & 配置主机名、IP地址、YUM源
  & 修改所有主机的主机名
  & 配置无密码SSH连接  #
  & 配置NTP时间同步
  & 创建虚拟机磁盘

●实验拓扑
  client  eth0-192.168.4.50  
  node1   eth0-192.168.4.51   #Mon,OSD,装ceph-deploy
  node2   eth0-192.168.4.52   #Mon,OSD
  node3   eth0-192.168.4.53   #Mon,OSD
●配置YUM
  & 物理机创建网络yum源服务
  [root@room11pc19 ~]# yum -y install vsftpd
  [root@room11pc19 ~]# mkdir /var/ftp/ceph
  [root@room11pc19 ~]# tail -1 /etc/fstab 
   /var/lib/libvirt/images/iso/rhcs2.0-rhosp9-20161113-x86_64.iso /var/ftp/ceph iso9660 defaults 0 0
  [root@room11pc19 ~]# mount -a
  [root@room11pc19 ~]# systemctl restart vsftpd
 
  & 虚拟机调用YUM源(下面以node1为例)
  [root@node1 ~]# cat /etc/yum.repos.d/ceph.repo	[mon]
[mon]	
name=mon	
baseurl=ftp://192.168.4.254/ceph/rhceph-2.0-rhel-7-x86_64/MON	
gpgcheck=0	
[osd]	
name=osd	
baseurl=ftp://192.168.4.254/ceph/rhceph-2.0-rhel-7-x86_64/OSD	
gpgcheck=0	
[tools]	
name=tools	
baseurl=ftp://192.168.4.254/ceph/rhceph-2.0-rhel-7-x86_64/Tools	
gpgcheck=0	
  
●配置SSH无密钥连接  #node1可以无密钥登陆其他节点，包括自己；因为它既做存储，也做集群管理
  & 修改主机名
  [root@node1 ~]# cat /etc/hosts	
  ...	...	
  192.168.4.10 client	
  192.168.4.11 node1	
  192.168.4.12 node2	
  192.168.4.13 node3	
  & 配置密钥登陆 
  [root@node1 ~]# cat /host.txt
   192.168.4.51
   192.168.4.52
   192.168.4.53
  [root@node1 ~]# yum -y install pssh  #到丁老师的lnmp_soft下找
  [root@node1 ~]# pscp.pssh -A -h host.txt /etc/hosts /etc
  [root@node1 ~]# ssh-keygen -f /root/.ssh/id_rsa -N ''
  [root@node1 ~]# pscp.pssh -A -h host.txt /root/.ssh/id_rsa.pub /root/.ssh/node1.pub
  [root@node1 ~]# pssh -A -h host.txt "cat /root/.ssh/node1.pub >> /root/.ssh/authorized_keys"
 
●NTP时间同步 
  & 客户端创建NTP服务器
  [root@client ~]# yum -y install chrony	
  [root@client ~]# cat /etc/chrony.conf	
  server	0.centos.pool.ntp.org	iburst
  allow	192.168.4.0/24
  local	stratum	10	
  [root@client ~]# systemctl restart chronyd
  & 其他所有主机与其同步时间(下面以node1为例)
  [root@node1 ~]# cat /etc/chrony.conf	
  server 192.168.4.10 iburst	
  [root@node1 ~]# systemctl restart chronyd
●准备磁盘 
  在图形环境中为虚拟机添加磁盘
 [root@room11pc19 ~]# virt-manager
  每台虚拟机都添加3块10G的磁盘
##################################################################################
云主机环境下的操作  centos 7.5
yum install -y yum-utils 
yum-config-manager --add-repo https://dl.fedoraproject.org/pub/epel/7/x86_64/ 
yum install --nogpgcheck -y epel-release 
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 
rm -f /etc/yum.repos.d/dl.fedoraproject.org*

这一步非常重要，如果跳过这一步，直接进行ceph的安装，那么会报如下的错误：

Error: Package: 1:ceph-common-10.2.10-0.el7.x86_64 (Ceph)
           Requires: libbabeltrace.so.1()(64bit)
Error: Package: 1:librados2-10.2.10-0.el7.x86_64 (Ceph)
           Requires: liblttng-ust.so.0()(64bit)
Error: Package: 1:librgw2-10.2.10-0.el7.x86_64 (Ceph)
           Requires: libfcgi.so.0()(64bit)
Error: Package: 1:librbd1-10.2.10-0.el7.x86_64 (Ceph)
           Requires: liblttng-ust.so.0()(64bit)
Error: Package: 1:ceph-common-10.2.10-0.el7.x86_64 (Ceph)
           Requires: libbabeltrace-ctf.so.1()(64bit)
##################################################################################
ceph 相关文件
  & 日志文件
    /root/cluster/ceph-deploy-ceph.log
    
##################################################################################
部署Ceph集群
●安装部署软件 #node1
  [root@node1 ~]# yum -y install ceph-deploy
  [root@node1 ~]# ceph-deploy --help
●创建工作目录 #node1  
  [root@node1 ~]# mkdir /root/ceph-cluster
  [root@node1 ~]# cd /root/ceph-cluster
  [root@node1 ceph-cluster]#
●创建Ceph集群
  & 创建ceph集群配置(所有节点都为mon)
  [root@node1 ~]# ceph-deploy new node1 node2 node3
  & 给所有节点安装ceph软件包
  [root@node1 ~]# ceph-deploy install node1 node2 node3 
  & 初始化所有节点的mon服务(主机名解析必须对)
  [root@node1 ~]# ceph-deploy mon create-initial
●创建OSD    #集群所有主机都要创建
  & 创建日志盘    #用gpt分区方式，因为MBR的总大小不能超过2.2TB
  [root@node1 ~]# parted /dev/vdc mklabel gpt
  [root@node1 ~]# parted /dev/vdc mkpart primary 1M 50%
  [root@node1 ~]# parted /dev/vdc mkpart primary 50% 100%
  [root@node1 ~]# lsblk /dev/vdc
  NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
  vdc    252:16   0  10G  0 disk 
  ├─vdc1 252:17   0   5G  0 part 
  └─vdc2 252:18   0   5G  0 part
   //这两个分区用来做存储服务器的日志journal盘  
   //因为每台机都有两个存储数据的盘，所以需要把第一块盘分出两个区来记录日志
 
  & 日志盘权限修改  #集群所有主机都要做
  [root@node1 ~]# echo "chown ceph:ceph /dev/vdc*"  >> /etc/rc.local 
  [root@node1 ~]# chmod +x /etc/rc.d/rc.local
  [root@node2 ~]# echo "chown ceph:ceph /dev/vdb*"  >> /etc/rc.local 
  [root@node2 ~]# chmod +x /etc/rc.d/rc.local
  [root@node3 ~]# echo "chown ceph:ceph /dev/vdb*"  >> /etc/rc.local 
  [root@node3 ~]# chmod +x /etc/rc.d/rc.local
  
  & 初始化清空磁盘数据(仅node1操作即可)
   //到工作目录下执行
  [root@node1 ceph-cluster]# ceph-deploy disk zap node1:vdd node1:vde
  [root@node1 ceph-cluster]# ceph-deploy disk zap node2:vdc node2:vdd
  [root@node1 ceph-cluster]# ceph-deploy disk zap node3:vdc node3:vdd
  
  & 创建OSD存储空间(仅node1操作即可)  
  [root@node1 ceph-cluster]# ceph-deploy osd create node1:vdd:vdc1 node1:vde:vdc2
  [root@node1 ceph-cluster]# ceph-deploy osd create node2:vdc:vdb1 node2:vdd:vdb2
  [root@node1 ceph-cluster]# ceph-deploy osd create node3:vdc:vdb1 node3:vdd:vdb2
  //node1:vdd:vdc1==主机名：磁盘名：日志磁盘分区名
  
##################################################################################  
验证
● 查看集群状态
  [root@node1 ceph-cluster]# ceph -s
    cluster 103937d0-3e31-4f0a-9722-3c7a0632e5c0
     health HEALTH_OK
     monmap e1: 3 mons at {node1=192.168.4.51:6789/0,node2=192.168.4.52:6789/0,node3=192.168.4.53:6789/0}
            election epoch 4, quorum 0,1,2 node1,node2,node3
     osdmap e31: 6 osds: 6 up, 6 in
            flags sortbitwise
      pgmap v71: 64 pgs, 1 pools, 0 bytes data, 0 objects
            202 MB used, 61171 MB / 61373 MB avail
                  64 active+clean
##################################################################################
● 可能出现的错误
  & osd create创建OSD存储空间,如提示run 'gatherkeys'
   [root@node1 ~]# ceph-deploy gatherkeys node1 node2  node3		
  & ceph -s查看状态,如果失败或者是警告状态
   [root@node1 ~]# systemctl restart ceph\*.service	ceph\*.target	
   //在所有节点,或仅在失败的节点重启服务
    （1）、检查防火墙有没有关闭
    iptables -F 
    getenforce 
    setenforce 0
   （2）、删除之前版本ceph残留的文件
     rm -rf /etc/ceph/*
     rm -rf /var/lib/ceph/*/*
     rm -rf /var/log/ceph/*
     rm -rf /var/run/ceph/*
  & pgs超时
     64 pgs are stuck inactive for more than 300 seconds           in
    处理：
   方法1：
      集群都做
      echo "chown ceph:ceph /dev/vdb*" >> /etc/rc.local
      chmod +x /etc/rc.d/rc.local
       重启
   方法2 ：
      编写udev规则
    [root@node1 ~]# vim /etc/udev/rules.d/90.ceph.rules
    [root@node1 ~]# cat /etc/udev/rules.d/90.ceph.rules
    ACTION=="add",KERNEL=="vdb[12]",OWNER="ceph",GROUP="ceph"
 
##################################################################################


● ceph服务  
 [root@node1 ~]# systemctl restart ceph
 ceph-create-keys@       ceph-mon@node1.service  ceph-osd.target
 ceph-disk@              ceph-mon.target         ceph-radosgw@
 ceph-mds@               ceph-osd@               ceph-radosgw.target
 ceph-mds.target         ceph-osd@0.service      ceph.target
 ceph-mon@               ceph-osd@1.service 
  
################################################################################## 
Ceph块存储
●块存储    #硬盘
  & 单机块设备
  –  光盘
  –  磁盘
  & 分布式块存储
  –  Ceph
  –  Cinder  
  & Ceph块设备也叫做RADOS块设备    
  –  RADOS block device:RBD
  & RBD驱动已经很好的集成在了Linux内核中  #红帽系统，默认有
  & RBD提供了企业功能,如快照、COW克隆等等
  & RBD还支持内存缓存,从而能够大大提高性能  
  & Linux内核可用直接访问Ceph块存储
  & KVM可用借助于librbd访问 
●镜像设备
  映射到设备后，可以当硬盘使用
##################################################################################
配置Ceph块存储集群
●查看存储池
  [root@node1 ~]# ceph osd lspools  #默认有一个rbd池
  0 rbd,
●创建镜像、查看镜像
  [root@node1 ~]# rbd create demo-image --image-feature layering --size 10G
  [root@node1 ~]# rbd create rbd/image --image-feature layering --size 2G
  [root@node1 ~]# rbd create image1 --image  
                  //rbd 创建 镜像名称  镜像格式 层级 大小 10G
  [root@node1 ~]# rbd list
  demo-image
  image
  image1
  [root@node1 ~]# rbd info image1
  rbd image 'image1':
	size 1024 MB in 256 objects
	order 22 (4096 kB objects)
	block_name_prefix: rbd_data.10402ae8944a
	format: 2
	features: layering
	flags: 
##################################################################################	
●动态调整到目标大小
 & 缩小空间
  [root@node1 ~]# rbd info demo-image
  rbd image 'demo-image':
	size 10240 MB in 2560 objects
  [root@node1 ~]# rbd resize --size 4G demo-image --allow-shrink
  Resizing image: 100% complete...done.
  [root@node1 ~]# rbd info demo-image
  rbd image 'demo-image':
	size 4096 MB in 1024 objects
	
 & 扩大空间  
  [root@node1 ~]# rbd resize --size 12G demo-image 
  Resizing image: 100% complete...done.
  [root@node1 ~]# rbd info demo-image
  rbd image 'demo-image':
  	size 12288 MB in 3072 objects
##################################################################################
使用块存储
集群内通过KRBD访问
●将镜像映射为本地磁盘
  [root@node1 ~]# rbd map demo-image 
  /dev/rbd0
  [root@node1 ~]# lsblk /dev/rbd0
  NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
  rbd0 251:0    0  12G  0 disk 
●接下来,格式化了!
  [root@node1 ~]# mkfs.ext4 /dev/rbd0
  [root@node1 ~]# blkid /dev/rbd0
  /dev/rbd0: UUID="100d5bab-a98d-41b2-96c7-35329c3ec13a" TYPE="ext4"
##################################################################################
客户端通过KRBD访问
●装包
  客户端需要安装ceph-common软件包
  [root@client ~]# yum -y install ceph-common  #这样才有映射的命令
  [root@client ~]# ls /etc/ceph
  rbdmap

●拷贝配置文件(否则不知道集群在哪)
  [root@client ~]# scp 192.168.4.51:/etc/ceph/ceph.conf  /etc/ceph/
●拷贝连接密钥(否则无连接权限)
  [root@client ~]# scp 192.168.4.51:/etc/ceph/ceph.client.admin.keyring  /etc/ceph
●映射
●格式化
  [root@client ~]# mkfs.ext4 /dev/rbd0
  [root@client ~]# blkid /dev/rbd0
  /dev/rbd0: UUID="100d5bab-a98d-41b2-96c7-35329c3ec13a" TYPE="ext4"
##################################################################################
创建镜像快照
●快照存的是原文件；可以从对集群文件备份
  
●查看镜像快照/创建
[root@node1 ~]# rbd snap ls image
[root@node1 ~]# rbd snap create image --snap image-snap1
[root@node1 ~]# rbd snap create demo-image --snap demo-image-snap1
[root@node1 ~]# rbd snap ls image
SNAPID NAME           SIZE 
     4 image-snap1 4096 MB 
[root@node1 ~]# rbd snap ls demo-image
SNAPID NAME                 SIZE 
     5 demo-image-snap1 12288 MB 
##################################################################################
●使用快照恢复数据  #再整理
&客户端挂载镜像，并且写入文件
  [root@client ~]# rbd map image3
  [root@client ~]# mkfs.ext4 /dev/rbd1
  [root@client ~]# mkdir /image3
  [root@client ~]# mount /dev/rbd1 /image3
  [root@client ~]# echo "image3" > /image3/3.txt   
&集群管理器创建快照  #node1
  [root@node1 ~]# rbd snap create image3 --snap snap3  
&客户端模拟误删文件
  [root@node1 ~]# rm -rf /image3/3.txt
&客户端卸载
  [root@node1 ~]# umount /image3/
&集群管理器用快照恢复数据
  [root@node1 ~]# rbd snap rollback image3 --snap snap3
&客户端挂载
  [root@client ~]# mount /dev/rbd1 /image3   
##################################################################################
快照克隆
使用image的快照image-snap1克隆一个新的image-clone镜像
 & 如果想从快照恢复出来一个新的镜像,则可以使用克隆
 & 注意,克隆前,需要对快照进行<保护>操作
 & 被保护的快照无法删除,取消保护(unprotect)
●保护快照
   [root@node1 ~]# rbd snap create image1 --snap image1-snap1
   [root@node1 ~]# rbd snap protect image1 --snap image1-snap1
●对快照克隆
[root@node1 ~]# rbd clone image1 --snap image1-snap1 image1-clone --image-feature layering
● 查看克隆镜像与父镜像快照的关系
[root@node1	~]# rbd info image-clone	
rbd	image	'image-clone':	
	size	15360	MB	in	3840	objects	
	order	22	(4096	kB	objects)	
	block_name_prefix:	rbd_data.d3f53d1b58ba	
	format:	2	
	features:	layering	
	flags:		
	parent:	rbd/image@image-snap1	
●快照克隆(续2)
•  克隆镜像很多数据都来自于快照链
•  如果希望克隆镜像可以独立工作,就需要将父快照中的数据,全部拷贝一份,但比较耗时!!!
[root@node1	~]# rbd flatten image-clone	
[root@node1	~]# rbd info image-clone	
rbd	image	'image-clone':	
	size	15360	MB	in	3840	objects	
	order	22	(4096	kB	objects)	
	block_name_prefix:	rbd_data.d3f53d1b58ba	
	format:	2	
	features:	layering	
	flags:		
//注意,父快照信息没了!

##################################################################################
客户端撤销磁盘映射
配置客户端不使用ceph集群的块设备存储数据的步骤
1.umount挂载点

2.查看本地映射了哪些镜像
[root@client ~]# rbd showmapped
3.取消RBD磁盘映射
[root@client ~]# rbd unmap /dev/rbd/rbd/image1
//语法格式:rbd unmap /dev/rbd/{poolname}/{imagename}	
##################################################################################
删除快照与镜像
•  删除快照(确保快照未被保护)
[root@node1	~]# rbd snap rm image --snap image-snap	
•  删除镜像
[root@node1	~]# rbd list	
[root@node1	~]# rbd rm image	





























