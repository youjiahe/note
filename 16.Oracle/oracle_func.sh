1.单行函数
       【字符函数】：对字符串操作。
       【数字函数】：对数字进行计算，返回一个数字。
       【转换函数】：可以将一种数据类型转换为另外一种数据类型。
       【日期函数】：对日期和时间进行处理。
2.聚合函数
  聚合函数同时可以对多行数据进行操作,如 sum

【字符函数】
  ASCII(x)     #返回字符 x 的 ASCII 码。
  CONCAT(x,y)  #连接字符串 x 和 y。
  INSTR(x, str [,start] [,n)
    #在 x 中查找 str，可以指定从 start 开始，也可以指定从第 n 次开始。
  LENGTH(x)  #返回 x 的长度。
  LOWER(x)   #x 转换为小写。
  UPPER(x)   #x 转换为大写。
  LTRIM(x[,trim_str])  #把 x 的左边截去 trim_str 字符串，缺省截去空格。
  RTRIM(x[,trim_str])  #把 x 的右边截去 trim_str 字符串，缺省截去空格。
  TRIM([trim_str FROM] x)  #把 x 的两边截去 trim_str 字符串，缺省截去空格。
  REPLACE(x,old,new)  #在 x 中查找 old，并替换为 new。
  SUBSTR(x,start[,length])
    #返回 x 的字串，从 staart 处开始，截取 length 个字符，缺省 length，默认到结尾。

    SELECT ASCII('a') FROM DUAL                   #97
    SELECT CONCAT('Hello', ' world') FROM DUAL    #Hello world
    SELECT INSTR('Hello world'，'or') FROM DUAL   #8
    SELECT LENGTH('Hello') FROM DUAL              #5
    SELECT LOWER('hElLO') FROM DUAL;              #hello
    SELECT UPPER('hello') FROM DUAL               #HELLO
    SELECT LTRIM('===HELLO===', '=') FROM DUAL    #HELLO===
    SELECT '=='||LTRIM(' HELLO===') FROM DUAL     #==HELLO===
    SELECT RTRIM('===HELLO===', '=') FROM DUAL    #===HELLO
    SELECT '='||TRIM(' HELLO ')||'=' FROM DUAL    #=HELLO=
    SELECT TRIM('=' FROM '===HELLO===') FROM DUAL #HELLO
    SELECT REPLACE('ABCDE','CD','AAA') FROM DUAL  #ABAAAE
    SELECT SUBSTR('ABCDE',2) FROM DUAL            #BCDE
    SELECT SUBSTR('ABCDE',2,3) FROM DUAL          #BCD

【数字函数】
    ABS(x)    x 绝对值               ABS(-3)=3
    ACOS(x)   x 的反余弦             ACOS(1)=0
    COS(x)    余弦                   COS(1)=1.57079633
    CEIL(x)  大于或等于 x 的最小值   CEIL(5.4)=6
    FLOOR(x)  小于或等于 x 的最大值  FLOOR(5.8)=5
    LOG(x,y)  x 为底 y 的对数        LOG(2,4)=2
    MOD(x,y)  x 除以 y 的余数        MOD(8,3)=2
    POWER(x,y)  x 的 y 次幂           POWER(2,3)=8
    ROUND(x[,y])  x 在第 y 位四舍五入  ROUND(3.456,2)=3.46
    SQRT(x)  x 的平方根  SQRT(4)=2
    TRUNC(x[,y])  x 在第 y 位截断  TRUNC(3.456,2)=3.45
 
【日期函数】
    日期函数
    日期函数对日期进行运算。常用的日期函数有：
  1.  ADD_MONTHS(d,n)，在某一个日期 d 上，加上指定的月数 n，返回计算后的新日期。d 表示日期，n 表示要加的月数。

    SQL> select sysdate,add_months(sysdate,5) from dual;

    SYSDATE        ADD_MONTHS(SYSDATE
    ------------------ ------------------
    21-DEC-18      21-MAY-19
  
  2. EXTRACT  #提取日期中的特定部分。
     select sysdate "date",
            extract(year from sysdate) "year",
            extract(month from sysdate) "month",
            extract(day from sysdate) "day",
            extract(hour from systimestamp) "hour",
            extract(minute from systimestamp) "min",
            extract(second from systimestamp) "sec"
     from dual;
  3.查看&修改时区
    SQL> select dbtimezone from dual;
	DBTIME
	------
	+00:00
    #重启数据库，修改时区生效
    SQL> shutdown immediate;
    SQL> startup；
    SQL> select dbtimezone from dual;
    DBTIME
    ------
    +08:00

【转换函数】
   1.TO_CHAR
     把日期和数字转换为制定格式的字符串。fmt 是格式化字符串
     select to_char(sysdate,'YYYY"年"MM"月"DD"日"HH24:MI:SS') "date" from dual;
     date
     -------------------------
     2018年12月22日18:26:09
     
     select to_char(-12345.67,'L9.9EEEEPR')
     TO_CHAR(-12345.67
     --------------------
	  <$1.2E+04>
     //L:   数字开头凡会一个美元符号；
     //9.9: 指定返回格式为9.9的数字；
     //EEEE:科学计数法；
     //PR:如果数字为负数，则用<>括起来；

   2.TO_NUMBER
     
     select to_number('$11,500.67','$99999.99') num from dual;

     NUM
     ----------
     11500.67

   3. TO_DATE
     select to_date('2018-09-11 23:00:01','YYYY-MM-DD HH24:MI:SS') to_date_ from dual;

     TO_DATE_
     ------------------
     11-SEP-18
【其他单行函数】
   1.NVL
    select * from (select rownum R,ename,job,sal,nvl(comm,2000) from emp where rownum<=14) where R>=7;

    	 R ENAME      JOB	       SAL NVL(COMM,2000)
---------- ---------- --------- ---------- --------------
	 7 CLARK      MANAGER	      2450	     2000
	 8 SCOTT      ANALYST	      3000	     2000
	 9 KING       PRESIDENT       5000	     2000
	10 TURNER     SALESMAN	      1500		0
	11 ADAMS      CLERK	      1100	     2000
	12 JAMES      CLERK	       950	     2000
	13 FORD       ANALYST	      3000	     2000
	14 MILLER     CLERK	      1300	     2000
#################################################################
【聚合函数】
   1. count
     select count(ename) from emp;
   2. sum,avg,max,min,
     select sum(sal) sum_sal from emp;
     select avg(sal) avg_sal from emp;
     select max(sal) max_sal from emp;
     select min(sal) min_sal from emp;
   3.avg，to_char综合
     select to_char(avg(sal),'99999.99') avg_sal from emp;
     select to_char(avg(sal),'L99999.99') avg_sal from emp;   #$2073.23
     select to_number(to_char(avg(sal),'L99999.99'),'$99999.99') avg_sal from emp;  #保留两位小数,结果:2073.23
