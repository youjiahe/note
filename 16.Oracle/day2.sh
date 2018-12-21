1.创表
DDL
  # sqlplus / as sysdba
  # 创建学生信息表
  CREATE TABLE STUS(
  STUID VARCHAR2(7) NOT NULL,
  STUNAME VARCHAR2(10) NOT NULL,
  AGE NUMBER(2) NOT NULL,
  GENDER VARCHAR2(2) NOT NULL,
  SEAT NUMBER(2) NOT NULL,
  ENROLLDATE DATE,
  CLASSNO VARCHAR2(4) NOT NULL
  )
  #创建表约束
  ALTER TABLE STUS ADD CONSTRAINT PK_STUS PRIMARY KEY(STUID)  #主键
  / 
  ALTER TABLE STUS ADD CONSTRAINT CK_STUS_GENDER CHECK(GENDER='male' OR GENDER='female')
  /
  ALTER TABLE STUS ADD CONSTRAINT CK_STUS_AGE CHECK(AGE>=0 OR AGE<100)
  /
  ALTER TABLE STUS ADD CONSTRAINT CK_STUS_SEAT CHECK(SEAT>=1 AND SEAT<=50) 
  / 
  ALTER TABLE STUS ADD CONSTRAINT CK_STUS_CLASSNO CHECK((CLASSNO>='1001' AND CLASSNO<='1999') OR (CLASSNO>='2001' AND CLASSNO<='2999'))   #范围约束
  /
  ALTER TABLE STUS ADD CONSTRAINT UN_SEAT UNIQUE(SEAT)  #唯一索引
  /  
  
  # 创建成绩表
  CREATE TABLE SCORES(
  ID NUMBER,
  STUID VARCHAR2(7) NOT NULL,
  CHINESE VARCHAR2(3) NOT NULL,
  MATH VARCHAR(3) NOT NULL
  );
  /
  ALTER TABLE SCORES ADD CONSTRAINT FK_SCORES_STUS_STUID FOREIGN KEY(STUID) REFERENCES STUS(STUID)
  /  #外键
  ALTER TABLE STUS MODIFY (GENDER VARCHAR(8));  #修改表结构

  # 创表嵌套select 语句
  create table stus1 as select * from stus where 1=2;

   ALTER TABLE STUS MODIFY (GENDER VARCHAR(8));
#####################################################################
DML：
2.insert
   insert into stus values('10000','jack',19,'male',1,to_date('2018-9-1 08:00:00','YYYY-MM-DD HH24:MI:SS'),'1001');
   # 嵌套select
   insert into stus1 select * from stus where stuid>=10005 and stuid<=10008;
   
3.update
  update stus set age=21 where stuname='jack';

4.delete
  delete from stus where age=21;

5.select
  select * from stus;
  select stuname,classno from stus;    
  select * from stus where age=21;    #数字匹配
  select * from stus order by seat;   #排序
  select * from stus where stuname like '%j_%';   #模糊匹配
  select * from stus where regexp_like(stuname,'^j');    #正则匹配
  select empname,salary,(salary*12+2000) as sumincome from emps;  #四则运算
  select (empname || ' is a '|| job) from emps;   #连接字符串
  select chinese,math from scores where stus_stuid=scores_stuid;  #多表查询
6.连接查询
  #建表
  create table emps(
  empid varchar2(7) not null,
  empname varchar2(10) not null,
  job varchar(10) not null,
  salary number(6),
  beizhu varchar2(50),
  deptid number(3)
  )
  alter table emps add (deptid number(3) not null); #添加字段
  alter table add contraints FK_EMPS_DEPTS foreign key(deptid) references depts(deptid);
  
  create table depts(
    deptid varchar2(7) not null,  
    deptname varchar2(6) not null
  );
  insert into depts values(1,'ops');
  insert into depts values(2,'dev');
  insert into depts values(3,'acc');
  insert into depts values(4,'gong');
  insert into depts values(5,'market');
  insert into depts values(6,'sells');
  insert into emps values('1000','youjiahe','engineer',11500,null,1);
  insert into emps values('1001','chenchuwen','engineer',11000,null,1);
  insert into emps values('1002','hehui','hr',9000,null,2);
  insert into emps values('1003','heihei','hr',7000,null,3);

  #多表查询
#@ 内联接 
  select e.empname,e.salary,e.job,d.deptname from emps e ,depts d where e.deptid=d.deptid and e.salary>=8000;
  select e.empname,e.salary,e.job,d.deptname from emps e LEFT JOIN depts d on e.deptid=d.deptid and e.salary>=8000;

#@外联接
  select e.empname,e.salary,e.job,d.deptname from emps e,depts d where e.deptid(+)=d.deptid;
  select e.empname,e.salary,e.job,d.deptname from emps e RIGHT join depts d on e.deptid=d.deptid;

