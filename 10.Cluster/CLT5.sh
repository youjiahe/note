Cluster day5

1.块存储应用案例 
  1.1 虚拟机镜像
2.分布式文件系统
3.对象存储
##################################################################################
块存储应用案例
相关知识
●/etc/libvirt/qemu   #KVM虚拟机的文件 
[root@room11pc19 qemu]# vim mysql50.xml 
  <devices>
    <emulator>/usr/libexec/qemu-kvm</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/var/lib/libvirt/images/rh7_node14.img'/>
         #该虚拟机的镜像文件
         
●Ceph认证账户
  •  Ceph默认开启用户认证,客户端需要账户才可以访问
      –  默认账户名称为client.admin,key是账户的密钥
      –  可以使用ceph auth添加新账户(案例我们使用默认账户)
[root@node1 ~]# cat /etc/ceph/ceph.conf 
[global]
fsid = 484a6f3b-d460-4267-b9fa-1428dba74d01        
mon_initial_members = node1, node2, node3
mon_host = 192.168.4.31,192.168.4.32,192.168.4.33
auth_cluster_required = cephx    #开启认证
auth_service_required = cephx    #开启认证
auth_client_required = cephx     #开启认证
  [root@node1 ~]# cat /etc/ceph/ceph.client.admin.keyring 
  [client.admin]
	key = AQB9Rr9b2DDhHRAAmfq2CNr6hK93KClqaIWHsw==
	
●配置libvirt secret  
  & KVM虚拟机需要使用librbd才可以访问ceph集群
  & Librbd访问ceph又需要账户认证
  & 所以这里,我们需要给libvirt设置账户信息  
  
●虚拟机的xml配置文件
  & 每个虚拟机都会有一个XML配置文件,包括:
  –  虚拟机的名称、内存、CPU、磁盘、网卡等信息
  
##################################################################################
块存储应用案例
准备实验环境
沿用搭建好的ceph集群
●创建磁盘镜像
  [root@node1 ~]# rbd create vm1-image --image-feature layering --size 10G
  [root@node1 ~]# rbd create vm2-image --image-feature layering --size 10G
  
●查看镜像
  [root@node1 ~]# rbd list 
  [root@node1 ~]# rbd info vm1-image 
  [root@node1 ~]# qemu-img info rbd:rbd/vm1-image
  image: rbd:rbd/vm1-image
  file format: raw
  virtual size: 10G (10737418240 bytes)
  disk size: unavailable


##################################################################################  
块存储应用案例
●客户端部署环境
  & 注意:这里使用真实机当客户端!!!
  & 客户端需要安装ceph-common软件包
  & 拷贝配置文件(否则不知道集群在哪)
  & 拷贝连接密钥(否则无连接权限)

[root@room11pc19 ~]# yum -y install ceph-common.x86_64
[root@room11pc19 ~]# scp 192.168.4.31:/etc/ceph/ceph.conf /etc/ceph/ceph.conf    
[root@room11pc19 ~]# scp 192.168.4.31:/etc/ceph/ceph.client.admin.keyring /etc/ceph

●创建初始化虚拟机(续1)
  & 在真机KVM上创建虚拟机后,不着急启动虚拟机(关闭虚拟机)
  cl1
●配置libvirt secret  #虚拟机连接ceph的软件,需要配置账户信息，密钥信息
 & 编写账户信息文件(真实机操作)
  [root@room11pc19 ~]# cat secret.xml
  <secret ephemeral='no' private='no'>
       <usage type='ceph'>
             <name>client.admin secret</name>
       </usage>
   </secret>
   
 & 使用XML配置文件创建secret 
  [root@room11pc19 ~]# virsh secret-define --file secret.xml
  生成 secret cdad8575-d203-42b3-ad25-5a40318cf1fb
  //随机的UUID,这个UUID对应的有账户信息
  //删除UUID： virsh secret-undefine <UUID>

 & 编写账户信息文件(真实机操作)
   [root@room11pc19 ~]# virsh secret-list
   cdad8575-d203-42b3-ad25-5a40318cf1fb
  [root@room11pc19 ~]# ceph auth get-key client.admin
  AQB9Rr9b2DDhHRAAmfq2CNr6hK93KClqaIWHsw== 
  
  [root@room11pc19 ~]# virsh secret-set-value \
  --secret cdad8575-d203-42b3-ad25-5a40318cf1fb \           
  --base64 AQB9Rr9b2DDhHRAAmfq2CNr6hK93KClqaIWHsw==
  //这里secret后面是之前创建的secret的UUID
  //base64后面是client.admin账户的密码
  //现在secret中既有账户信息又有密钥信息
  
●导出虚拟机的xml配置文件
  [root@room11pc19 ~]# virsh dumpxml cl1 > /tmp/cl1.xml
  [root@room11pc19 ~]# ls /tmp/cl1.xml
  /tmp/cl1.xml
 
●修改XML配置文件
  [root@room11pc19 ~]# virsh secret-list 
  UUID                                  用量
  --------------------------------------------------------------------------------
 cdad8575-d203-42b3-ad25-5a40318cf1fb  ceph client.admin secret
 
  [root@room11pc19 ~]# vim /tmp/cl1.xml
  2   <name>cl1</name>      #改名字
  3   <uuid>4fc91aa4-034d-42f2-8a3e-8ecc4ca9b074</uuid>  #可以删除
  原内容：
 32 <disk type='file' device='disk'>
 33   <driver name='qemu' type='qcow2'/>
 34   <source file='/var/lib/libvirt/images/cl1.qcow2'/>
 35   <target dev='vda' bus='virtio'/>
 36   <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0  x0'/>
 37   </disk>

  修改内容：
  <devices>
    <emulator>/usr/libexec/qemu-kvm</emulator>
    <disk type='network' device='disk'>   #file---->network
      <driver name='qemu' type='raw'/>    #qcow2---->raw
                                                      #删除<source
       <auth username='admin'>
         <secret type="ceph" uuid='cdad8575-d203-42b3-ad25-5a40318cf1fb'/>
       </auth>
       <source protocol='rbd' name='rbd/vm1-image'>
       <host name='192.168.4.31' port='6789'/>
       </source>
         
      <target dev='vda' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x07' function='0x0'/>
    </disk>

●使用修改好的XML配置文件定义虚拟机
  [root@room11pc19 ~]# virsh define /tmp/cl1.xml

●创建虚拟机，修改引导项
   1.选择IDE-CDROM，并移到最上面
   2.开机安装系统
   3.装完后关机
   4.重新选择虚拟磁盘作为引导首选

##################################################################################
分布式文件系统

●什么是CephFS
  & 分布式文件系统(Distributed File System)是指文
件系统管理的物理存储资源不一定直接连接在本地节
点上,而是通过计算机网络与节点相连
  & CephFS使用Ceph集群提供与POSIX兼容的文件系统
  & 允许Linux直接将Ceph存储mount到本地

●什么是元数据
  & 元数据(Metadata)
  –  任何文件系统中的数据分为数据和元数据。
  –  数据是指普通文件中的实际数据
  –  而元数据指用来描述一个文件的特征的系统数据
  –  比如:访问权限、文件拥有者以及文件数据块的分布信息(inode...)等
  & 所以CephFS必须有MDSs节点
  
●inode 
  &i节点
  &linux需要通过i节点，给每个文件目录定义一块空间，定义编号
  &查看i节点信息      
  [root@node1 ~]# df -i /
   文件系统                Inode 已用(I) 可用(I) 已用(I)% 挂载点
  /dev/mapper/rhel-root 8910848  155842 8755006       2% / 
  &查看元数据
  [root@node1 ~]# ll -i /etc/hosts
  19003568 -rw-r--r--. 1 root root 215 10月 11 20:33 /etc/hosts
##################################################################################
搭建CephFS
●环境准备
  &实验拓扑
  client  eth0-192.168.4.50   #NTP服务器
  node1   eth0-192.168.4.51   #Mon,OSD,装ceph-deploy
  node2   eth0-192.168.4.52   #Mon,OSD
  node3   eth0-192.168.4.53   #Mon,OSD
  node4   eth0-192.168.4.54   #MDS，即元数据服务器
 &部署node4
   •  准备一台新的虚拟机,作为元数据服务器（其他沿用之前的环境）
   •  要求如下:
   –  IP地址:192.168.4.54
    –  主机名:node4
    –  配置yum源(包括rhel、ceph的源)
    –  与Client主机同步时间
   –  node1允许无密码远程node4
    –  修改node1的/etc/hosts,并同步到所有node主机
    
●部署元数据服务器   
  +装包  node4 
   [root@node4 ~]# yum -y install ceph-mds #元数据包
  +部署节点操作  node1
   [root@node1 ~]# cd ceph-cluster/        #部署ceph集群时，创建的目录
   [root@node1 ceph-cluster]# ceph-deploy new node1 node2 node3 node4
   [root@node1 ceph-cluster]# ceph-deploy mds create node4  
    #以上，给nod4拷贝配置文件,启动mds服务
   [root@node1 ceph-cluster]# ceph-deploy admin node4

●部署文件系统服务器
 & 创建存储池
   //文件系统需要至少2个池
   //一个池用于存储数据
   //一个池用于存储元数据
     
  [root@node1 ceph-cluster]# ceph osd pool create cephfs_data 128
   pool 'cephfs_data' created
  [root@node1 ceph-cluster]# ceph osd pool create cephfs_metadata 128
   pool 'cephfs_metadata' created

 & 创建Ceph文件系统
   [root@node1 ~]# ceph mds stat  #查看元数据服务器状态
   e2:, 1 up:standby
   
   [root@node1 ~]# ceph fs new myfs1 cephfs_metadata cephfs_data
   new fs with metadata pool 2 and data pool 1
   #注意,现在medadata池,再写data池
   #默认,只能创建1个文件系统,多余的会报错
 
 & 查看ceph文件系统
   [root@node1 ~]# ceph mds stat
      e5: 1/1/1 up {0=node4=up:active}
   [root@node1 ~]# ceph fs ls
   name: myfs1, metadata pool: cephfs_metadata, data pools: [cephfs_data ]

●客户端挂载
   [root@client ~]# cat /etc/ceph/ceph.client.admin.keyring 
   [client.admin]
	key = AQB9Rr9b2DDhHRAAmfq2CNr6hK93KClqaIWHsw==  #密钥
	
   [root@client ~]#  mount -t ceph 192.168.4.31:6789:/ /cephfs1 \
   -o name=admin,secret=AQB9Rr9b2DDhHRAAmfq2CNr6hK93KClqaIWHsw==

##################################################################################
对象存储
●什么是对象存储
 & 对象存储
   –  也就是键值存储,通其接口指令,也就是简单的GET、
      PUT、DEL和其他扩展,向存储服务上传下载数据
   –  对象存储中所有数据都被认为是一个对象,所以,任
       何数据都可以存入对象存储服务器,如图片、视频、
       音频等
 & RGW全称是Rados Gateway
 & RGW是Ceph对象存储网关,用于向客户端应用呈现
    存储界面,提供RESTful API访问接口
 & RGW可以部署多台
##################################################################################
部署对象存储
●环境准备
 & 准备一台新的虚拟机,作为元数据服务器
 & 要求如下:
   –  IP地址:192.168.4.55
    –  主机名:node5
    –  配置yum源(包括rhel、ceph的源)
    –  与Client主机同步时间
   –  node1允许无密码远程node5
    –  修改node1的/etc/hosts,并同步到所有node主机
    
●部署RGW软件包  #node1
 & 用户需要通过RGW访问存储集群
   –  通过node1安装ceph-radosgw软件包
   [root@node1 ~]#  ceph-deploy install --rgw node5
 & 同步配置文件与密钥到node5
   [root@node1 ~]# cd ceph-cluster/
   [root@node1 ceph-cluster]# ceph-deploy admin node5
    
●新建网关实例  #node1
 & 启动一个rgw服务
   [root@node1 ~]# ceph-deploy rgw create noed5
 & 登陆node5验证服务是否启动
   [root@node5 ~]# netstat -untlp | grep radosgw
   tcp    0  0 0.0.0.0:7480     0.0.0.0:* LISTEN  7024/radosgw 

●配置文件修改服务端口   #node5
  [root@node5 ~]# vim /etc/ceph/ceph.conf
 <---------------------------------------------------------------------------
[client.rgw.node5]
host = node5
rgw_frontends = "civetweb port=80"  #默认7480修改为80端口
[global]
.. ..
--------------------------------------------------------------------------->

●起服务
  [root@node5 ~]# systemctl restart ceph-radosgw*
  [root@node5 ~]# netstat -untlp  | grep :80
  tcp 0 0 0.0.0.0:80  0.0.0.0:*    LISTEN      7922/radosgw 
  
●客户端访问页面 
  •  这里仅测试RGW是否正常工作
  –  上传、下载数据还需要调用API接口
  
  [root@client ~]# curl 192.168.4.55
<?xml version="1.0" encoding="UTF-8"?><ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Owner><ID>anonymous</ID><DisplayName></DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>[root@node5 ~]#
##################################################################################
使用第三方软件访问对象存储

●在 node5 创建用户，用于客户端登陆
  [root@node5 ~]# radosgw-admin user create \
  --uid="tu" --display-name="fb"

●显示用户登陆密钥信息  #node5
  [root@node5 ~]# radosgw-admin user info --uid=tu
    .. ..
    "keys": [     #访问密钥
        {
            "user": "tu",
            "access_key": "2KUJHN0462B1J3P2TD71",
            "secret_key": "ig5sBNECdgVAAouBcEC5pj32N8gLSUj8NMT5Dxh6"
        }
   .. ..
   ];
   
●客户端安装第三方包  
  [root@client ~]# yum -y install s3cmd-2.0.1-1.el7.noarch.rpm
●配置软件  #交互的
 [root@client ~]# s3cmd --configure	
 Access Key: 5E42OEGB1M95Y49IBG7B	
 Secret Key: i8YtM8cs7QDCK3rTRopb0TTPBFJVXdEryRbeLGK6	
 S3 Endpoint [s3.amazonaws.com]: 192.168.4.15:8081	
 [%(bucket)s.s3.amazonaws.com]:	%(bucket)s.192.168.4.15:8081	
 Use HTTPS protocol [Yes]: No	
 Test access with supplied credenOals? [Y/n] Y	
 Save se|ngs? [y/N] y	
 //注意,其他提示都默认回车

























