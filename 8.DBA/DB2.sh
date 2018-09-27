##################################################################################
约束条件
●作用：限制如何给字段赋值
●条件
  Null      允许为空       关键字 null
  NOT NULL  不允许为空
  KEY       索引类型
  DEFAULT   默认值          关键字default
  Extra     额外的值
  
●案例
  1.班级信息表，班级默认为NSD1806，年龄默认21
    mysql> create table t8(
    -> name char(4) not null,
    -> class char(10) not null default NSD1806,
    -> age tinyint(1) default 21,
    -> sex enum("m","g","no") not null 
     -> )；  
   mysql> insert into t8(name,sex) values("lisi","m");           
                                                       #指定姓名，性别；班级，年龄默认
   mysql> insert into t8(name,age,sex) values("tttt",null,"g");  
                                                       #指定姓名，年龄为空；班级默认，性别为g;
   mysql> insert into t8 values("null",default,null,"g"); 
                                                       #指定姓名为null，班级调用默认值，年龄为空
   mysql> insert into t8 values("",default,null,"g"); 
                                                       #指定姓名为"",即0个字符；其他同上
   mysql> select * from t8;
   +------+---------+------+-----+
  | name | class   | age  | sex |
   +------+---------+------+-----+
  | lisi | NSD1806 |   21 | m   |
  | tttt | NSD1806 | NULL | g   |
  | null | NSD1806 | NULL | g   |
  |      | NSD1806 | NULL | no  |
   +------+---------+------+-----+
●补充  
  “”!=null
##################################################################################
修改表结构
●格式
  alter table 表名 
  add/modify/change 字段名 类型(宽度) 约束条件;
  可加 after 字段名;
  或者 first;
●原则
  不要与表内容冲突
●动作
  add     #添加字段 
  modify  #修改字段位置，字段类型，约束条件
  change  #修改字段名;
             //格式change 源字段名  新字段名 类型 约束条件
  drop    #删除字段
  rename  #修改表名
●约束条件
  first 第一列插入
  after 在某哪个字段后面插入

●案例
+添加字段
  1.在最后添加email，tel字段
 mysql> alter table t6 add email varchar(30) default "student@tedu.com",
     -> add tel char(11)；
  2.在第一列添加class字段，在name字段后面添加qq号字段
 mysql> alter table t6 add class char(10) default "NSD1806" first,
     -> add QQ char(10) after name;  
     
+修改字段位置，约束条件
  alter table t6 modify sex  enum('male','famale','no') not null default "no" after    name;

+修改字段名
 mysql> alter table t6 change email mail varchar(30) default "student@tedu.com";

+修改表名
 mysql> alter table t6 rename stuinfo
##################################################################################   
MySQL键值
●键值作用
  1.限制如何给字段赋值
  2.给字段的值排队
  
●键值
  普通索引  index
  唯一索引  unique
  全文索引  fulltext
  主键      primary key
  外键      foreign key
##################################################################################
普通索引 index
●  1.索引介绍
    +类似于书的目录
    +给表的字段创建索引
    +索引类型：Btree(默认) B+Tree Hash
     &BTree:二叉树算法
●  2.索引的优缺点
    +优点：
      &可以提高查找效率。
    +缺点：
      &排队信息需要经常更新。
      &减慢数据的写速度
      &目录数会很高
      &占用物理空间
  生产环境中查操作远多于写操作，因此很有必要做索引
  
●  3.索引的确定
●  4.使用索引
     4.0索引使用规则
         &一个表中可以有多个INDEX
         &允许字段内容重复
       &INDEX字段的KEY标记时MUL
     4.1查看
        &查看表是否创建索引字段，找到KEY，是否有MUL
       >desc 表名；
        &查看表的详细信息
       >show  index from 表名；
       >explain select * from 表名  where name="boo"\G; 
           #验证是否有用索引查找数据，"\G" 竖向查看
         #rows: 1
         #Extra: using         
     4.2创建INDEX
        &建表时创建index字段
        mysql> create table t9(
        -> name char(10),
        -> age int(2),
        -> class char(7) not null default "NSD1806"，
        -> index(name),
        -> index(age)
           -> );        
        &在已有表中创建index字段
       >create index 索引名  on 表名(字段名)；      
     4.3删除
        >drop index 索引名 on 表名； 
##################################################################################          
主键primary key    
●使用规则
  &一个表只能有一个primary key字段
  &主键字段的KEY表及是PRI
  &通常与AUTO_INCREMENT连用
  &对应字段的值不允许重复，且不允许为NULL
  &经常把表中能够唯一标识记录的字段设置为主键字段
●创建primary key主键
  &创表时指定
   +格式1：
  mysql> create table t28(
    -> na0me char(10),
    -> age int(2),
    -> primary key(name)
     -> ); 
    +格式2：
   mysql> create table t29(
    -> name char(10) primary key,
    -> age int(2)
     -> );
  &已有表中指定
  mysql> alter table t5 add primary key(name);
●删除主键
  alter table 表名 drop primary key；
##################################################################################    
复合主键
●使用示例
  mysql.db
  mysql.user
●使用规则
  &表中多个字段作为主键，做主键字段的值不允许同时重复。    
  &不允许为空
●创建
   新建表：
  mysql> create table jfb( 
  name char(10), 
  stu_id int(1), 
  pay enum("yes","no"), 
  primary key(name,stu_id)
  );
  
  &已有表中指定
  mysql> alter table jfb add primary key(name，stu_id);
●删除符合主键
  alter table 表名 drop primary key；
##################################################################################    
primary key与AUTO_INCREMENT连用
●作用
  实现字段值的自动增长，让值自加1
●规则
  &auto_increment不能单独使用
●创建   
   mysql> create table increate(
    -> id int(1) primary key auto_increment,
    -> name char(5),
    -> age tinyiny(1) unsigned,
    -> class char(10)
      -> );
●细节
  查看当前计数器值
  show create table 表名 #找到AUTO_INCREMENT
  mysql> alter table NSD1806学生信息 auto_increment=8;  #修改计数器值
##################################################################################  
foregin key外键
●定义
  外键：让当前表字段的值在另一个表中字段值的范围内选择
●作用
  &保证数据一致性；
●规则
  &表的存储引擎必须时innodb;
  &字段类型要一致;
  &被参照字段必须是索引类型的一种，推荐paimary key;  
  create table tanme(....)  engine=innodb; 
  
●创建
  foregin key(表A的字段名)
  references 表B(字段名)
  on update cascade
  on delete cascade
●案例
    mysql> create table y(
    -> xname char(10) not null primary key,   #"not null primary key"是后加的
    -> class char(10) default "NSD1806",
    -> foreign key(xname) references x(fname) 
    -> on update cascade on delete cascade
    -> )engine=innodb;  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
