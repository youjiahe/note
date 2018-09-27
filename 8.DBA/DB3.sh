问题

##################################################################################
删除外键
alter table drop 字段 foreign key 外键名  #外键名需要show create table 查看
验证外键update功能
验证外键delete功能

##################################################################################
MySQL体系结构
●体系结构
mysql-connection pool  连接池    #数据库接收到连接请求,连接池回从内存中检查有没有空间，有的话就分配
SQL Interface          SQL接口  #把执行的SQL命令传递给mysqld服务处理
Parser                 分析器    #分析mysqld执行的命令是否有错误
Optimizer              优化器    #计算出最少资源运行mysql的命令
Caches & Buffer        查询缓存  #存储查找过的数据。查找到的数据，会先放到查询缓存；
                                        #客户端查找数据时，先从查询缓存中查找，没有再到库里面
                                        #从真机的物理内存划分出来的区域
Store Engines         存储引擎   #表的处理器
                                        #不同存储引擎，有不同功能，不同的方式存储数据
manager-tools         管理工具   #备份,恢复,安全,移植,集群等,这些工具一般和文件系统打交道；
                                        #不需要和mysql-server 打交道,它们对应的都是命令。
File-system           物理存储设备(文件系统)
################################################################################## 
存储引擎
●作为可插拔式的组件提供
   --表的处理器
   --不同存储引擎，有不同功能，不同的方式存储数据
●默认存储引擎
   --5.7       Innodb
   --5.0/5.1   MyISAM
●生产中常用存储引擎
  Innodb
  Myisam
●设置默认存储引擎
  systemctl stop mysqld
  vim /etc/my.cnf
  [mysql]
  default-storage-engine=myisam
  :wq
  systemctl restart mysqld
●查看所有存储引擎
mysql> show engines\G;
*************************** 1. row ***************************
      Engine: InnoDB            
     Support: DEFAULT                 #默认存储引擎
     Comment: Supports transactions   #功能描述
              row-level locking, and foreign keys 
Transactions: YES                     #是否支持事务
          XA: YES                       
  Savepoints: YES
*************************** 2. row ***************************
      Engine: MRG_MYISAM
     Support: YES
     Comment: Collection of identical MyISAM tables
Transactions: NO
          XA: NO
  Savepoints: NO
*************************** 3. row ***************************
##################################################################################
Innodb
●功能描述(comment)
Supports transactions, row-level locking, and foreign keys
#支持事务，事务回滚，行级锁，外键
●文件格式
  表名.frm    #存储表结构<---------desc 表名;
  表名.ibd    #存储索引信息，表数据
ibd：共享表空间
●执行写操作多的表，适合使用innodb存储引擎，并发量大
##################################################################################
Myisam
●功能描述(comment)
 Collection of identical MyISAM tables
 支持表级锁   
 不支持事务、事务回滚、外键
●文件格式
  表名.frm    #存储表结构<---------desc 表名;
  表名.MYI    #存储索引信息的文件<----------show index 索引名 from 表名 
  表名.MYD    #存储数据的文件<------------select *from 表名
MYI，MYD:独享表空间，每一种类型数据都用独立的文件存储
●执行select操作多的表，适合使用myisam存储引擎，节省系统资源
##################################################################################
Memory(用得很少)
●功能描述(comment)
●特点
 索引信息，表数据存放在内存
●文件格式
  表名.frm

##################################################################################
事务 #只有Innodb支持
●事务
  一次SQL操作从开始建立连接 执行各种SQL命令 到 断开连接的过程。
●事务回滚
  事务执行时，任意一步操作没有成功会恢复之前的所有操作。  #有事务日志记录
  rollback;  #需要关闭autocommit
●事务日志
  存储引擎为Innodb时，才会记录到日志
●事务特性(ACID)
  --Atomic 原子性
     事务的整个操作是一个整体，不可分割每要么全部成功，要么全部失败；
  --Consistency 一致性
     事务操作的前后，表中的记录无变化  #
  --Isolation 隔离性
     不同用户的事务相互不影响
  --Durability  持久性
    数据一旦提交，就不能改变   #所有的操作都需要
●关闭自动提交功能     #关闭autocommit,后需要手动执行commit才会提交修改
  mysql> show variables like "%commit%";
  set autocommit=off;
●验证事务特性
●事务回滚
  
##################################################################################
锁粒度
●行级锁  #只有Innodb支持
  自动锁上锁上被访问的行。确保一行只被一个请求访问。不影响其他行
●表级锁  
  对整个表进行加锁
●页级锁
  内存存储单位，1页=1M
  对内存数据进行加锁

锁类型
●读锁（共享锁）
  客户端进行读操作时，mysqld会对相应行/表进行读锁；
  可以并发读
  不可以进行写操作
●写锁（排他锁、互斥锁）
  客户端进行写操作时，mysqld会对相应行/表进行读锁；
  不允许其他线程进行任何操作；
●查看锁状态
  show status;
  show status like "%lock%";   #Table_locks_waited   | 0  
##################################################################################
数据管理
●查看数据导入导出文件存储路径
  show variables like "secure_file_priv";
●修改数据导入导出文件路径
  mkdir /mydata
  chown mysql /mysdata
  vim /etc/my.cnf
  [mysql]
   secure_file_priv=/mydata 
##################################################################################
数据导入：把系统文件内容存储到数据库服务器的表里     库.表<----------------------系统文件
●注意事项：
  字段分隔符要与文件内的一致
  指定导入文件的绝对路径
  导入数据的表字段类型要与文件字段匹配
  禁用 SElinux

补充：
●在mysql>里面加“system”,就可以执行 系统命令
  mysql> system cp /etc/passwd /var/lib/mysql-files/

●案例：
  把/etc/passwd导入数据库
  mysql> system cp /etc/passwd /var/lib/mysql-files/
  load  data  infile   "/var/lib/mysql-files/passwd"   
  into  table    db3.usertab   
  fields  terminated by ":"   
  lines  terminated  by   "\n";
##################################################################################
数据管理
数据导出
●案例：
  mysql> select * from user into outfile "/var/lib/mysql-files/user1.txt";

##################################################################################
数据管理
  -增删改查
●insert
 +格式1：添加1条记录，给所有字段赋值
   insert into 表名 values(字段值列表);
 +格式2：
   insert into 表名 values
    (字段值列表1)，
    (字段值列表2)，
    (字段值列表3)；
  +格式3：
   insert into 表名(字段名1,字段名2,字段名3) values(字段值1,字段值2,字段值3)；
  +注意事项
    &字段类型需匹配
    &字符加引号 
    &依次赋值，省字段名
    &部分赋值，须字段名   
●update
 +格式1，更新指定字段所有数据
   update 表名 set 字段=字段值;
 +格式2，更新符合条件的数据
   update 表名 set 字段=字段值 where 条件;
 例子：
   update user set uid=1004 where uid>10000;
●delete
  +格式1：
  delete from 表名 where 条件；
##################################################################################
查询表记录-----------------工作当中做得最多就是查、统计
##################################################################################
基本匹配
●数值匹配
     =  !=  >=  <=  > <
  +例子
  select user,uid,home,shell from user where id<=7;
●字符匹配
     =  != 
   +例子
  select user,uid,home,shell from user where shell!="/sbin/nologin";
●空，非空匹配
    is null ;is not null
    +例子
  select * from user where uid is  null;
●逻辑与，逻辑或匹配
   and  or  not  （）
    +例子

    select user,uid from user where user="apache" or uid=10 or shell like "%bas_%";
●范围匹配
      between 值1  and 值2
      in (值列表)
      not in (值列表)
    +例子
   select user,uid from user where uid in (12,13,10,20,40);
   select user,uid from user where uid between 50 and 80;
●去重显示   #逐行比对
      distinct
    +例子
    select distinct shell from user;
     +----------------+
    | shell          |
     +----------------+
    | /bin/bash      |
    | /sbin/nologin  |
    | /bin/sync      |
    | /sbin/shutdown |
    | /sbin/halt     |
    | /bin/false     |
    | NULL           |
     +----------------+
##################################################################################
高级匹配  
●模糊匹配
  格式：where 字段名 like "通配符"
   _   #单个字符  
   %   #任意个字符   
   +例子:
   select user from user where user like "___";    #三个字符的名字
   select user from user where user like "%____%";  #至少3个字符以上
   select user from user where user like "%h%";     #含有h的名字
●正则匹配
  格式：where 字段名 regexp '正则表达式'
  +例子：
  select user,uid from user where uid regexp "^[0-9]{2}$";  #只包含两个数字的uid
  select user,uid from user where uid regexp "^....$";      #只包含4个字符
●四则运算
  + - * / %
  
  +例子：
  select user,uid from user where uid % 2 = 0;   #uid为偶数的行，过滤出来
  select uid,gid,2018-age syead from user;       #
  select user,uid,gid,(uid+gid)/2 pjz from user where user="root"  #求出root的uid，gid平均数
  update user set age=age+1;  #给全部人的年龄都加1岁
################################################################################## 
操纵查询结果
●聚集函数
  avg()   #平均数
  sum()   #求和
  max()   #最大值
  min()   #最小值
  count() #统计某个字段有多少个值
  +例子:
  select count(user) from user where shell="/bin/bash";
●排序
  order by 字段名 asc|desc    #asc是升序，desc是降序
  +例子：
  select user,age from user order by age asc;    
  select user,age from user where age between 15 and 28 order by age desc;
●给字段分组     #与去重显示为同样功能
   group by   #处理过程与distinct不一样；先把内容放在缓存，在对数据作分组；
   +例子：
   select shell from user group by shell;    #相同内容作为一组
  +----------------+
  | shell          |
  +----------------+
  | /bin/bash      |
  | /bin/false     |
  | /bin/sync      |
  | /sbin/halt     |
  | /sbin/nologin  |
  | /sbin/shutdown |
  +----------------+
   select shell from user where uid>500 and uid<1000 group by shell;
●过滤查询结果
  having   #在查询结果里面过滤，where是在表里面逐行过滤
  +例子：
  select user,age from user having user regexp "^r";   #先把查询结果放在缓存，having再去过滤 
  select user,age from user having user regexp "^r.{2,3}$";
  select user,age from user having user="nfsnobody";
●限制打印行数
  limit N      #显示前N行
  limit N,M    #显示从N行起始的M行；行号起始0； 
   +例子：
   select * from user limit 1;
   select * from user limit 0,8;  #从0行开始，显示8行；




















