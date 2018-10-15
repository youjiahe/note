CLOUD day1 云计算

1.KVM简介
  1.1 搭建KVM服务器
      1.1.1 虚拟化概念
      1.1.2 安装虚拟化服务器平台
      1.1.3 KVM虚拟机组成
  1.2 管理KVM平台
      1.2.1 virsh命令
      1.2.2 qcow2简介
      1.2.3 qumu-img 命令
2.Virsh管理
  2.1 自定义虚拟机
  2.2 虚拟机模版制作
3.虚拟设备管理
  3.1 xml详解
  3.2 设备管理
  3.3 创建访问虚拟机

李欣老师的资料
git clone git://124.193.128.166/nsd1805.git

##################################################################################
●基础知识
  1.yum源路径，指定到含有repodata目录的路径
  2.搭建NTP服务器
    2.1 服务端
    vim /etc/chrony.conf
    <-------------------------------------------------
    server ntp1.aliyun.com iburst
    bindacqaddress 0.0.0.0
    allow all
    cmdallow 127.0.0.1
    ------------------------------------------------->   
   2.2 客户端指定服务端server
   2.3客户端查看NTP服务器的连接状态
      chronyc source -v
##################################################################################
●虚拟化概念
  virtualization 资源管理
  将真机物理资源虚拟成假的，最后假的可以当真的来用
  一台物理机上可以运行多台虚拟机，每台虚拟机的系统不一样
●常用虚拟化产品 #最常用VMware、KVM
  VMware         VMware Workstation、vSphere 
  Microsoft      VirtualPC、Hyper-V
  Redhat         KVM、RHEV
  Citrix         Xen
  Oracle Oracle  VM VirtualBox
●vcenter
●esxi
################################################################################## 
安装虚拟化服务器平台
●KVM
 & KVM 是linux内核的模块,提供底层命令支持
    它需要CPU的支持,
    采用硬件辅助虚拟化技术Intel-VT,AMD-V,
    内存的相关如Intel的 EPT 和 AMD 的 RVI 技术
 & QEMU 是一个虚拟化的仿真工具,虚拟硬件；
    通过 ioctl与内核kvm 交互完成对硬件的虚拟化支持
 & Libvirt 是一个对虚拟化管理的接口和工具,提供用户端程序 
   virsh ,virt-install, virt-manager, virt-view 与用户交互
●查看模块
  [root@room11pc19 ~]# lsmod | grep -i kvm
  kvm_intel             183720  15 
  kvm                   578558  1 kvm_intel #kvm模块名称
  irqbypass              13503  41 kvm
  
●必备软件
  qemu-kvm        #为kvm 提供底层仿真支持
  libvirt-daemon  #libvirtd 守护进程，管理虚拟机；可以管理很多种虚拟机
  libvirt-client  #用户端软件，提供客户端管理命令
  libvirt-daemon-friver-qemu  #libvirtd连接qemu驱动，如果需要管理Xen就装Xen的驱动

●可选功能
 & virt-install  #系统安装工具
 & virt-manager  #图形管理工具
 & virt-v2v      #虚拟机迁移工具
 & virt-p2v      #物理机迁移工具
  
●虚拟化平台安装
  yum -y install qemu-kvm  libvirt-daemon libvirt-client libvirt-daemon-driver-qemu
  systemctl start libvirtd
  
●KVM虚拟机的组成
– 内核虚拟化模块(KVM)
– 系统设备仿真(QEMU)
– 虚拟机管理程序(LIBVIRT)

– 一个 XML 文件(虚拟机配置声明文件)
– 位置 /etc/libvirt/qemu/
– 一个磁盘镜像文件(虚拟机的硬盘)
– 位置 /var/lib/libvirt/images/
  
##################################################################################  
管理KVM平台
●virsh命令工具介绍
 & 提供管理各虚拟机的命令接口
 & 格式:virsh 控制命令 [虚拟机名称] [参数]

●查看虚拟化信息
 & 查看KVM节点(服务器)信息
   virsh nodeinfo
 & 列出虚拟机
   virsh list [--all] 
 & 列出虚拟网络 
   virsh net-list [--all]
 & 查看指定虚拟机的信息
   virsh dominfo 虚拟机名称

●开关机操作
 & 运行|重启|关机
   virsh start|reboot|shutdown 虚拟机名称
 & 强只关闭指定的虚拟机
   virsh destroy 虚拟机名称
 & 将指定的虚拟机设为开机自动运行
   virsh autostart [--disable] 虚拟机名称

●连接虚拟机
  virsh console 虚拟机名称  #ctrl + ]  退出
##################################################################################
常见的镜像盘类型
●虚拟机磁盘镜像文件格式
           RAW      QCOW2
  KVM默认     否           是 
  I/O效率     高          较高 
  占用空间     大          小
  压缩         不支持      支持
  后端盘复用  不支持      支持
  快照         不支持      支持
##################################################################################
cow技术
●Copy On Write,写时复制
 & 直接映射原始盘的数据内容
 & 当原始盘的旧数据有修改时,在修改之前自动将旧数据存入前端盘
 & 对前端盘的修改并回写到原始盘
 & 原始盘的数据只能读
 & 用到的数据才从原始盘
##################################################################################
qemu-img
●qemu-img 是虚拟机的磁盘管理命令
 & qemu-img 支持非常多的磁盘格式,例如 raw、qcow2、vdi、vmdk 等等
 & qemu-img 命令格式
  – qemu-img 命令 参数 块文件名称 大小
 & 常用的命令有
  – create 创建一个磁盘
  – convert 转换磁盘格式
  – info 查看磁盘信息
  – snapshot 管理磁盘快照

 & 创建新的镜像盘文件
  – qemu-img create -f 格式 磁盘路径 大小
  – qemu-img create -f qcow2 disk.img 50G
 & 查询镜像盘文件的信息
  – qemu-img info 磁盘路径
  – qemu-img info disk.img
 & -b 使用后端模板文件创建前端盘
  – qemu-img create -b disk.img -f qcow2 disk1.img
  – qemu-img create -b disk.img -f qcow2 disk2.img 12G

[root@room11pc19 qemu]# qemu-img info /var/lib/libvirt/images/rh7_node3.img
image: /var/lib/libvirt/images/rh7_node3.img
file format: qcow2
virtual size: 20G (21474836480 bytes)
disk size: 361M
cluster_size: 65536
backing file: /var/lib/libvirt/images/.rh7_template.img  #牛老师的镜像模版
Format specific information:
    compat: 1.1
    lazy refcounts: false

##################################################################################
连接本地/远程KVM
●使用 virsh 客户端工具
 & 连接本地
  – virsh
  – virsh# connect qemu:///system (默认选项)
 & 连接远程
  – virsh# connect
qemu+ssh://user@ip.xx.xx.xx:port/system

virsh -c qemu+ssh://192.168.4.51/system 
virsh -c qemu+ssh://176.121.211.201:792/system
##################################################################################
创建虚拟交换机
●libvirtd 网络接口
   – 原理:调用 dnsmasq 提供DNS、DHCP等功能
   – 创建配置文件 /etc/libvirt/qemu/networks/vbr.xml
<network>
  <name>vbr</name>
  <bridge name="vbr"/>
  <forward mode="nat"/>  
  <ip address="192.168.1.254" netmask="255.255.255.0">
      <dhcp>
          <range start="192.168.1.100" end="192.168.1.200"/>
      </dhcp>
  </ip>
</network>

##################################################################################
网络管理
●virsh 管理虚拟网络
  – net-list           #查看虚拟网络
  – net-define vbr.xml #创建虚拟网络
  – net-undefine vbr   #初除虚拟网络
  – net-start vbr      #启劢虚拟网络
  – net-destroy vbr    #停止虚拟网络
  – net-edit vbr       #修改 vbr 网络的配置
  – net-autostart vbr  #设置 vbr 虚拟网络开机自启劢
##################################################################################
xml管理
●导出虚拟机
 & xml 配置文件
   – 定义了一个虚拟机的名称、CPU、内存、虚拟磁盘、网卡等各种参数设置
   – 默认位于/etc/libvirt/qemu/虚拟机名.xml
 & 导出 xml 配置文件
    – 查看:virsh dumpxml 虚拟机名
    – 备份:virsh dumpxml 虚拟机名 > 虚拟机名.xml

●导入虚拟机
 & 根据修改后的独立 xml 文件定义新虚拟机
   – virsh define XML描述文件

●删除虚拟机  #不删除镜像
 & 必要时可去除多余的 xml 配置
    – 比如虚拟机改名的情冴
    – 避免出现多个虚拟机的磁盘戒 MAC 地址冲突
      – virsh undefine 虚拟机名
##################################################################################
自定义虚拟机
网络 yum 源的安装和配置        #系统镜像文件用Centos7-1708

●把刚刚安装好的系统刜始化
 & 1、禁用 Selinux /etc/selinux/config
     SELINUX=disabled
 & 2、卸载防火墙不 NetworkManager
     yum remove -y NetworkManager-* firewalld-* python-firewall
 & 3、配置 yum 源
[centos7]
name=centos7
baseurl="ftp://192.168.1.254/centos7"
enabled=1
gpgcheck=0
 & 4.配置eth0 IP文件  
  [root@cld1 network-scripts]# cat ifcfg-eth0
# Generated by dracut initrd
DEVICE=eth0
ONBOOT=yes
TYPE=Ethernet
NM_CONTROLLED="no"
BOOTPROTO=dhcp
#IPADDR="192.168.1.20"
#NETMASK="255.255.255.0"
#PREFIX=24
#GATEWAY="192.168.1.254"

  [root@cld1 network-scripts]# pwd
  /etc/sysconfig/network-scripts
  [root@cld1 network-scripts]# systemctl restart network

 & 5.安装软件
    yum install -y lftp
  – 5.1 yum 源导入公钥验证配置
    gpgcheck=1
  – 5.2 导入 gpg key
    rpm --import ftp://192.168.1.254/centos7/RPM-GPG-KEY-CentOS-7
  – 5.3 常用系统命令安装
    yum install -y net-tools vim-enhanced bridge-utils psmisc
##################################################################################




























