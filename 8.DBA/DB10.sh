##################################################################################
数据分片，分库分表
●概念
  将存放在一个数据库(主机)中的数据,按照特定方式进行拆分,分散存放到多个数据库(主机)中,以达到分散单台设备负载的效果
●纵向切分
  +将单个表,拆分成多个表,分散到不同的数据库
  +将单个数据库的多个表进行分类,按业务类别分散到不同的数据库上
●横向切分
  +按照表中某个字段的某种规则,把表中的许多记录按行切分,分散到多个数据库
##################################################################################
数据分片实现
●软件mycat
   mycat 是基于Java的分布式数据库系统中间层,为高并发环境的分布式访问提供解决方案
   – 支持JDBC形式连接
   – 支持MySQL、Oracle、Sqlserver、Mongodb等
   – 提供数据读写分离服务
   – 可以实现数据库服务器的高可用
   – 提供数据分片服务
   – 基于阿里巴巴Cobar进行研发的开源软件
   – 适合数据大量写入数据的存储需求
●分片规则，10种
  comment-day-10.txt  #老师笔记里面，这个文件对每种规则做了详细说明
●工作过程
             
          |--------------dn1,prov=wuhan,db1@Mysql1  
             |           
  mycat---|
(sql命令)  |
          |--------------dn2,prov=bi,db2@Mysql2
          
  当mycat收到一个SQL查询时
  – 先解析这个SQL查找涉及到的表
  – 然后看此表的定义,如果有分片规则,则获取SQL里分片字段的值,并匹配分片函数,获得分片列表
  – 然后将SQL发往这些分片去执行
  – 最后收集和处理所有分片结果数据,并返回到客户端
    
##################################################################################
数据分片实现
搭建mycat
●装包
  yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-headless
●mycat服务软件解包
  ~]# tar -xf Mycat-server-1.4-beta-20150604171601-linux.tar.gz
  ~]# mv mycat/ /usr/local/
  ~]# ls /usr/local/
  bin  catlet  conf  lib  logs  version.txt

  目录结构说明
  – bin         #mycat命令,如 启动 停止 等
  – catlet      #扩展功能
  – conf        #配置文件
  – lib         #mycat使用的jar
  – log         #mycat启动日志和运行日志
  – wrapper.log #mycat服务启动日志
  – mycat.log   #记录SQL脚本执行后的报错内容
●重要配置文件
   &server.xml    #设置连接mycat的账号信息
   &schema.xml    #配置mycat的真实库表
   &rule.xml      #mycat的分片规则

●查看server.xml 账户信息文件
         vim /usr/local/mycat/conf/server.xml
          <---------------------------------------------------------------------------------------
        </system>
        <user name="test">    #连接mycat的用户，密码为test
                <property name="password">test</property> 
                <property name="schemas">TESTDB</property>
        </user>

        <user name="user">    #连接mycat的用户，密码为user
                <property name="password">user</property>
                <property name="schemas">TESTDB</property>
                <property name="readOnly">true</property>
        </user>
         --------------------------------------------------------------------------------------->
●查看schema.xml真实库表
~]# cat /usr/local/mycat/conf/schema.xml
<------------------------------------------------------------------------------------------------------------------------------------------------ 
<?xml version="1.0"?>
<!DOCTYPE mycat:schema SYSTEM "schema.dtd">
<mycat:schema xmlns:mycat="http://org.opencloudb/">

	      <schema name="TESTDB" checkSQLschema="false" sqlMaxLimit="100"> #逻辑库名 要与server.xml定义的一                 
		 
                 <table name="travelrecord" dataNode="dn1,dn2" rule="auto-sharding-long" />  #定义分片的表
                		 
                 <table name="company" primaryKey="ID" type="global" dataNode="dn1,dn2" />  #定义分片的表
                		
                 <table name="goods" primaryKey="ID" type="global" dataNode="dn1,dn2" /> #定义分片的表
                 <table name="hotnews" primaryKey="ID" dataNode="dn1,dn2" rule="mod-long" /> #定义分片的表
                		
                 <table name="employee" primaryKey="ID" dataNode="dn1,dn2" rule="sharding-by-intfile" /> #定义分片的表
                		
                 <table name="customer" primaryKey="ID" dataNode="dn1,dn2" rule="sharding-by-intfile" /> #定义分片的表
                 
	      </schema>
	
        <dataNode name="dn1" dataHost="c1" database="db1" /> 
        #定义分片使用的库，所在的物理主机 ,真正存储数据的db1库在物理主机c1上
	
        <dataNode name="dn2" dataHost="c2" database="db2" /> 
        #定义分片使用的库，所在的物理主机 ,真正存储数据的db2库在物理主机c2上
	
         #指定c1名称主机对应的ip地址
	<dataHost name="c1" maxCon="1000" minCon="10" balance="0"
		writeType="0" dbType="mysql" dbDriver="native" > 
		<heartbeat>select user()</heartbeat>
                <writeHost host="hostM1" url="192.168.4.54:3306" user="root"    
			password="123456">   #访问数据时 mycat服务连接数据库服务器时使用的用户名和密码
		</writeHost>
	</dataHost>

         #指定c2名称主机对应的ip地址
	<dataHost name="c2" maxCon="1000" minCon="10" balance="0"
		writeType="0" dbType="mysql" dbDriver="native" >
		<heartbeat>select user()</heartbeat>
                <writeHost host="hostM2" url="192.168.4.55:3306" user="root"
			password="123456">  #访问数据时 mycat服务连接数据库服务器时使用的用户名和密码
		</writeHost>
	</dataHost>
</mycat:schema>
------------------------------------------------------------------------------------------------------------------------------------------------>
##################################################################################
搭建数据库环境
●54,55授权用户root,密码123456
●54创建db1库，55创建db2库
●设置数据库服务器对大小写不敏感
  [mysqld]
  lower_case_table_names=1   
##################################################################################
启动mycat
●用java包的脚本
  ~]# /usr/local/mycat/bin/mycat start
  ~]# ss -utanlp | grep :8066
tcp    LISTEN     0      100      :::8066                 :::*                   users:(("java",pid=5176,fd=49))
##################################################################################
客户端测试
●以mycat的用户user，或者test进行登陆
  mysql -uuser -puser -P8066 -h192.168.4.50   #user用户为只读，test用户才能创表
  mysql> show databases;
  +----------+
  | DATABASE |
  +----------+
  | TESTDB   |
  +----------+
  mysql> use TESTDB
  mysql> show tables;  #该库所有表都是不存在的，虚拟的；
  +------------------+           #可是建表时表名必须与以下一致
| Tables in TESTDB |
+------------------+
| company          |
| customer         |
| customer_addr    |
| employee         |
| goods            |
| hotnews          |
| orders           |
| order_items      |
| travelrecord     |
+------------------+
9 rows in set (0.00 sec)
  mysql> select * from employee;
  ERROR 1146 (42S02): Table 'db2.employee' doesn,t exist
##################################################################################
建表,测试数据分片
●在schema.xml中，上述各表的分表定义
   &查看employee表的分片规则
   cd  /usr/local/mycat/conf/
   vim schema.xml
   <table name="employee" primaryKey="ID" dataNode="dn1,dn2" rule="sharding-by-intfile" /> #分片规则是rule="sharding-by-intfile"；
   
   &查看分片规则
    vim rule.xml
   <tableRule name="sharding-by-intfile">
                <rule>
                        <columns>sharding_id</columns>
                        <algorithm>hash-int</algorithm>
                </rule>
   </tableRule>
   
   &查看分片规则文件 
    vim  partition-hash-int.txt 
     10000=0    #sharding_id=10000时，数据写到mysql54数据库上
     10010=1    #sharding_id=10000时，数据写到mysql55数据库上
●以test用户登陆创表
  ~]# mysql -utest -ptest -P8066 -h192.168.4.50
  mysql> create table employee(sharding_id int(5),name char(20),age int(5));
● 在客户端上写数据测试分片
  mysql> insert into employee(sharding_id,name,age) values(10000,"Ben",18);
  mysql> insert into employee(sharding_id,name,age) values(10000,"JOJO",18);
  mysql> insert into employee(sharding_id,name,age) values(10010,"JOJO",19);
  mysql> insert into employee(sharding_id,name,age) values(10010,"Kobe",38);  
   #必须在表后面加上字段列表，才能给分片表格赋值
● mysql54，55查看数据，看到横向切分的效果
  +主机mysql54
  mysql> select * from db2.employee;  
  +-------------+------+------+
  | sharding_id | name | age  |
  +-------------+------+------+
  |       10000 | Ben  |   18 |
  |       10000 | JOJO |   18 |
  +-------------+------+------+
  
 +主机mysql55
  mysql> select * from db2.employee;  
  +-------------+------+------+
  | sharding_id | name | age  |
  +-------------+------+------+
  |       10010 | JOJO |   19 |
  |       10010 | Kobe |   38 |
  +-------------+------+------+
















