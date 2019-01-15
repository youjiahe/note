##################################################################################
●PL/SQL 简介
   PL/SQL 是一种块结构的语言，它将一组语句放在一个块中，一次性发送给服务器，PL/SQL
   引擎分析收到 PL/SQL 语句块中的内容，把其中的过程控制语句由 PL/SQL 引擎自身去执行，
   把 PL/SQL 块中的 SQL 语句交给服务器的 SQL 语句执行器执行。 

●PL/SQL 的优点还有：
 -- 支持 SQL
    SQL 是访问数据库的标准语言，通过 SQL 命令，用户可以操纵数据库中的数据。PL/SQL
    支持所有的 SQL 数据操纵命令、游标控制命令、事务控制命令、SQL 函数、运算符和伪列。
    同时 PL/SQL 和 SQL 语言紧密集成，PL/SQL 支持所有的 SQL 数据类型和 NULL 值。
 -- 支持面向对象编程
    PL/SQL 支持面向对象的编程，在 PL/SQL 中可以创建类型，可以对类型进行继承，可以
    在子程序中重载方法等。
 -- 更好的性能
    SQL 是非过程语言，只能一条一条执行，而 PL/SQL 把一个 PL/SQL 块统一进行编译后执
    行，同时还可以把编译好的 PL/SQL 块存储起来，以备重用，减少了应用程序和服务器之间
    的通信时间，PL/SQL 是快速而高效的。
 -- 可移植性
    使用 PL/SQL 编写的应用程序，可以移植到任何操作系统平台上的 Oracle 服务器，同时
    还可以编写可移植程序库，在不同环境中重用。
 -- 安全性
    可以通过存储过程对客户机和服务器之间的应用程序逻辑进行分隔，这样可以限制对
    Oracle 数据库的访问，数据库还可以授权和撤销其他用户访问的能力。
##################################################################################
PL/SQL数据类型
● 标量数据类型：
--VARCHAR2(长度) 
--NUMBER(精度，小数)  
--DATE 
--TIMESTAMP 
--CHAR(长度)  
  #固定长度字符，最长 32767 字节，默认长度是 1，如果内容不够用空格代替。
--LONG
  #Oracle SQL 定义的数据类型，变长字符串基本类型，最长 32760 字节。
  #在 Oracle SQL 中最长 2147483647 字节。
--BOOLEAN 
  #PL/SQL 附加的数据类型，逻辑值为 TRUE、FALSE、NULL
--BINARY_INTEGER 
  #PL/SQL 附加的数据类型，
--PLS_INTEGER
  #PL/SQL 附加的数据类型，介于-2^31 和 2^31 之间的整数。
  #类似于BINARY_INTEGER，只是 PLS_INTEGER 值上的运行速度更快。
--NATURAL
  #PL/SQL 附加的数据类型，BINARY_INTEGER 子类型，表示从 0 开始的自然数。
--NATURALN 
  #与 NATURAL 一样，只是要求 NATURALN 类型变量值不能为 NULL。
--POSITIVE 
  #PL/SQL 附加的数据类型，BINARY_INTEGER 子类型，正整数。
--POSITIVEN 
  #与 POSITIVE 一样，只是要求 POSITIVE 的变量值不能为 NULL。
--REAL 
  #Oracle SQL 定义的数据类型，18 位精度的浮点数
--INT,INTEGER,SMALLINT 
  #Oracle SQL 定义的数据类型，NUMBERDE 的子类型，38 位精度整数。
--SIGNTYPE 
  #PL/SQL 附加的数据类型，BINARY_INTEGER 子类型。值有：1、-1、0。
--STRING 
  #与 VARCHAR2 相同。
  
● 属性数据类型
%ROWTYPE
  #引用数据库表中的一行作为数据类型,可以使用“.”来访问记录中的属性。
%TYPE
  #引用某个变量或者数据库的列的类型作为某变量的数据类型。

##################################################################################
● 语法结构：
  PL/SQL 块的语法
  [DECLARE --declaration statements]    #声明部分：包含了变量和常量的定义
  BEGIN --executable statements         #执行部分：sql语句，输出语句
  [EXCEPTION --exception statements]    #异常处理部分：
  END;
  /
● 符号：
  -- PL/SQL 中的单行注释。
  /*,*/ PL/SQL 中的多行注释，多行注释不能嵌套。
  
● 例子：
--变量声明： #变量数据类型支持哪些请百度；
  DECLARE 
     sname VARCHAR2(20) default 'jerry'; 
  BEGIN
     select ename into sname from emp where empno=7934;
     dbms_output.put_line(sname);
  END;
  /
--常量：
  DECLARE 
     pi CONSTANT NUMBER:=3.141592657;
     r NUMBER:=24;
     area NUMBER;
  BEGIN
     area:=pi*r*r;
     dbms_output.put_line(to_number(to_char(area,'L999999.9999'),'$999999.9999'));
  END;
  /
  
--行类型ROWTYPE
  DECLARE
     myemp EMP%ROWTYPE;
  BEGIN
     select * into myemp from emp where empno=7654;
     dbms_output.put_line(myemp.ename);
     dbms_output.put_line(myemp.job);
  END;
  /
  
--列类型TYPE
  DECLARE
   sal EMP.SAL%TYPE;
   mysal NUMBER(5):=15000;
   totalsal mysal%TYPE;
  BEGIN
     SELECT SAL INTO sal FROM EMP WHERE EMPNO=7876;
     totalsal:=sal+mysal;
     dbms_output.put_line(totalsal)
  END;
  /
  
##################################################################################
PL/SQL 条件控制和循环控制
● IF语法结构
 IF 条件 1 THEN 
    --条件 1 成立结构体
 ELSIF 条件 2 THEN 
    --条件 2 成立结构体
 ELSE 
    --以上条件都不成立结构体
 END IF; 
● CASE语法结构
  CASE [selector]
    WHEN 表达式 1 THEN 语句序列 1；
    WHEN 表达式 2 THEN 语句序列 2；
    WHEN 表达式 3 THEN 语句序列 3；
    ……
  [ELSE 语句序列 N]；
  END CASE;
