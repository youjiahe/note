 ##############################################
Day6

 ##############################################
ISCSI（Internet SCSI）
环境前提：
防火墙和trusted
  #############################################
Iscsi网络磁盘实现
1.划分分区

2.装包
targetcli

3.运行命令targetcli进行配置（交互式的）
服务端server0：
(1)建立后端存储  #相当于建立真正共享的分区---纸包装
/> backstores/block create name=nsd dev=/dev/vdb1 ]

(2)建立target磁盘组  #客户端访问的目标--木箱（更安全）
/> iscsi/ create iqn.2018-07.example.com:server0]
   命名----IQN 名称规范   iqn.yyyy-mm.倒序域名:自定义标识

(3)关联-lun  #把纸包好的冰箱放到木箱子里
/> iscsi/iqn.2018-07.example.com:server0/tpg1/luns create /backstores/block/nsd 
   把后端存储关联到磁盘组

(4)设置访问控制acl  #设置客户端生声称的名字（匹配）--理解为送货单
/> iscsi/iqn.2018-07.example.com:server0/tpg1/acls create iqn.2018-07.example.com:desktop0（客户端声明与此一致就可以）]
   客户端在访问服务端共享存储时的声称的名字

(5)开放网络接口  #---理解为可以出货了
/> iscsi/iqn.2018-07.example.com:server0/tpg1/portals create 172.25.0.11
Using default IP port 3260
Created network portal 172.25.0.11:3260]
   Iscsi网络磁盘，默认端口3260

(6)起服务target


客户端desktop0：

(1)装包
yum -y install iscsi-initiator-utils.i686 

(2)配置//etc/iscsi/initiatorname.iscsi
指令客户端声称的名字[InitiatorName=iqn.2018-07.example.com:desktop0]

(3)起服务
该上述文件，必须重启以下服务
Systemctl restart iscsid //刷新IQN标识[有的时候需要reload
[root@desktop0 ~]# systemctl restart iscsid
Warning: Unit file of iscsid.service changed on disk, 'systemctl daemon-reload' recommended.
[root@desktop0 ~]# systemctl daemon-reload
[root@desktop0 ~]# systemctl restart iscsid
]

(4)发现服务端共享存储 man iscsiadm


快捷键：
字体变大：Ctrl Shift + 
字体变小：Ctrl -

(5)加载共享存储
Lsblk
Systemctl restart iscsi  #客户端服务



 ##############################################
数据库服务基础
什么是数据库:存放数据的仓库
MariaDB  SQL Server(微软）  Oracle(甲骨文)  MySQL(甲骨文)   DB2(IBM)

 ##############################################
数据库实现
服务端虚拟机server0
1.装包
mariadb-server   #提供服务端有关的程序，默认端口3306
mariadb          #提供客户端

2.起服务
mariadb          #



  
 ##############################################
数据库基本操作
1.mysql登录界面
-h  指定登录为值[
mysql -u root -h server0.example.com] 
2.所有命令都需要分号“；”结束。所有命令都不可以TAB
3.基本命令
（1）show databases；  #显示当前包含数据库
（2）create database；  #建库
（3）drop database[以下4个库不要删除
 information_schema |
| mysql              |
| performance_schema |
| test ]；    #删库

4.数据库管理员密码
 （1） 数据库管理员root：数据库MariaDB最高权限用户，mysql库中user表[记录所有数据库用户信息]
       系统管理员root：Linux系统最高权限用户，/etc/passwd
 （2）密码设置命令
[
[root@server0 ~]# mysqladmin -u root -p123 password '123456'   #设置密码
[root@server0 ~]# mysql -u root -p123
#非交互式登录] （3）数据库主配置文件 /etc/my.conf

5.导入数据
mysql -u root -p123 nsd  < 表格路径

6.进入库/切换库（不允许后退）
Use nsd；   #切换到 nsd库
show tables;   #显示该库所有表格[
>  Use nsd；   
> show tables;   ]

7.表格操作
增（insert）[
Insert base value=(‘6’,’Barbara’,’789’);] 
删（delete）[
>delete from user where password=’’;] 
改（update） 
查（select）不区分大小写[
按字段查询：
> select * from base;
> select user,password,host from user;
按条件查询：
> select * from base where name=’tom’;
> select name from base where password=’123’;
> select * from base where id='4';]

8.查看表格属性，如字段，格式，是否允许空
  Desc 表名;

题目：
---除了root，只允许lisi查询数据库，密码123
[> grant select  on nsd.* to lisi@localhost identified by '123']

联合查询[select count(*) from base,location where location.city='Sunnyvale' and base.name='Barbara' and base.id=location.id;]

9.刷新策略
Flush privileges;   
 
