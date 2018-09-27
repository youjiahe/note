[] ##############################################
配置高级链接
IP作用：唯一标识网络中一台主机
IPv4地址：32个二进制组成，点分隔4部分，用4个十进制数表示
IPv6地址：128个二进制组成，冒号“：”分隔8部分，每部分16个二进制，最终用4个16进制数表示；有连续的0可以省略（ 64位网络位，64位主机位）

一张网卡既可以有IPv4，也可以有IPv6

ping6
配置IPv6[[root@server0 ~]# nmcli connection  modify  'System eth0'  ipv6.method  manual ipv6.addresses  '2003:ac18::305/64'  connection.autoconnect  yes]

 #############################################
配置聚合链接（网卡绑定 链路聚合 网卡组队）
作用
--解决单点故障(热备份模式，一主一备，自动切换）（高可用机制) 
把实际网卡组成一张虚拟网卡
有困难找man（以下创建虚拟网卡时需要做以下步骤
(1)man teamd  
(2)G->最后一行
（3）找到EXAMPLE 
（4）复制"runner": {"name": "activebackup"}]）

制作链路聚合
1.创建虚拟网卡team0
[[root@server0 ~]# nmcli connection add  type  team con-name team0 ifname team0 autoconnect yes config  '{"runner": {"name": "activebackup"}}' 
Connection 'team0' (99529ebc-7207-4474-a82d-525ed1953204) successfully added.]

2.添加成员 eht1 eth2
[[root@server0 ~]# nmcli connection  add type team-slave  con-name team0-1 ifname eth1 master team0 
Connection 'team0-1' (1220781c-3a38-42a9-a43d-97c2203208fc) successfully added.
[root@server0 ~]# nmcli connection  add type team-slave  con-name team0-2 ifname eth2 master team0 
Connection 'team0-2' (02378664-c046-46b0-8915-b9712dae22a1) successfully added.]

3.为team0配置IP
[[root@server0 ~]# nmcli connection modify 'team0' ipv4.method manual ipv4.addresses  '192.168.1.1/24' connection.autoconnect  yes]

4.激活所有配置
[[root@server0 ~]# nmcli connection  up 'team0'
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/4)
[root@server0 ~]# nmcli connection  up 'team0-1'
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/7)
[root@server0 ~]# nmcli connection  up 'team0-2'
Connection successfully activated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/8)
]
先激活team0 再team0-1 team0-2
补充：若上面有错误信息，激活不了，则可以删除[nmcli connection delete team0
nmcli connection delete team0-1
nmcli connection delete team0-2]

查看team0状态
teamdctl team0 state

 ##############################################
Shell脚本补充
题目

脚本echo输出作为错误信息    >$2
脚本运行后，返回值，命令echo $? 可测出非0值[#!/bin/bash
if [ $# -ne 0 ];then
if [ $1 == redhat ]; then
echo fedora
elif [ $1 == fedora ]; then
echo redhat
else
echo '/root/foo.sh redhat|fedora' >&2  #把输出作为错误信息
exit 9                                 #退出脚本状态返回值为9，
fi
else
echo '/root/foo.sh redhat|fedora' >&2
exit 10
fi
]   exit 9


