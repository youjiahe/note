 ##############################################
Engineerday1
分区规划
分区规划与使用
LVM逻辑卷

  #############################################
磁道相当于操场跑道
扇区，一个扇区默认大小512bit

 ##############################################
识别硬盘=>分区规划=>格式化=>挂载使用
 ##############################################
一、识别硬盘
-lsblk  #列出当前系统所有识别的硬盘
[root@server0 ~]# lsblk
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
vda    253:0    0  10G  0 disk 
└─vda1 253:1    0  10G  0 part /

二、分区规划（为什么要分区：安全，增强数据可靠性）
把系统与办公数据分开
    -MBR/msdos分区模式
-主分区 扩展分区 逻辑分区
-只有主分区和逻辑分区可以存储数据
    -1-4个主分区，或者0～3个主分区+1个扩展分区（n个逻辑分区）
    -最大支持容量为2.2TB的磁盘
-扩展分区不能格式化

：-扩展分区不能直接拿来存储数据，需要分成n个逻辑分区才可以使用
          -不允许没有主分区，操作系统只能安装在主分区

GPT 分区模式
- 最大支持容量为18EB空间
1EB=1000PB
1PB=1000TB 
1TB=1000GB
-支持划分128个主分区 

命令 fdisk
-查看分区表  fdisk -l /dev/vda
常用交互指令：
-p 查看现有分区表
-n 新建分区 
-d 删除分区
-q 不保存退出
-w 保存并退出

[root@server0 ~]# fdisk /dev/vdb
欢迎使用 fdisk (util-linux 2.23.2)。

更改将停留在内存中，直到您决定将更改写入磁盘。
使用写入命令前请三思。

Device does not contain a recognized partition table
使用磁盘标识符 0xb1ef62be 创建新的 DOS 磁盘标签。

命令(输入 m 获取帮助)：n
Partition type:
   p   primary (0 primary, 0 extended, 4 free)
   e   extended
Select (default p): p
分区号 (1-4，默认 1)：1
起始 扇区 (2048-20971519，默认为 2048)：
将使用默认值 2048
Last 扇区, +扇区 or +size{K,M,G} (2048-20971519，默认为 20971519)：+1G
分区 1 已设置为 Linux 类型，大小设为 1 GiB

命令(输入 m 获取帮助)：w
The partition table has been altered!

Calling ioctl() to re-read partition table.
正在同步磁盘。

#查看硬盘分区
[root@server0 ~]# lsblk
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
vda    253:0    0  10G  0 disk 
└─vda1 253:1    0  10G  0 part /
vdb    253:16   0  10G  0 disk 
└─vdb1 253:17   0   1G  0 part 







三、格式化
命令
-mkfs.ext4 /dev/vdb1    #格式化分区，并将文件系统设置为EXT4
          .xfs 
-blkid /dev/vb1           #查看UUID与文件系统

补充：重复格式化可以加-f，强制  mkfs.xfs -f  /dev/vdb1
四、mount使用
-mount /dev/vdb1  /mypart1    #临时挂载，重启无效 
-df -h  /mypart1                 #查看系统挂载设备

五、开机自动挂载配置文件   /etc/fstab（系统级配置文件）
/etc/fstab(file system table）
补充：vim技巧：按o，另起新一行进入输入模式
设备路径     挂载点    类型   参数      备分标记    检测顺序
/dev/vdb1  /mypart1  ext4  defaults   0(不备分)   0（不检测,除了根分区，其他都不检测)

[root@server0 ~]# blkid
/dev/vdb1: UUID="9d3b17e4-0cb1-4830-a819-957e7cd07aac" TYPE="ext4" 
/dev/vdb2: UUID="fb133f62-ebf7-46e7-9322-7a7026ad87dc" TYPE="xfs" 
/dev/vda1: UUID="9bf6b9f7-92ad-441b-848e-0257cbb883d1" TYPE="xfs" 

六、验证
-先卸载手动挂载的设备，
-mount -a   #把未挂载但/etc/fstab 配置文件写有的挂载,则为开及自动挂载
-df -h 查看

 ##############################################
总结：
1.列出识别硬盘  lsblk
2.划分新分区    fdisk  ‘fdisk p’ 查看分区规划
3.刷新分区标 partprobe
4.格式化        mkfs.ext4  mkfs.xfs    blkid（查看文件系统）
5.挂载使用      mount   df  -h （挂载查看）
6.开机自动挂载  /etc/fstab  

 ##############################################
综合分区：
1. 3个主分区，分别为1G 2G 2G 
2.划分扩展分区 占用所有剩余空间
3.再划分2个逻辑分区



 ##############################################
/dev/sda5含义
SCSI类型设备，第一块硬盘第5个分区；
SCSI类型设备，第一块硬盘，第一个逻辑分区
 ##############################################
综合分区
关闭虚拟机server0，添加一块硬盘80G
在server中查看新增硬盘 lsblk
[root@server0 ~]# lsblk
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
vda    253:0    0  10G  0 disk 
└─vda1 253:1    0  10G  0 part /
vdb    253:16   0  10G  0 disk 
├─vdb1 253:17   0   1G  0 part /mypart1
├─vdb2 253:18   0   2G  0 part /mypart2
├─vdb3 253:19   0   2G  0 part 
├─vdb4 253:20   0   1K  0 part 
├─vdb5 253:21   0   1G  0 part 
└─vdb6 253:22   0   1G  0 part 
vdc    253:32   0  80G  0 disk 

划分6个10G可以使用的分区  ls /dev/vdc[1-7]

 ##############################################
LVM逻辑卷管理
 
 逻辑卷作用：1.整合分散的空间 2.可以动态扩大空间

LVM逻辑卷创建（可以整合不同磁盘的分区）
零散空闲存储 ---->整合的虚拟磁盘 ---->虚拟的分区 ---->格式化 ---->挂载使用
（物理卷PV）---->（卷组VG）    ----> （逻辑卷LV）
                   卷组不可以直接用  
思路：将众多（或者一个）物理卷（PV），组成卷组（VG），再从卷组中划分出逻辑卷（LV）










 ##############################################


一、创建逻辑卷
1.创建卷组
 格式：vgcreate   卷组名  设备路径
-vgcreate sysytemvg /dev/vdc[1-2]  (连同物理卷一起创建）
-vgs   #显示卷组基本信息
-pvs   #显示物理卷基本信息

2.创建逻辑卷
-格式：lvcreate -n 逻辑卷名字 -L 大小 卷组名
[root@server0 ~]# lvcreate -n mylv -L 16G systemvg
-查看快捷方式
 ls  /dev/systemvg/mylv  
3.逻辑卷使用
-格式化
 mkfs.ext4  /dev/systemvg/mylv 
-写配置文件 
 vim /etc/fstab 
配置文件内容：/dev/systemvg/mylv /lv ext4 defaults 0 0
-设置开机自动挂载
mount -a 
-查看挂载 
 df -h(文件系统大小）

 ##############################################
二、扩展逻辑卷
1.卷组有足够剩余空间
（1）直接扩展逻辑卷
-格式：lvextend -L 扩展后空间大小 路径
-lvextend -L 18G /dev/systemvg/mylv
-lvs（查看逻辑卷空间大小)
-vgs（查看卷组空间大小)
（2）扩展逻辑卷的文件系统（刷新逻辑卷扩展后的文件系统）
-刷新ext4文件系统：resize2fs
-刷新xfs文件系统：xfs_growfs、
-查看文件系统大小：df -h

  
2.卷组无足够生于空间
（1）扩展卷组空间大小（从物理卷,主分区或者逻辑分区拿，只能整个物理卷拿）
-vgextend  systemvg /dev/vdc3
-vgs
（2）直接扩展逻辑卷空间
（3）最后刷新文件系统（扩展逻辑卷文件系统）

 ##############################################
逻辑卷可以做缩减（了解）
 EXT4文件系统支持缩减
 Xfs文件系统不支持缩减
 ##############################################
卷组划分空间的单位PE
默认1PE=4M
查看卷组PE大小 
vgdisplay systemvg

创建卷组的时候设置PE 大小
-vcreate -s PE大小 卷组名 空闲分区...
-vgchange -s PE 大小 卷组名 空闲分区...

[root@server0 ~]# vgchange -s 1M systemvg
  Volume group "systemvg" successfully changed
[root@server0 ~]# vgdisplay | grep 'PE Size' 
  PE Size               1.00 MiB

以PE数量创建逻辑卷
 -lvcreate -n 逻辑卷名 -l PE个数 卷组名 
[root@server0 ~]# lvcreate -n database -l 50 systemvg
  Logical volume "database" created
[root@server0 ~]# lvs | grep 'database'
  database systemvg -wi-a----- 50.00m   

 ##############################################
逻辑卷删除（工作中很少用)
先删除逻辑卷，再删除卷组，最后删除物理卷
删除前需要先进行卸载 umount



  #############################################
Vim 编辑器技巧

   – 命令模式下移动光标：键盘上下左右键、Home键、End键
    – 命令模式下行间跳转：到全文的第一行（1G或gg）、到全文的最后一行（G）、到全文的第10行（10G）
    
    – 命令模式下复制、粘贴：
    	 复制1行（yy）、复制3行（3yy）
    	 粘贴到当前行之后（小写p）

    – 命令模式下删除：
    	 删除单个字符（x）
    	 删除到行首（d^）、删除到行尾（d$）
    	 删除1行（dd）、删除3行（3dd）
         
    
    – 命令模式下查找关键词： 
    	 搜索（/word）切换结果（n、N）

    – 补充：在命令模式下大写的C，可以删除光标之后，并且进入输入模式
