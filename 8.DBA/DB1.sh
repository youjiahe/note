##################################################################################
●大纲
●DBA1 基础
d1 搭建数据库服务器     数据类型
d2 mysql键值,约束条件  存储引擎 
d3 数据管理  (增删改查 匹配条件)
d4 用户管理  (grant revoke)
    多表查询 连接查询 嵌套查询
d5 数据备份与恢复  (myqsldump binlog innobackupex)

●DBA2 进阶
d1 mysql主从同步
d2 数据读写分离     maxscale+MySQL  一主一从
    多实例           mysql
    数据库调优
d3 mysql集群       MHA+MySQL       一主多从
d4 视图与存储过程  
d5 数据分片         mycat(schema.xml)

●NoSQL
redis服务使用  3days
MongoDB服务    2days
##################################################################################
●当日大纲
●数据库介绍？           
  存储数据的仓库，按照规定的格式把数据存储在物理介质上

+关系型数据库    //RDBMS MySQL
                   //存储数据时必须按照事先设置好的结构存储数据
                   //已经存储只见可以关联操作
                   //比如：用户注册信息
+非关系型数据库  //NoSQL Redis Mongodb
                   //数据存储时不需要事先创建存储结构，使用key和values键值正确的方式存储数据，已经存储之间不可以做关联操作

●常见数据库服务器        
  主流数据库服务软件有:
  甲骨文        Oracle
  IBM        DB2
  微软          SQL Server
  美国Sybase  Sybase
    
  主流数据库相关信息：
  MySQL、PostgreSQL:开源且跨平台
  Oracle、DB2:跨平台不开源
  SQL Server:不跨平台不开源
  Sybase:跨平台不开源

●数据库服务的基本使用
  +把数据存储到数据库的步骤
    &连接数据库服务器      #方式：命令行、程序连接、图形工具
    &建库                   #增删改查，切换，
    &建表                   #增删查，插入，查看表结构，查看表记录
      *表必须存放在库里
    &插入记录

●MySQL数据类型
##################################################################################
●搭建数据库服务器
●主要特点
   -适用于中小规模、关系型数据库
   -用C，C++编写的软件，可移植性强
   -通过API可支持Python/PHP/Java  #如php-mysql，就是API
   -跨平台,开源
●应用环境
  -LNMP平台，与Nginx组合
  -LAMP平台，与Apache组合

●MySQL搭建
与右边软件包有版本冲突  #mariadb-server.x86_64

+步骤1：装包
     &解压：mysql-5.7.17 
    --mysql-community-server #提供MySQL服务
    --mysql-community-client #提供命令的包

     &安装依赖包：yum -y install perl-JSON
     &升级安装：rpm -Uvh mysql-community-*.rpm  #避免版本冲突

+步骤2：起服务
   systemctl start mysqld
   ps -C mysqld            #-C，查看PID，进程名
   ls /var/lib/mysql       

    &基础信息
    根目录：  /var/lib/mysql
    主配置文件： /etc/my.cnf
    端口：3306
    进程名：mysqld
    进程所有者：mysql
    进程所属组：mysql
##################################################################################
●数据库服务的基本使用
mysql> 
+管理员root
+初始密码是随机的 
 grep password /var/log/mysqld.log  #找到“root@localhost”对应密码
+初始密码登陆不允许操作

●库.表
+查库
  mysql> show databases;
  +--------------------+
  | Database           |
  +--------------------+
  | information_schema |    #内存映射数据
  | mysql              |  
  | performance_schema |    #存放数据库配置信息
  | sys                |
  +--------------------+
+建库
  &规则：字母，数字，下划线；不能全数字；不能有关键字；
  &查看当前位置：select database()

+建表
语法格式：
create table 库名.表名{
name 字段类型(宽度) 约束条件,   #宽度，约束条件可以不指定
age  字段类型(宽度) 约束条件,
sex  字段类型(宽度) 约诉条件,
}

+查表
select name,age from t1;
+增加表内容
  \c 取消当前行命令
  insert into t1 values("t",19,"m"),("b",21,"g");
+改表
  update 
+删表
  drop table game;
+删库
  drop database t1;

##################################################################################
mysql> 管理环境
--SQL指令
--结构查询语言

●常用的SQL操作指令
  --DDL 定义
  --DML 操作
  --DCL 控制
  --DTL 事物
●字符集
  包含所有汉字的集合              #UTF8，包含所有的汉字，用得比较多
  默认字符集：CHARSET=latin1  #不包含汉字
  default charset="UTF8";
●查看建表过程的命令
  show create table t2;
●建表时指定utf8，可以支持中文
  create table 学生表(
   姓名 char(15),
   班级 char(7),
   地址 char(50))default charset=utf8;
##################################################################################
数据类型
●常见类型
  数值型:体重，身高
  字符型:姓名、地址
  枚举型:兴趣爱好
  日期时间型:出生日志、注册时间
##################################################################################
●数值类型
+数值类型
  TINYINT   8位整数     -128～127  0-255    微小整数     
  SMALLINT  16位整数    -32768～32767      小整数       
  MEDIUMINT 24位整数                        中整数
  INT       32位整数                        大整数       
  BIGINT    64位整数                        极大整数
  FLOAT     32位                            单精度浮点数 
  DOUBLE    64位                            双精度浮点数
+字段类型定义整数   #四舍五入
+有效位，小数位
  float(7,2)     #没写小数，自动补小数
  xxxxx.xx
   99999.99
   -99999.99

+关于整数型字段
– 使用 UNSIGNED 修饰时,对应的字段只保存正数
– 数值不够指定宽度时,在左边填空格补位
– 宽度仅是显示宽度,存数值的大小由类型决定
– 使用关键字 ZEROFILL 时,填 0 代替空格补位
– 数值超出范围时,报错

+关于浮点型字段
– 定义格式: float( 总宽度 , 小数位数 )
– 当字段值与类型不匹配时,字段值作为 0 处理
– 数值超出范围时,仅保存最大 / 最小值

例子：
create table t1(age tinyint,pay float(7,2));   
create table t2(age tinyint unsigned);  
##################################################################################
●字符型 #赋值时，加引号
+定长:
 char(宽度)            #性能更好，生产环境比较多
     --最大255个字符
     --默认为1个字符
     --不足宽度，自动以空格补位
+变长:
 varchar(宽度)         #不占用太多空间，可是性能没那么好，生产环境比较少
     --最大65532个字符
     --必须指定宽度
+大文本类型:
 text/blob
     --大于65535时使用
##################################################################################
●日期时间类型
+日期时间,Datetime
   -不指定时为空，用NULL表示
  20180802183000 yyyymmddHHMMSS
+时期时间,timestamp
  -约束条件时当前时间
  -未指定时间，则自动以当前时间
+日期,Date
   -占用4个字节
   -年月日
  20180802    yyyymmdd
+时间,Time
   -占用3个字节
   -时分秒
   083000    HHMMSS
+年，year
   -年
   yyyy

●案例：
1.基本使用
mysql> insert into myitem values("nb","19930915","20180915080000","1993","090000");
Query OK, 1 row affected (0.03 sec)

mysql> select * from myitem;
+------+------------+---------------------+-------+----------+
| name | birthday   | meeting             | start | sktime   |
+------+------------+---------------------+-------+----------+
| nb   | 1993-09-15 | 2018-09-15 08:00:00 |  1993 | 09:00:00 |
+------+------------+---------------------+-------+----------+

2.datetime,timestamp
mysql> create table t7(
    -> party datetime,
    -> meeting timestamp,
     -> );
mysql> insert into t7(party) values(20190809100000);
mysql> insert into t7 values(now(),20190806120000);
mysql> insert into t7(meeting) values(20190806120000);

+---------------------+---------------------+
| party               | meeting             |
+---------------------+---------------------+
| 2019-08-09 10:00:00 | 2018-09-07 10:06:42 |
| 2018-09-07 10:14:07 | 2019-08-06 12:00:00 |
| NULL                | 2019-08-06 12:00:00 |
+---------------------+---------------------+

##################################################################################
●枚举类型
字段的值，只能在列举的值里面选择
字段名  enum(值列表)  单选
字段名  set(值列表)   多选

●案例：
mysql> create table t6( 
name char(10), 
sex enum("male","famale","no"), 
interst set("basketball","Linux","IT","AVI") 
);

mysql> desc t6;
+a---------+--------------------------------------+------+-----+---------+------+
| Field   | Type                                 | Null | Key | Default | Extra |
+a---------+--------------------------------------+------+-----+---------+------+
| name    | char(10)                             | YES  |     | NULL    |       |
| sex     | enum('male','famale','no')           | YES  |     | NULL    |       |
| interst | set('basketball','Linux','IT','AVI') | YES  |     | NULL    |       |
+a---------+--------------------------------------+------+-----+---------+------+
3 rows in set (0.00 sec)

mysql> insert into t6 values("yangribo","male","AVI");

##################################################################################
整数值
int(5) unsigned zerofill  #(5)为显示宽度，不足时默认补空格；加上"zerofill"后补0；数字大小由类型决定
1----->00001
22--->00022
3333--->03333
##################################################################################
●时间函数
now()     当前系统日期+时间
curtime() 当前的时间
curdate() 当前日期
year()    指定的年
date()    指定的日期
day()     指定的天
time()    指定时间
sleep(N)  休眠N秒

●指定年份
指定2001～2069时可以用  01～69
指定1970～1999时可以用  70～99
年范围 1901～2155年

mysql> select  now();
+---------------------+
| now()               |
+---------------------+
| 2018-09-07 09:29:19 |
+---------------------+
mysql> select  year(  now() );
+-------------+
| year(now()) |
+-------------+
|        2018 |
+-------------+
mysql> select sleep(9);

案例：
-----------------------------------------------------------------------------------------------------------------------------------
mysql> desc time;
+----------+------------+------+-----+---------+-------+
| Field    | Type       | Null | Key | Default | Extra |
+----------+------------+------+-----+---------+-------+
| class    | time       | YES  |     | NULL    |       |
| deadline | date       | YES  |     | NULL    |       |
| remain   | tinyint(4) | YES  |     | NULL    |       |
| current  | datetime   | YES  |     | NULL    |       |
+----------+------------+------+-----+---------+-------+


mysql> insert into time values(083000,date(20180925180000),day(20180925180000)-day(now()),curtime());

mysql> select * from time;                                                      +----------+------------+--------+---------------------+
| class    | deadline   | remain | current             |
+----------+------------+--------+---------------------+
| 08:30:00 | 2018-09-25 |     18 | 2018-09-07 09:47:34 |
+----------+------------+--------+---------------------+

-----------------------------------------------------------------------------------------------------------------------------------































