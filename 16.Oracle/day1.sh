0.oracle安装
   https://www.cnblogs.com/yingsong/p/6031235.html

1.Oracle SQL 语句由如下命令组成：
  数据定义语言（DDL），包括 CREATE（创建）命令、ALTER（修改）命令、DROP（删
除）命令等。
  数据操纵语言（DML），包括 INSERT（插入）命令、UPDATE（更新）命令、DELETE
（删除）命令、SELECT … FOR UPDATE（查询）等。
  数据查询语言（DQL），包括基本查询语句、Order By 子句、Group By 子句等。
  事务控制语言（TCL），包括 COMMIT（提交）命令、SAVEPOINT（保存点）命令、
ROLLBACK（回滚）命令。
  数据控制语言（DCL），GRANT（授权）命令、REVOKE（撤销）命令。
######################################################

2.数据类型
  char(指定长度)    #存储固定长度的字符串。默认长度是 1，最长不超过 2000 字节
  varchar(最大长度) #存储可变长度的字符串。默认长度是 1，最长不超过 4000 字符。
  number(p,s)      #数值,p--最大位数，s--小数位数
  date             #日期
  timestamp        #不但存储日期的年月日，时分秒，以及秒后 6 位，同时包含时区。
  clob         #存储大的文本，比如存储非结构化的 XML 文档
  BLOB         #存储二进制对象，如图形、视频、声音等。

2.1 日期
  对于日期类型，可以使用 sysdate 内置函数可以获取当前的系统日期和时间，返回 DATE类型，
  用 systimestamp 函数可以返回当前日期、时间和时区。
  
  SQL> select sysdate,systimestamp from dual;
  SYSDATE
  ------------------
  SYSTIMESTAMP
  ---------------------------------------------------------------------------
  16-DEC-18
  16-DEC-18 11.42.50.350052 PM +08:00
######################################################
3. Oracle 创建表和约束

案例1：创建一个学生信息（INFOS）表和约束
create table infos(
  stuid varchar2(7) not null,
  stuname varchar2(10) not null,
  gender varchar(2) not null,
  age number(2) not null,
  seat number(2) not null,
  intodate date,
  stuadress varchar2(50) default '地址不详',
  classno number(4) not null
)
create table infos(
  stuid varchar2(7) not null,
  stuname varchar2(7) not null,
  gender varchar2(2) not null,
  age number(2) not null,
  seat number(2) not null,
  indate date,
  stuadress varchar2(50) default '地址不详',
  classno varchar(4) not null
)














