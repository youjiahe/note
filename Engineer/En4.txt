 ##############################################
Eday3回顾
补充：
用户分离未来会学
Tengine，由淘宝发起的Web服务器项目。再Nginx的基础上，针对大访问量开发
通信是双向的，desktop发出去的信息，如ping，如果server有回应，desktop默认接受，不会被防火墙拦截（动态匹配）
server单独屏蔽desktop的ping请求，可以在block上加上desktop的IP地址
firewall-cmd --zone=block --add-source=172.25.0.10
-----同一个源IP，不能添加到不同的安全区域

 ##############################################
Samba服务基础
跨平台共享，实现Linux与Windows数据共享
--用途：位客户及提供共享使用的文件夹
--协议（了解）：SMB（TCP 139）、CIFS（TC P445）  [没听清楚，记得看视频
CIFS是Samba传输数据用的协议]
--共享名，如果与源文件夹名不一样，则可以更安全

Windows 隐藏共享：在共享文件名后加$，如admin$

●环境前提准备：
虚拟机Server0
防火墙预设安全区域改为trusted[[root@server0 ~]# firewall-cmd --set-default-zone=trusted
success
[root@server0 ~]# firewall-cmd --get-default-zone 
Trusted
]
●Samba用户——专用来访问共享文件
--采用独立设置的密码
--需要建立同名的系统用户（可以没密码）
---与系统用户是同一个用户，但是不同密码[避免系统用户密码泄露

 #############################################
实现Samba只读共享
●服务端
虚拟机Server0
1.装包
服务：samba
2.创建Samba共享验证用户
    新建Samba用户
--useradd -s /sbin/nologin harry[该操作可以让用户harry不能登录本地操作系统，只能查看共享文件]
--pdbedit[设置Samba用户密码，并把harry添加到Samba共享帐号] -a harry
--pdbedit -L [列出所有Samba共享帐号] 
--pdbedit -x harry[从Samba共享帐号中删除harry]

3.编写配置文件，路径：/etc/samba/smb.conf
 vim /etc/samba/smb.conf[命令模式 G到最后一行，o下一行插入内容
[laji]
path = /laji ]
 [自定共享名][1.不能有空格，给客户端看的，可以根下面路径不一样
2.不要有特殊符号]
path = 共享文件夹路径[必须掌握]
;public = no|yes       默认no
;browseable = yes|no  默认yes

;read only = yes|no    默认yes
;writable = no|yes     默认no
;printable = 
                                  
4.启服务
systemctl restart smb
systemctl enable smb

5.布尔值（功能开关）
-P可以把设置变为永久[设置-P ，比较占用内存资源]
getsebool -a | grep samba[执行部分结果
samba_export_all_ro --> off
samba_export_all_rw --> off]    #获取SElinux限制的服务
setsebool samba_export_all_ro on  #向samba服务提供只读权限，临时的
●客户端
虚拟机desktop0
1.装包
samba-client(只用1次）
yum -y install samba-client
2.访问服务端
（1）列出共享资源
 -----smbcllient -L 172.25.0.11[列出Samba共享文件夹]
（2）用户harry登录共享文件夹
 -----smbclient -U 用户名 //服务器地址/共享名[代码
[root@desktop0 ~]# smbclient -U harry //172.25.0.11/laji
Enter harry's password: 
Domain=[MYGROUP] OS=[Unix] Server=[Samba 4.1.1]
smb: \>    #访问成功]
（3）如果没查看到共享文件夹，可以看服务systemctl status，或者查看服务端配置文件/etc/samba/smb.conf
  ##############################################
●客户端访问服务端资源影响因素：
1.防火墙策略
2.SElinux策略[
SElinux对跨平台共享软件，制约度都比较高]
  在服务端用操作：setsebool samba_export_all_ro on[这就可以在不关闭SElinux情况下，允许客户机访问Samba共享文件]
3.服务本身的访问控制
4.服务端本地目录权限
 ##############################################
更加科学方便的客户端访问
客户端desktop
mount
1.创建挂载点
mkdir -p  /mnt/nsd

2.安装软件包cifs-utils  识别samba共享的数据
3.挂载
mount -o user=harry,pass=123  //172.25.0.11  /mnt/nsd
4.开机自动挂载[谈到挂载都是客户端访问用]
_netdev:：声明网络设备[在开机启动时，需要将网络服务部署完成，自己具备IP地址后进行挂载]
vim  /etc/fstab
//172.25.0.11/common /mnt/nsd cifs[Samba独有的文件类型] defaults,user=harry,pass123,_netdev 0 0

umount /mnt/nsd
mount -a 

 ##############################################
创建读写[写权限，在互联网中比较敏感]Samba共享(了解)
Server0虚拟机
1.服务端创建Samba共享文件夹
2.写配置文件
[devops]
path = /devops
write list = chihiro    #允许chihiro进行写入  、
3.在SElinux中打开samba读写权限
setselinux samba_export_all_rw on[该开关打开 后，
samba_export_all_ro，也会被打开]
4.给chihiro设置acl权限

Desktop0虚拟机
1.挂载访问就行
 ##############################################
multiuser机制（了解）
-管理员只需要做一次挂载
-客户端在访问挂载点时，若需要不同权限，可以临时切换为新的共享用户（无需再次挂载）

  #############################################
配置NFS共享
网络文件系统（与SELinux兼容）
--为客户机提供共享使用的文件夹
--协议:NFS（TCP/UDP 2049）、RPC（TCP/UDP 111）

服务端：虚拟机server0
1.装包：nfs-utils(默认已装）
服务名：nfs-server

2.创建共享目录

3.修改NFS配置文件(考点）
/etc/exports

客户端：虚拟机desktop
1.写配置文件
172.25.0.11:/nsdd  /nsdd  nfs  defaults,_netdev 0 0





