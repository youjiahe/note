DBA2 day2

1.MySQL读写分离
  1.1 MySQL读写分离概述
     1.1.1 读写分离
     1.1.2 案例拓扑
     1.1.3 读写分离原理
  1.2 构建读写分离
     1.2.1 构建思路
     1.2.2 部署maxscale服务
     1.2.3 起服务&&测试配置
2.MySQL多实例
  2.1 多实例概述
  2.2 配置多实例
##################################################################################
数据库读写分离
●数据库读写分离:
  把客户端查询数据和写入数据的请求分别给不同的数据库服务器处理
●实现方式
  通过服务实现，在客户端使用程序实现(人为分离)
  通过中间件实现                  #架设在客户端与服务器之间的服务称为中间件
  mycat、mysqlproxy、maxscale
●为什么读写分离
  实现服务器的负载均衡；
  充分利用硬件资源
  
●配置读写分离  
   &前提：51与52配置主从同步，51主，52从
   &特点：主库down，代理不能写；从库down，主库既写也读；
   &拓扑结构			        admina    123456
	client53   mysql  -h192.168.4.50  -u用户名    -p密码 -P4006
	      |
             代理服务器50
                       |
__________________________________
        write/read	    read
            |                           |
        master                 slave
          51	                      52
   &装包
   maxscale-2.1.2-1.rhel.7.x86_64.rpm
   &配置
   vim /etc/maxscale.cnf   #以“//”开头的是需要修改的内容
  <----------------------------------------------------------------------------------------------------
  9 [maxscale]
  10 threads=1                 #threads=auto  #启动的进程数量
   
  18 [server1]
  19 type=server
  //20 address=192.168.4.51    #master的IP
  21 port=3306
  22 protocol=MySQLBackend    
    
  //24 [server2]               #增加定义一个服务器
  //25 type=server
  //26 address=192.168.4.52    #slave的IP
  //27 port=3306
  //28 protocol=MySQLBackend
  
  35 [MySQL Monitor]           #监视器
  36 type=monitor
  37 module=mysqlmon
  //38 servers=server1,server2
  //39 user=scalemon           #监视用户;监视服务器状态，主从状态；
  //40 passwd=123456
  41 monitor_interval=10000
  
 //52 #[Read-Only Service]     #不指定只读服务器
 //53 #type=service
 //54 #router=readconnroute
 //55 #servers=server1
 //56 #user=myuser
 //57 #passwd=mypwd
 //58 #router_options=slave
 
 63 [Read-Write Service]       #配置读写服务
 64 type=service
 65 router=readwritesplit
 //66 servers=server1,server2 
 //67 user=scaleuser           #路由用户；检查数据库服务器本机是否存在客户端登陆的授权用户
 //68 passwd=123456        
 69 max_slave_connections=100%
 
 75 [MaxAdmin Service]         #管理服务，需要定义端口
 76 type=service
 77 router=cli
  
 //85 #[Read-Only Listener]    #不指定只读监听
 //86 #type=listener
 //87 #service=Read-Only Service
 //88 #protocol=MySQLClient
 //89 #port=4008
   
 91 [Read-Write Listener]
 92 type=listener
 93 service=Read-Write Service
 94 protocol=MySQLClient
 95 port=4006
 
 97 [MaxAdmin Listener]
 98 type=listener
 99 service=MaxAdmin Service
100 protocol=maxscaled
101 socket=default 
//102 port=4016               #指定管理服务的0端口
 ---------------------------------------------------------------------------------------------------->
  
  &创建授权用户：监视用户、路由用户、检查授权的用户(2台服务器都授权)
    mysql> grant replication slave,replication client on *.* to scalemon@'%'  
           identified by '123456';
    mysql> grant select on mysql.* to scaleuser@'%' identified by '123456';
  &起服务
  ]# maxscale -f /etc/maxscale.cnf

  &检查进程端口状态
   ]# ss -utanlp | grep :4006
    tcp    LISTEN     0      128      :::4006                
    :::*                   users:(("maxscale",pid=5100,fd=11))
   ]# ss -utanlp | grep :4016
    tcp    LISTEN     0      128      :::4016                
    :::*                   users:(("maxscale",pid=5100,fd=12))
   ]# ps -C maxscale
    PID TTY          TIME CMD
    5100 ?        00:00:00 maxscale

●在代理服务器本机访问管理服务
  maxadmin -uadmin -pmariadb -P4016   #maxscale软件的用户，密码
  Maxscale> list servers              #列出被代理服务器的状态
  Servers.
  -------------------+-----------------+-------+-------------+--------------------
  Server             | Address         | Port  | Connections | Status              
  -------------------+-----------------+-------+-------------+--------------------
  server1            | 192.168.4.51    |  3306 |           0 | Master, Running
  server2            | 192.168.4.52    |  3306 |           0 | Slave, Running
  -------------------+-----------------+-------+-------------+--------------------
●客户机验证代理服务设置(192.168.4.53)
  ]# mysql -ustudent -p123456 -h192.168.4.50 -P4006 #登陆maxscale中间件服务器  
   insert into ..    #在mysql52上插入数据；
                           #目的是区分主从库；
                           #查询时，客户机能看到，主库看不到该数据，就代表读写分离成功；
   select * from ..   #在客户机上查询数据，能查到mysql52的数据
##################################################################################
MySQL多实例
●多实例
   一台物理主机上运行多个数据库服务
●作用
  节约运维成本
  提高硬件利用率
●套接字文件  
  (socket file)  #mysql服务器启动后有
   主要用于网络通信，传递参数；套接字也可以是一台主机上的 进程之间的通信。
●搭建多实例
  +装包
   tar -xf mysql-5.7.20-linux-glibc2.12-x86_64
   mv mysql-5.7.20-linux-glibc2.12 /usr/local/mysql
  +配置
   &书写配置文件
      每个实例都需要有独立的目录、端口

   ~]# vim /etc/my.cnf
    <----------------------------------------------------------------------------------------------------
    [mysqld_multi]                               #启用多实例
    mysqld = /usr/local/mysql/bin/mysqld_safe     #启动程序
    mysqladmin = /usr/local/mysql/bin/mysqladmin  #管理程序
    user=root  #系统root,可以不指定；默认mysql,需要创建
 
    [mysqld1]                           #启用第一个mysql
    datadir=/data3307                   #指定目录
    port=3307                           #指定端口
    socket=/data3307/mysql3307.socket   #指定socket文件
    pid-file=/data3307/mysql.pid        #指定pid文件
    log-error=/data3307/mysqld.err      #指定错误日志
    
    [mysqld2]
    datadir=/data3308
    port=3308
    socket=/data3308/mysql3308.socket
    pid-file=/data3308/mysql.pid
    log-error=/data3308/mysqld.err
   ---------------------------------------------------------------------------------------------------->  
 +启动多实例服务
  ~]# echo "export PATH=/usr/local/mysql/bin/:$PATH" >> /etc/profile 
  ~]# source /etc/profile                #使合并PATH路径生效
  ~]# mkdir /data{3307,3308}
  ~]# mysqld_multi start 1               #启动实例1
  ~]# mysqld_multi start 2               #启动实例2
  ~]# ls /data3307
  auto.cnf        ib_logfile0  mysql                   mysqld.err          sys
  ib_buffer_pool  ib_logfile1  mysqld3307.socket       mysqld.pid
  ibdata1         ibtmp1       mysqld3307.socket.lock  performance_schema
●连接多实例服务
  ~]# echo "alter user root@localhost identified by '123456';" | \
     mysql -uroot -p'初始密码'  -S /data3307/mysqld3307.socket \
     --connect-expired-password
                          #-S,指定socket文件；可以以此区分多个数据库
  ~]# mysqld_multi --user=root --password=修改后的密码  stop 1 
                                 #停止实例
●别名访问
# /etc/bashrc
alias gom3307="mysql -uroot -p123456 -S /data3307/mysqld3307.socket"
alias gom3308="mysql -uroot -p123456 -S /data3308/mysqld3308.socket"
##################################################################################
MySQL性能调优
●提高MySQL系统的性能、响应速度
 +替换有问题的硬件
  内存、CPU、硬盘
  free、top(wa)、iostat
 +服务程序运行参数调整
   &命令：    
     mysql> show processlist；   #查看连接数据库的用户
     mysql> show status；        #查看数据库状态信息
     mysql> show status like '%innodb%';
     mysql> show variables；    #查看变量
     mysql> show variables like "%memory%";      
   &临时生效：
     mysql> set global max_connections=200;
   &永久生效：
     vim /etc/my.cnf
      <----------------------------
     [mysqld]
     max_connections=200   
      ---------------------------->  
 +对SQL查询进行优化
   在数据库服务器上启用慢查询日志文件，
   记录超过指定时间显示查询结果的sql命令
             
●生产中线上服务，需要设置的变量有哪些？

 +常见优化参数
  &并发及连接控制
  • 连接数、连接超时
  --max_connections #允许的最大并发连接数
         mysql> set global max_connections=500;  #最大连接数 
         mysql> show global status like "max_used_connections";----|
                                                                                       | --理想比率0.85
         mysql> show variables like "max_connections";  -----------|
            
  --connect_timeout #等待连接超时,默认10秒,仅登录时有效
         mysql> set global connect_timeout=10
         mysql> show variables like "%timeout%";
      
  --wait_timeout    #等待关闭连接的不活动超时秒数,默认28800秒(8小时)  
                          #补充了一些Innodb的timeout变量，看视频
         mysql> show variables like "wait_timeout";
            +---------------+-------+
          | Variable_name | Value |
            +---------------+-------+
          | wait_timeout  | 28800 |
            +---------------+-------+

  &缓存参数控制
  • 缓冲区、线程数量、开表数量   
 --key_buffer-size   #索引缓存大小
        mysql> show variables like "%buffer%";
        mysql> show variables like "key_buffer%";
          +-----------------+---------+
        | Variable_name   | Value   |
          +-----------------+---------+
        | key_buffer_size | 8388608 |
          +-----------------+---------+
        ~]# echo $[8388608/1024/1024]  
           8               #默认8M内存空间存放内存信息
      
 --sort_buffer_size  #为每个要排序的线程分配此大小的缓存空间
        mysql> select name,age from user order by age desc;
      
 --read_buffer_size  #为顺序读取表记录保留的缓存大小
        mysql> show variables like "read_buffer%"
 --thread_cache_size #允许保存在缓存中被重新调用的线程数量
        mysql> show variables like "thread_cache_size";
         +-------------------+-------+
        | Variable_name     | Value |
         +-------------------+-------+
        | thread_cache_size | 9     |        
         +-------------------+-------+   
 --table_open_cache  #为所有线程缓存的打开的表的数量
                           #每当MySQL访问一个表时，如果在表缓冲区中还有空间，
                           该表就被打开并放入其中，这样可以更快地访问表内容。    
   #如果你发现open_tables等于table_open_cache，并且opened_tables在不断增长，那么你就需要增加table_open_cache的值了
    mysql> show global status like "open%tables";
    mysql> show variables like "table_open_cache";
    +------------------+-------+
    | Variable_name    | Value |
    +------------------+-------+
    | table_open_cache | 2000  |
    +------------------+-------+
    Open_tables / Opened_tables >= 0.85     #合理值
    Open_tables / table_open_cache <= 0.95  #合理值
    
●对SQL查询进行优化
  +MySQL执行过程
  +查看变量
     &查看所有与缓存有关的变量
      mysql> show variables like "%cache%";
     &查看所有与缓存有关的变量
      mysql> show variables like "query_cache%"; 
   | query_cache_limit            #查询缓存大小,默认1M
   | query_cache_min_res_unit     #最小存储单元 4K；越大查询速度越快，浪费空间
   | query_cache_type             #启用/禁用查询缓存
   | query_cache_wlock_invalidate #查询缓存写锁 默认off；如果某个数据表被其他的连接锁住，是否仍然从查询缓存中返回结果。

    &查询缓存全局状态
    mysql> show global  status like "qcache%";
    qcache_hits      #查询缓存命中率
    qcache_inserts   #查询缓存次数
    
  +修改变量值，启用查询缓存
   query_cache_type = 0 | 1 | 2
    0：禁用查询缓存
    1：启用查询缓存
    2：启用查询缓存，但需要手动设置缓存本次的查询结果
  
     
  +优化sql查询命令(启用慢查询日志)
    &相关
    log-error=/var/log/mysqld.log  错误日志文件(默认启用)
    log-bin=日志名 binlog日志文件
    查询日志    记录数据库服务执行过的所有sql命令，默认关闭
    慢查询日志  记录查询用时超过指定值的sql命令，默认超时时间为10s，默认关闭;
  
     &慢查询日志   #里面有记录的命令,可以反馈到开发人员那里，让他们取优化
    ~]# vim /etc/mysqld
     <--------------------------------------------
     [mysqld]
     slow-query-log           #启用慢查询,根目录下,会生成 *-slow.log日志
     slow-query-log-file      #指定慢查询日志文件
     long-query-time          #超过时间(默认10秒)
     log-queries-not-using-indexes #记录未使用索引的查询
      -------------------------------------------->
    ~]# systemctl restart mysqld 
    ~]# mysqldumpslow /var/lib/mysql/主机名-slow.log #查看慢查询日志
     
    &查询日志                         #生产中常不开。binlog日志,错误日志,慢查询日志常开
    ~]# vim /etc/mysqld
     <--------------------------------------------
     [mysqld]
     general-log               #启用查询日志
     --------------------------------------------> 
    ~]# systemctl restart mysqld
    ~]# cat /var/lib/mysql/主机名.log

##################################################################################
调优思路总结
手段                       具体操作
升级硬件                   CPU 、内存、硬盘
加大网络带宽               付费加大带宽
调整mysql服务运行参数    并发连接数、连接超时时间、重复使用的线程数........
调整与查询相关的参数      查询缓存、索引缓存.......
启用慢查询日志            slow-query-log
网络架构不合理            调整网络架构    #如果只有一台读写分离服务器(中间件)，增加中间件服务器
#看看视频，上午120分钟


























































































































































