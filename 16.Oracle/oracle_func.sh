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
