问题：
1.重要选项ALGORITHM的使用，给出例子?
2.temptable #具体化方式
  含义:
  先执行创建视图时的SQL查询语句，结果放到查询缓存；
  再执行 select * from 视图名，这个命令在缓存上面查询。  
  问题来了:
  没有视图时，如何执行select * from 视图名?
  创建视图的命令什么时候执行?
##################################################################################
视图
●什么是视图(View)
  &虚拟表
  &内容与真实的表相似,有字段有记录
  &视图并不在数据库中以存储的数据形式存在
  &行和列的数据来自定义视图时查询所引用的基表,并且在具体引用视图时动态生成
  &更新视图的数据,就是更新基表的数据
  &更新基表数据,视图的数据也会跟着改变
●作用
  针对不同的用户提供同一个基表，不同的数据
●视图优点
  +简单
    &用户不需关心视图中的数据如何查询获得
    &视图中的数据已经是过滤好的符合条件的结果集
  +安全
    &用户只能看到视图中的数据
    &只能修改视图对应数据
  +数据独立
    &一旦视图结构确定,可以屏蔽表结构对用户的影响
●视图使用限制
  +不能在视图上创建索引
  +在视图的FROM子句中不能使用子查询
  +以下情形中的视图是不可更新的
    &包含以下关键字的SQL语句:聚合函数(SUM、MIN、MAX、COUNT等)、DISTINCT、GROUP BY、HAVING、UNIONUNION ALL
    &常量视图、JOIN、FROM一个不能更新的视图
   &WHERE子句的子查询引用了FROM子句中的表
    &使用了临时表
##################################################################################
视图基本使用
●创建视图
  +格式
    create view 视图名称 as SQL查询;
    create view 视图名称(字段名列表) as SQL查询
  +例子： 
  mysql> create view db55.v2 as select name,uid,homedir from db55.user;
  mysql> create view v3(vname,vshell) as select name,shell from user;
  ~]# ls /var/lib/mysql/db55/
  db.opt  user.frm  user.ibd  v1.frm  v2.frm  v3.frm  #视图没有索引,数据文件.ibd
●查看视图
  show table status\G;                        #查看当前库下所有表的状态信息
  show table status where comment="view"\G;   #查看当前库下所有的视图表 
  show create view v1\G;                      #创建视图v1的创建命令
●使用视图(select insert delete update)
   #基表数据也会改变
##################################################################################  
视图进阶
●视图别名
  +别名的必要性
    &先创建下面两张表
    mysql> create table t1 select name,uid,shell from user limit 3;
    mysql> create table t2 select name,uid,shell from user limit 6;   
    &再创建视图，会报错  #不能有重复的字段名，因此需要做别名
    mysql> create view v4 as select * from t1,t2 where t1.name=t2.name;
    ERROR 1060 (42S21): Duplicate column name 'name'  
     
  +创建别名 
  &无别名
  mysql> select t1.name,t2.name from t1 left join t2 on t1.name=t2.name;
  +--------+--------+
  | name   | name   |  
  +--------+--------+
  | root   | root   |
  | bin    | bin    |
  | daemon | daemon |
  +--------+--------+
  
  &有别名
  mysql> select a.name as aname,b.name as bname from t1 a left join t2 b on a.name=b.name;    
  +--------+--------+
  | aname  | bname  | 
  +--------+--------+
  | root   | root   |
  | bin    | bin    |
  | daemon | daemon |
  +--------+--------+
  
  &创建视图别名方法1：
  mysql> create view v4 as select a.name as aname,b.name as bname from t1 a left join t2 b
          on a.name=b.name;
          
  &创建视图别名方法2：        
  mysql> create view v5(aname,bname) as select t1.name,t2.name from t1 left join t2 
         on t1.name=t2.name;
  mysql> select * from v4;
  +--------+--------+
  | aname  | bname  |
  +--------+--------+
  | root   | root   |
  | bin    | bin    |
  | daemon | daemon |
  +--------+--------+
##################################################################################
视图进阶
--重要选项
●覆盖创建视图
  &or replace #创建表时加上该选项，会覆盖原来已经存在的，相同名称的表
  mysql> create or replace view v1 select * from user;
●ALGORITHM
  ALGORITHM = {UNDEFINED | MERAGE |TEMPTABLE}   
  &merge      #替换方式
    不单独执行创建视图时的SQL查询；创建视图与SQL查询一起执行
  &temptable  #具体化方式
    先执行创建视图时的SQL查询语句，结果放到查询缓存；
    再执行 select * from 视图名，这个命令再缓存上面查询，最后再建视图； #有问题
●LOCAL和CASCADED关键字决定检查的范围
  &local      #仅检查当前视图的限制
  &cascaded   #同时要满足基表的限制(默认值)
  &格式：with [local|cascaded] check option #支持检查选项
  
 +例子：with local check option
  mysql> create table user2 
         select * from user where uid>=10 and  uid<=1000;
  mysql> create view v6 as
         select * from user2 where uid <100 with local check option; 
   #视图数据需满足v6.uid<100；
   #视图会以创表时的SQL查询条件作为限制         
  mysql> update v6 set uid=101 where name="mysql";
      ERROR 1369 (HY000): CHECK OPTION failed 'db55.v6'  
  mysql> insert into v6 values("tom",123);
      ERROR 1369 (HY000): CHECK OPTION failed 'db55.v6'

 +例子：with cascaded check option
  mysql> create view v7(v7name,v7uid) as 
         select name,uid from  user2 where uid>=10 and uid<=50 
         with local check option;
  mysql> create view v8(v8name,v8uid) as 
         select v7name,v7uid from v7 where uid>=20 
         with cascaded check option;
   #视图数据需满足v8uid>=20 and v8<=50；
  #cascaded会同时满足基表及自身的限制；

  mysql> insert into v8 values("dodo",18);
       ERROR 1369 (HY000): CHECK OPTION failed 'db55.v8'
  mysql> insert into v8 values("dodo",51);
       ERROR 1369 (HY000): CHECK OPTION failed 'db55.v8'
  mysql> insert into v8 values("dodo",50);
       Query OK, 1 row affected (0.03 sec)
##################################################################################
MySQL存储过程 (对数据库管理操作)
●存储过程
   +相当于时MySQL语句组成的脚本
●存储过程的优点
   &提高性能
     编译执行的，与解释执行区别开来  #编译执行是直接编译成二进制代码，直接让内核调配硬件；解释执行需要解释器进行解释
   &可减轻网络负担  #不明白     
   &可以防止对表的直接访问
   &避免重复编写SQL操作
##################################################################################
创建MySQL存储过程
●注意
   必须在库下创建；use 库名
●格式
  mysql> delimiter //      #把命令结束符替换为“//”
      -> create procedure 名称()
      -> begin
            .. .. 功能代码
      -> end
        -> //                     #结束存储过程
  mysql> delimiter;
  
  +例子
delimiter //
create procedure p1()
begin
select * from user limit 10;
end
//
delimiter ;
  
  call p1();            #调用存储过程 p1()
##################################################################################
查看存储过程
●方法1
   mysql> show procedure status;
    #查看当前数据库中的所有存储过程的详细信息 
●方法2
   mysql> select db,name,type from mysql.proc where type="procedure";   
    #查看存放
   mysql> select body from mysql.proc where name="p1";   
    #查看当前数据库中的存储过程的代码
    +--------------------------------------------+
    | body                                       |
    +--------------------------------------------+
    | begin
      select * from user limit 10;
      end |
    +--------------------------------------------+
##################################################################################    
●删除存储过程
drop procedure 存储过程名;
##################################################################################
●存储过程实例
1.创建存储过程p2,统计user表中shell为/bin/bash的个数
delimiter //
create procedure p2()
begin
select count(name) from user where shell="/bin/bash";
end
//
delimiter ;
call p2;

错误例子
2.创建存储过程user,导入/etc/passwd到表db55.usertab
create database db55;
use db55;
system cp /etc/passwd /var/lib/mysql-files/
system chown -R mysql /var/lib/mysql-files/
delimiter //
create procedure user()
begin
create table usertab(name char(20),pass char(5),uid int(5),gid int(5),comment char(120),homedir char(50),shell char(50));
load data infile "/var/lib/mysql-files/passwd" into table db55.user fields terminated by ":" lines terminated by "\n";
end
//
delimiter ;

ERROR 1314 (0A000): LOAD DATA is not allowed in stored procedures
##################################################################################
存储过程进阶
●变量
  会话变量    系统变量，会话变量的修改,只会影响到当前的会话。 
  全局变量    系统变量，全局变量的修改会影响到整个服务器。    select @@hostname
  用户变量    当当前连接断开后所有用户变量失效。 set @x = 9;
  局部变量    在存储过程中的begin与end之间；    declare专门用来定义局部变量。
●修改变量
  set sort_buffer_size=800000;            #修改会话变量,全局变量
  set @y=3;                               #设置用户变量
  select max(uid) into @y from user;      #把user表中uid最大值赋给用户变量y
●查看变量
  show global variables like "%关键字%";     #查看全局变量
  show session variables like "%关键字%";    #查看会话变量
  select @y;                              #查看用户变量y
  select @@hostname；                     #查看系统变量hostname
●存储过程指定局部变量,用户变量赋值                
delimiter //
create procedure p5()
begin
   declare x int(2) default 1;  
   declare y char(10);          
   set y="nima";
   set x=123;
   select x;
   select y;
end
//
delimiter ;  
call p5;
#上述例子不影响用户变量@x,@y

存储过程进阶
##################################################################################
存储过程运算
●运算
  + - * / %  DIV(整除) 
●例子 
  +简单例子
  set @i=1+1;
  set @j=456;
  set @k=@i + @j;
  set @k=@k%9;
  set @k=@k%2+@k;
  
+实例：统计/bin/bash与/sbin/nologin用户数量

delimiter //
create procedure p6()
begin
   declare x int(2);
   declare y int(2);
   declare z int(3);
   select count(name) into x from user where shell="/bin/bash";
   select count(name) into y from user where shell="/sbin/nologin";
   set z=x+y;
   select x,y,z;
end
//
delimiter ;  
call p6();
mysql> call p6;
+------+------+------+
| x    | y    | z    |
+------+------+------+
|    2 |   36 |   38 |
+------+------+------+
##################################################################################
存储过程参数
●给存储过程传值或接收存储过程输出的值
●格式
  +调用参数时,名称前也不需要加@
   create procedure 名称(
   类型 参数名 数据类型 , 类型 参数名 数据类型
   )
   
      类型      名称                    描述
     in     输入参数       作用是给存储过程传值,必须在调用存储过程时赋值,
                               在存储过程中该参数的值不允许修改;
                               默认类型是in
                            
     out    输出参数       该值可在存储过程内部被改变,并可返回。 

    inout  输入/输出参数   调用时指定,并且可被改变和返回
    
●例子    
●1.类型in
delimiter //
create procedure p7(in sname char(30))
begin
   declare x int(2);
   select count(name) into x from user where shell=sname;
   select x as shell;
end
//
delimiter ;
call p7("/bin/bash");

●2.类型out   #参数中需要写变量
delimiter //
create procedure p8(out usernum int(2))
begin
   select count(name) into usernum from user where shell="/bin/bash";
   select usernum;
end
//
delimiter ;
call p8(@x);
+---------+
| usernum |
+---------+
|       2 |
+---------+

●3.类型inout
delimiter //
create procedure p9(inout num int(2))
begin
    select num as num_in;
    select count(name) into num from user where shell="/sbin/shutdown";
    select num as num_out;
end
//
delimiter ;
set @y=9;
call p9(@y);
+--------+
| num_in |
+--------+
|      9 |
+--------+
1 row in set (0.00 sec)

+---------+
| num_out |
+---------+
|       1 |
+---------+
##################################################################################
流程控制
●条件测试
  数值比较、字符比较、正则匹配、模糊匹配、逻辑与或非、空判断
●格式
  if 条件测试 then
      代码.. ..
      .. ..
   else
      代码.. ..
  end if;
●例子
显示指定范围的用户
delimiter //
create procedure p10(in x int(2),in y int(2))
begin
   if x is not null and y is not null then
      select  * from db55.user where id>=x and id<=y;
   else
      select * from db55.user;
   end if;
end
//
delimiter ;
##################################################################################
流程控制
●循环结构 while
●格式
  while 条件判断 do
  循环体
  .. ..
  end while ;
●例子
1.计算1+..+100
delimiter //
create procedure p11()
begin
   declare i int(2);
   declare j int(2); 
   set i=1;
   set j=0;
   while i<=100 do
        set j=j+i;
        set i=i+1;
   end while;
   select j;
end
//
delimiter ;
call p11();
##################################################################################
流程控制
●循环结构 loop死循环
  无条件反复执行某一段代码
●格式  
  loop
  循环体
  .. ..
  end loop;
##################################################################################
流程控制
●循环结构 repeat条件式循环  
   当条件成立时结束循环
●格式
  repeat
  循环体
  .. ..
  until 条件判断
  end repeat;
●例子
●1.计算1+..+100
delimiter //
create procedure p12()
begin
   declare i int(2);
   declare j int(2); 
   set i=1;
   set j=0;
   repeat
      set j=j+i;
      set i=i+1;
   until i>100
   end repeat; 
   select j;
end
//
delimiter ;
call p12();

##################################################################################
作业
创建p18
能够输出指定范围内的uid是偶数的用户名，uid号；
delimiter //
create procedure p19(in x int(2),in y int(2))
begin
   if x is not null and y is not null then       
       select name,uid from db55.user where uid%2=0 and uid between x and y;
   else
       select * from db55.user;
   end if; 
end 
//
delimiter ;
call p19(10,1000);

满足以下要求:
1)定义名称为p3的存储过程
2)用户可以自定义显示user表记录的行数
3)若调用时用户没有输入行数,默认显示第1条记录
delimiter //
create procedure p14(in line int(2))
begin
   if line is not null then 
       select * from db55.user limit line;
   else
       select * from db55.user limit 1;
   end if;
end 
//
delimiter ;
call p14(4);

























