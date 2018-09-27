问题
事务特性，能不能在明确地给一些例子在笔记上？
##################################################################################
多表查询
  #在每个表里面设置统一个标识
●复制表
  +作用：快速创建相同格式的表、备份表
  +格式： create table 表名 查询sql
  +例子：
  create table user2 select * from user;             #复制表user
  create table user3 select * from user order by uid asc limit 10; #取前10行
  create tables user4 select * from user where 1=2;  #复制user的表结构到表user4中，条件用不成立的
  select * from user4;
  desc user4;  #执行完上上句命令后，查看
●多表连接查询
   +作用：
     &将2个或以上的表，按条件连接起来从中选取需要的数据
     &多个表中，存在相同意义的字段(字段名可不同)，可以通过该字段连接多个表
   +例子：
     &案例1：  #不加查询条件
     *创建第一个表：
    create  table tt1 select user,uid,shell 
    from user order by uid limit 3;
     *创建第二个表：
    create  table tt2 select user,gid,home 
    from user order by uid limit 10;
     *不加条件查询
    select * from tt1,tt2;   
    #不加条件查询，会出现30行（3*10）；称为笛卡尔集；tt1表每行都与tt2中匹配
     
     *按条件查询 
    select tt1.user,tt1.uid,tt2.gid,tt2.home 
    from tt1,tt2 
    where tt1.user=tt2.user; #生产环境中查询都会加上条件
    
    select * from tt1,tt2,user 
    where 
    tt1.user="root" and 
    user.user="root" and 
    tt2.user="root";         #从三个表中查询数据
●嵌套查询     
  +格式
   select 字段名列表 from 表名 条件(SQL查询)
  +例子：
  select user,home from user where user in 
  (select user from tt2 where home like "/var%");
                                     
  select user,uid,avg(uid) as av from user 
  where uid>(select avg(uid) from user);                                 


●左右连接查询                                     
  +作用
    适合比较两张表的差异，且表结构相同的表；
  +类别
    &左连接查询：条件成立时，以左表作为主显示查询结果  
    &右连接查询：条件成立时，以右表作为主显示查询结果  
  +格式：
    select 字段 from 表1 left  join 表2 on 条件;
    select 字段 from 表1 right join 表2 on 条件;
  +例子:
    select * from tt4 left  join tt3 on tt4.user=tt3.user;                                  
    
    select tt4.* from tt4 right join tt3 on tt4.user=tt3.user;               
                                            #右连接，显示满足条件的tt3表内容
##################################################################################                                                       
MySQL管理工具                                
●常见的mysql管理工具
  +mysql            命令行   跨平台
  +Mysql-workbench  图形     跨平台
  +Mysql-front      图形     windows    开源
  +phpMyAdmin       浏览器   LNMP/LAMP                        
●搭建phpMyAdmin                                     
 步骤1：搭建LAMP
      yum -y install httpd php php-mysql
      systemctl restart httpd
 步骤2：解包                         
      tar -xf phpMyAdmin-2.11.11-all-languages.tar.gz -C /var/www/html/                          
 步骤3：配置php
    cd /var/www/html/ 
    mv phpMyAdmin-2.11.11-all-languages/ phpMyAdmin 
    cp config.sample.inc.php config.inc.php
    vim config.inc.php
     ----------------------------------------------------------------------------------
    <?php
    17 $cfg['blowfish_secret'] = '123456';   #填充单引号，内容随便,加密                           
    31 $cfg['Servers'][$i]['host'] = 'localhost';  #数据库服务器IP地址  
     ?>                            
     ----------------------------------------------------------------------------------                                
●phpMyAdmin使用
  浏览器登陆操作,图形操作
  192.168.4.50/phpMyAdmin
##################################################################################                                   
密码恢复与修改
●root密码恢复
  +步骤1：停服务
         systemctl stop mysqld
  +步骤2：修改配置文件
         vim /etc/my.cnf
            --------------------------------------------
         [mysqld]
         skip-grant-tables  #跳过授权表加载
            -----------------------------------------
  +步骤3：起服务；
           执行mysql命令(无需用户密码)，进入数据库；
  +步骤4：修改mysql.user表下的授权信息
       &查看：select host,user,authentication_string from user;                                        
       &修改：update mysql.user set authentication_string=password("000000")
           where user="root" and host="localhost";
       &刷新：flush privileges;                         
●root密码修改
  ]# mysqladmin -uroot -p就密码 password '新密码'                                     
##################################################################################                                     
用户授权管理
●说明
  在数据库服务器添加新的用户，并设置访问权限客户端地址及连接密码，
  默认只允许数据库管理员root用户在本机登陆
●基本用法
  grant 权限列表 on 库名.表名  
  to 用户名@'客户端地址'
  identified by '密码'；
  [with grant option]   #是否具有授权权限
                               #前提是对mysql库下的所有表有insert权限                                    
●权限列表
  all:匹配所有权限                       #没有库也可以授权，因为有创建库权限
  select,update......
  select,update(字段1,.. ..,字段N)   #指定某些字段可改
●客户端地址
  %                  #匹配所有主机
  192.168.4.%       #匹配一个网段
  192.168.4.1       #匹配一台主机
  %.tedu.cn     #匹配一个域名
  svr1.tedu.cn  #                
●补充
  select user();     #查看当前登陆用户
  select @@hostname; #查看当前数据库服务器主机名
  show grants;       #查看当前登陆用户权限
  show grants for mydba@"%";                                             do                               
●例子 
   +1.新建用户mydba,所有库，所有权限；任何地址，密码‘s1cr2t!’;允许该用户为其他用户授权                                    
     grant all on *.* to mydba@'%' 
     identified by 's1cr2t!' 
     with grant option;                                     
   +2.新建用户admin,pratice库，在192.168.4.52；insert，select权限；
     grant select,insert on pratice.* to 
     admin@'192.168.4.52' 
     identified by '000000';
##################################################################################                                       
用户权限撤销
●基本用法
  revoke 权限列表 on 库名.表名 from 用户名@'客户机地址'                                     
●注意事项
   &撤销的用户权限，需要执行过grant授权；
  &mysql.user表里面有记录的，才能进行撤销；                                     
●例子;
   &查看服务器有哪些授权用户
    select user,host from mysql.user;
   &查看授权用户权限信息                                       
    show grants for mydba@'%'; 
    +---------------------------------------------------------------------+
    | Grants for root@localhost                                           |
    +---------------------------------------------------------------------+
    | GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION |
    | GRANT PROXY ON ''@'' TO 'root'@'localhost' WITH GRANT OPTION        |
    +---------------------------------------------------------------------+
                                   do                                     
   &撤销权限                                   
     revoke grant option on *.* from mydba@'%';   #撤销授权权限
     revoke all on *.* from mydba@'%';            #撤销所有权限
   &删除用户
     drop user mydba@'%';                             
##################################################################################
扩展知识
●报错：no such grant                                     
revoke all on db3.* from mydba@'%';        #会报错 no such grant,因为原始授权是*.*
revoke delete,drop on *.* from mydba@'%';  #正常执行                                    
revoke all on *.* from mydba@'%';          #撤销当前所有剩余权限                   

●授权注意事项
1.有with grant option权限的，需要对mysql下的所有表有插入权限
2.要在权限范围内授权

●修改授权库表，撤销用户权限
mysql> update db set Update_priv="N" 
       where user="admin" and db="pratice";  #更改admin对pratice库的权限
mysql> flush privileges;                     #改表后需要刷新特权；

+mysql库下的常用表查询
 db             #用户，库信息
 user           #用户密码信息
 tables_priv    #表权限列表
 columns_priv   #字段权限列表
 
+++++++++++++++++++++++++++++++++++++++++++++++++++
&库权限列表 mysql.db
mysql> select host,db,user from db;
+--------------+---------+-----------+
| host         | db      | user      |
+--------------+---------+-----------+
| %            | bbs     | kobe      |
| 192.168.4.52 | pratice | admin     |
| localhost    | sys     | mysql.sys |
+--------------+---------+-----------+

mysql> select * from db where user="kobe"\G;  
*************************** 1. row *****************
                 Host: %
                   Db: bbs
                 User: kobe
          Select_priv: Y
+++++++++++++++++++++++++++++++++++++++++++++++++++
&表权限列表  mysql.tables_priv
  mysql> select * from mysql.tables_priv where user="mydb"\G;
  *************************** 1. row ***************
        Host: %
         Db: bbs
       User: mydb
  Table_name: user
    Grantor: root@localhost
  Timestamp: 0000-00-00 00:00:00
  Table_priv: Select,Insert
  Column_priv: Update
  1 row in set (0.00 sec)
+++++++++++++++++++++++++++++++++++++++++++++++++++
&表字段权限列表  mysql.columns_priv
  mysql> grant insert,select,update(user,home) on 
       bbs.user to mydb@'%' identified by '123456';
  mysql> select * from mysql.columns_priv where user="mydb"\G;
  *************************** 1. row ***************************
       Host: %
         Db: bbs
       User: mydb
  Table_name: user
  Column_name: user
  Timestamp: 0000-00-00 00:00:00
  Column_priv: Update
  *************************** 2. row ***************************
       Host: %
         Db: bbs
       User: mydb
  Table_name: user
  Column_name: home
  Timestamp: 0000-00-00 00:00:00
  Column_priv: Update
  2 rows in set (0.00 sec)
+++++++++++++++++++++++++++++++++++++++++++++++++++  
&用户信息 mysql.user                  
 select host,user from user;                     
                     

                      
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     
                                     、
















