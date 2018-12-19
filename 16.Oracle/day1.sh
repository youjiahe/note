0.oracle安装
   https://www.cnblogs.com/yingsong/p/6031235.html
  & 内核参数解析：
    #vi/etc/sysctl.conf  
    net.ipv4.ip_local_port_range= 9000 65500 #本地临时端口，对并发连接数有影响
    fs.file-max = 6815744      #最大打开文件数
    kernel.shmall = 10523004   #共享内存总量
    kernel.shmmax = 6465333657 #共享内存最大值
    kernel.shmmni = 4096       #共享内存最小值
    kernel.sem = 250 32000 100128 
    net.core.rmem_default=262144  #接收套接字缓冲区大小默认值,字节
    net.core.wmem_default=262144  #为TCP socket预留用于发送缓冲的内存数量,字节
    net.core.rmem_max=4194304     #接收套接字缓冲区大小最大值
    net.core.wmem_max=1048576     #为TCP socket预留用于发送缓冲的内存数量,最大值
    fs.aio-max-nr = 1048576       #此参数限制并发未完成的异步请求数目，应该设置避免I/O子系统故障。
   & 静默安装 命令
   /home/oracle/database/runInstaller -silent -ignorePrereq -responseFile /home/oracle/database/response/db_install.rsp

   & 配置监听文件
   netca  /silent /responsefile /home/oracle/database/response/netca.rsp

   & SID最好不要使用网页的 webtalk，使用 orcl11g
######################################################
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
用户与授权
######################################################
表空间
  ● 默认表空间 
    ― oracle用户中的默认表空间： 
      ☆ 默认永久性表空间system 
      ☆ 默认临时表空间temp

     如果所有用户都使用oracle默认表空间,会增加system与temp表空间的竞争性

  ● 查询默认表空间 
    ― 当前用户的默认表空间 
      SQL> select default_tablespace from user_users;
      
      DEFAULT_TABLESPACE
      ------------------------------
      SYSTEM
   
    ― 默认表空间
      select property_name,property_value from database_properties where property_name in ('default_permanent_tablespace','default_temp_tablespace');

  ● 设置默认表空间
    ― 就是修改database_properties数据字典的值
    ― 命令:
      alter database default temporary tablespace MY_SPACE; #临时表空间
      alter database default tabelspace MY_P_SPACE;         #永久表空间
