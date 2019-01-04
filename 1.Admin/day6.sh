 ############################################
Day6
默写题，解包：tar -xf /opt/file.tar.gz  -C /home  (漏了 -C）

 ###########################################
基本权限类别
  访问方式（权限）
  -读取   -read                     r
  -写入   -write                    w
  -可执行：允许运行和切换 -excute   x
 
对于文本文件：
   -r （读取)：cat  less head  tail grep
   -w(写入）：vim（保存并退出）
   -x（可执行）：shell脚本

补充Llinux里面文本文件没有可执行权限

权限适用对象
-所有者：拥有文件/目录用户  -u(属主)
-所属组：拥有文件的组      -g(属组)                
-其他用户：                -o    
Lisi lisi组  nsd.txt


查看权限
使用ls -l
-ls -ld 文件或目录

以-开头：文本文件
以d开头：目录
以l开头：快捷方式

-rw-r--r--. 1 root root 2180 3月  20 00:07 /etc/passwd
权限位 硬连接数 属主 属组 大小 最后修改时间 文件/目录名称 

-rw-r--r--. 每三个字母为1组，所有者，所有组，其他用户
 ##############################################





设置基本权限
Chmod  用户类型 +- 权限（rwx）   文件/目录
         用户类型=rwx   文件/目录
         Ugo=---   文件/目录
      
       [-R]个递归设置

绿底黑字（其他用户具有写权限文件/目录）
[root@server0 ~]# chmod go=r--,u=rw- /opt/nsd01
[root@server0 ~]# ls -ld /opt/nsd01/
drw-r--r--. 2 root root 6 7月   5 10:26 /opt/nsd01/
 ##############################################
如何判断用户具备的权限
 1.判断用户对于文档的角色   所有者>所属组>其他  匹配即停止
 2.查看相应角色具备权限
 ##############################################
Permission denied  权限被拒绝
目录的r权限：能够ls浏览目录
目录的w权限：能够执行rm/mv/mkdir/cp/touch
目录的x权限：能够cd切换到此目录

对于目录来说，  r  x需要成对存在

 #############################################
设置文档归属
- chown [R]  属主 文档
- chown [R]  属组 文档
- chown [R]  属主：属组 文档
 
 #############################################
附加权限（特殊权限）
 
 Set GID
-附加在属组的x位上
-属组的权限标识会变为s：原有x则为小写s，没有x则是大写S
-适用于目录，SetGID 可以是目录下新增的文档自动设置与父目录相同的属性
-继承父目录的所属组属性(父目录属组属性改后，不继承）

      -R:针对以建立的所有文档
      -SGID：未来所有新建的

 ##############################################
acl访问控制策略
-能够对个别用户，个别组量身定做权限

设置特殊权限
-setfacl  -m(定义) u(对用户):tc:rx /NB  可以写多个人
-setfacl  -m(定义) g(对组):tc:rx /NB  可以写多个组
-setfacl  -b文档... 清空文档全部acl
-setfacl  -x u:用户名  文件/目录     清除指定用户acl

看特殊权限设置
Getfacl  /NB

[root@server0 ~]# setfacl -m u:james:rx,u:lisi:rx  /Lakers/
 ############################################
使用LDAP认证
LDAP服务器：网络用户认证
实现用户可以集中在一台服务器创建，并且可以在整个架构中登录。
 轻量级目录访问协议

一．搭建LDAP服务器 classroom.example.com
二．搭建客户端虚拟机server0
1)安装软件sssd，与LDAP服务器沟通
2)安装图形软件配置sssd软件authconfig-gtk
3)运行2）的图形配置软件
    
   选择LDAP
    dc=example,dc=com  #指定服务端域名
证书加密（加密算法）   #指定服务端主机名

勾选TL加密
使用证书加密：http://classroom.example.com/pub/example-ca.crt
选择LDAP密码

4)重启服务
      Systemctl restart sssd
      Systemctl enable sssd

5)验证：

Classroom.example.com  主机名：classroom  域名是后面
域名：www.baidu.com  主机名是www  域名是baidu.com
