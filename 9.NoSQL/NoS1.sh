NoSQL数据库管理 DAY01
1.NoSQL概述
2.部署Redis服务
3.部署LNMP+Redis
4.扩展
  4.1 LAMP+Redis
   4.2 多主机访问Redis
##################################################################################
NoSQL概述
●RDBMS
 +关系数据库管理系统
 +按照预先设置数据存储结构,将数据存储在物理介质上
 +数据之间可以做关联操作
 +MySQL，Oracle，DB2，SQL Server，MariaDB
 
●NoSQL
 +NoSQL(NoSQL = Not Only SQL)
 +意思是“不仅仅是SQL”
 +泛指非关系型数据库
 +不需要预先定义数据存储结构
 +表的每条记录都可以有不同的类型和结构
 +Redis,MongoDB,Memcached,CouchDB,Neo4j,FLockDB
 
●生产中的web数据库拓扑结构 

 client 
    |
 Redis(内存存储服务器)
    |  
  Web
    |
 MongoDB,MySQL
 
说明：1.生产中，程序员需要把常访问的数据放到内存数据库服务器上;
      2.若内存存储的数据没有目标数据，则到硬盘上寻找数据(MongoDB,MySQL);
     3.MongoDB不需要预先设置数据存储结构，MySQL需要
##################################################################################
Redis服务
●Redis介绍(开源)
 +Remote Dictionary Server(远程字典服务器)
 +是一款高性能的分布式内存数据库(key-values) 
                 #分布式：把数据存储在不同地点的不同服务器
 +支持数据持久化，把存储在内存的数据定期保存到硬盘
 +支持list,hash,set,zset数据类型
 +支持主从复制
 +支持集群(集群：多台服务器运行相同服务)
 +用c语言编写的

 中文网站www.redis.cn 
################################################################################## 
部署Redis服务
#在50上搭建
●装包
  +安装依赖包
    ~]# yum -y install gcc gcc-c++
  +解包
    ~]# tar -xf redis-4.0.8.tar.gz
  +编译
    redis-4.0.8]# cd redis-4.0.8/
    redis-4.0.8]# make && make PREFIX=/data/redis/ MALLOC=libc install

●初始化设置
  redis-4.0.8]# ./utils/install_server.sh      #全部默认   
 Port           : 6379                         #Redis端口号
 Config file    : /etc/redis/6379.conf         #Redis主配置文件
 Log file       : /var/log/redis_6379.log      #Redis的日志文件
 Data dir       : /var/lib/redis/6379          #Redis的数据库目录
 Executable     : /usr/local/bin/redis-server  #Redis的启动程序程序
 Cli Executable : /usr/local/bin/redis-cli     #连接Redis的命令程序
 
●查看服务状态redis-server
 +netstat    
  ]# netstat -utnlp | grep :6379
  tcp  0  0 127.0.0.1:6379   0.0.0.0:*   LISTEN   6823/redis-server 1
  #默认只能本地连接 
 +脚本查看
  ]# /etc/init.d/redis_6379 status
  Redis is running (6823)
  
●启停服务 
  ~]# /etc/init.d/redis_6379 stop
  ~]# /etc/init.d/redis_6379 start
 
●连接服务 
 [root@mysql50 ~]# redis-cli 
 127.0.0.1:6379> ping
 PONG                         #收到pong就成功
##################################################################################
Redis数据管理

●Redis有补全与提示的功能

●基础命令  
 set keyname keyvalue #存储
 get keyname          #获取
 select 数据库编号0-15   #切换库
 keys *               #打印所有变量
 keys a?              #打印指定变量
 exists keyname       #测试是否存在；
 ttl keyname          #查看生存时间
 type keyname         #查看类型,默认都是string
 move keyname dbname  #移动变量到别的库
 expire keyname 10    #设置有效时间，秒
 del keyname          #删除变量
 flushall             #删除所有变量
 flushdb              #删除当前库下的变量
 save                 #保存所有变量,到硬盘
 shutdown             #关闭redis服务
 
+例子：
 127.0.0.1:6379> set age 9
 OK
 127.0.0.1:6379> get age
 "9"
 127.0.0.1:6379> keys *           #查看所有已有变量
 1) "age"
 127.0.0.1:6379> set age 19       #覆盖原来的值
 OK
 127.0.0.1:6379> get age
 "19"
 127.0.0.1:6379> select 2         #切换库2
 OK 
 127.0.0.1:6379[2]> ttl b
 (integer) -1                     #ttl值含义 -1：永久有效； 1：有效剩余时间； -2：过期
 127.0.0.1:6379[2]> expire b 10
 (integer) 1
 127.0.0.1:6379[2]> ttl b
 (integer) -2
 127.0.0.1:6379> flushall
  OK
 127.0.0.1:6379> keys *
 (empty list or set) 
 127.0.0.1:6379> keys a???        #keys 可以使用通配符
 1) "ayyb"
 127.0.0.1:6379> exists a
 (integer) 0
 127.0.0.1:6379> exists bbaa
 (integer) 1
################################################################################## 
配置文件解析
常用配置选项
– port 6379         //端口
– bind 127.0.0.1    //IP地址
– tcp-backlog 511   //tcp连接总数
– timeout 0         //连接超时时间
– tcp-keepalive 300 //长连接时间
– daemonize yes     //守护进程方式运行
– databases 16      //数据库个数
– logfile /var/log/redis_6379.log //日志文件
– maxclients 10000  //并发连接数量
– dir /var/lib/redis/6379 //数据库目录
##################################################################################
常用配置选项
– port 6379 //端口
– bind 127.0.0.1 //IP地址

●修改连接地址，端口号 
 vim /etc/redis/6379.conf
<----------------------------------------------
 70 bind 192.168.4.50
 93 port 6350 
 ----------------------------------------------->  
●修改上述内容后连接redis服务
  ~]# /etc/init.d/redis_6379 stop
  ~]# /etc/init.d/redis_6379 start
  ~]# redis-cli -h 192.168.4.50 -p 6350   #指定ip，端口
  192.168.4.50:6350> ping
  PONG  
●redis-cli
  ~]# redis-cli --help
  redis-cli 4.0.8
  
  Usage: redis-cli [OPTIONS] [cmd [arg [arg ...]]]
  -h <hostname>      Server hostname (default: 127.0.0.1).
  -p <port>          Server port (default: 6379).
  -s <socket>        Server socket (overrides hostname and port).
  -a <password>      Password to use when connecting to the server.
●修改ip，端口后，停止redis  #直接运行脚本会报错
  +命令行：
    ~]# /etc/init.d/redis_6379 stop
    Stopping ...
    Could not connect to Redis at 127.0.0.1:6379: Connection refused
        
    ~]# redis-cli -h 192.168.4.50 -p 6350 shutdown
  
  +修改脚本：
    ~]# vim /etc/init.d/redis_6379
    <-------------------------------------------------------------------------------------------------
    43           $CLIEXEC -h 192.168.4.50 -p 6350 shutdown
    -------------------------------------------------------------------------------------------------->
    ~]# /etc/init.d/redis_6379 stop
    Stopping ...
    Redis stopped
 
################################################################################## 
其他常用配置选项
● ~]# vim /etc/redis/6379.conf
  <---------------------------------------------------------
  102 tcp-backlog 511          #tcp等待连接总数(进入accpet队列前的数量)
  114 timeout 0                #连接超时时间
  131 tcp-keepalive 300        #检查状态周期
  137 daemonize yes            #守护进程方式运行
  172 logfile /var/log/redis_6379.log  #日志文件
  187 databases 16             #数据库个数
  264 dir /var/lib/redis/6379  #数据库目录
  533 # maxclients 10000       #并发访问量，默认注释  
  ----------------------------------------------->
●数据库目录 
  ~]# ls /var/lib/redis/6379
  dump.rdb   #所有Redis数据都存在这个文件
################################################################################## 
常用配置选项
内存清除策略
●内存清除策略
– volatile-lru              #删除最近最少使用 (针对设置了TTL的key)
– allkeys-lru               #删除最少使用的key
– volatile-random           #在设置了TTL的key里随机移除
– allkeys-random            #随机移除key
– volatile-ttl (minor TTL)  #移除最近过期的key
– noeviction                #不删除,写满时报错 
 
●定义使用策略
  ~]# vim /etc/redis/6379.conf
  <-------------------------------------------------------------
  560 # maxmemory <bytes>             #最大内存
  591 # maxmemory-policy noeviction   #定义使用策略
  602 # maxmemory-samples 5           #模版个数；最接近样本的数据删除 (针对lru 和 ttl 策略)
   ------------------------------------------------------------->
●  
  12 # 1k => 1000 bytes
  13 # 1kb => 1024 bytes
  14 # 1m => 1000000 bytes
  15 # 1mb => 1024*1024 bytes
  16 # 1g => 1000000000 bytes
  17 # 1gb => 1024*1024*1024 bytes
   
################################################################################## 
设置连接密码
●交互式密码连接redis服务 
  ~]# grep -n requirepass /etc/redis/6379.conf
      501 # requirepass 123456      
  ~]# /etc/init.d/redis_6379 restart
  ~]# redis-cli -h 192.168.4.50 -p6350 
   127.0.0.1:6379> ping
  (error) NOAUTH Authentication required.
   127.0.0.1:6379> auth 123456   #输入密码
   OK
   127.0.0.1:6379> ping
   PONG
●非交互密码连接   
  ~]# redis-cli -h 192.168.4.50 -p6350 -a 123456 #非交互输入密码
●停服务
  +命令行
    ~]# redis-cli -h 192.168.4.50 -p 6350 -a 123456 shutdown
  +修改脚本
    ~]# vim /etc/init.d/redis_6379  
    43     $CLIEXEC -h 192.168.4.50 -p 6350 -a 123456 shutdown
 
################################################################################## 
部署LNMP+Redis
 
●192.168.4.51主机上部署LNMP

 +测试脚本，查看php所有的信息
  
   ~]# cat /usr/local/nginx/html/index.php 
     <?php
     phpinfo();
      ?>
   ~]# firefox 192.168.4.51/index.php
  
●配置网站服务器51，把数据存储到本机的redis数据库里 
 +检查php支持的模块，是否包含redis
   ~]# php -m | grep redis
   ~]# php -m | grep mysql
   mysql
   mysqli
   pdo_mysql
 +装包
    1）安装依赖包
      ~]# yum -y install autoconf automake
      lnmp_soft]# yum -y install php-devel    #需要自己下载
    2）安装源码包
     & 解包
      ~]# tar -xf php-redis-2.2.4.tar.gz 
      ~]# cd phpredis-2.2.4/
     & 配置源码包
     ]# ls /usr/bin/php-config
       /usr/bin/php-config
     ]# phpize             #phpize是用来扩展php扩展模块的，
                                   #通过phpize可以建立php的外挂模块 
     ]# ./configure \
       --with-php-config=/usr/bin/php-config && make && make install
     & 查看redis模块 
     ]# ls /usr/lib64/php/modules/ | grep redis
       redis.so
     ]# php -m | grep redis
       redis
       
 +配置&&起服务
   ~]# vim /etc/php.ini    #修改php主配置文件，加载redis模块
     <----------------------------------------------------------------------------------
    728 extension_dir = "/usr/lib64/php/modules/"   #指定redis模块路径
    730 extension = "redis.so"                      #指定redis模块名
     ------------------------------------------------------------------------------------>
   ~]# systemctl restart php-fpm
   ~]# firefox localhost/index.php                   #查看php信息
 +测试，编写测试脚本
   ~]# vim /usr/local/nginx/html/redis.php
      <---------------------------------------------------------------
      <?php
      $redis = new redis();
      $redis->connect('127.0.0.1',6379);
      $redis->set("a","123456789");
      echo $redis->get("a");
      echo "\n";
        ?>
      ------------------------------------------------------------------>
  ~]# curl localhost/redis.php
      123456789
##################################################################################       
扩展
################################################################################## 
案例1：
主机51搭建LNMP
主机50搭建redis
在51编写php网页脚本，把数据存储在50的redis数据库上

●测试脚本
 ~]# vim /usr/local/nginx/html/redis2.php
   <?php
    $redis = new redis();
    $redis->connect("192.168.4.50",6350);
    $redis->auth("123456");                 #密码
    $redis->set("a","87777");
    echo $redis->get("a");
    echo "\n";
   ?>
 ~]# curl localhost/redis2.php
  87777
################################################################################## 
案例2： 
配置LAMP+Redis 网站运行平台
配置php与redis连接，参考上述"部署LNMP+redis"
]# vim /var/www/html/index.php 脚本与上述类似
]# curl localhost/index.php
   5050 
################################################################################## 
案例3： 
配置50主机的redis服务满足
1）接收本机也可以接收其他主机的连接请求并且
2）连接时要输入连接密码123456 
●50主机修改配置文件&&起服务
  ~]# vim /etc/redis/6379.conf
  <------------------------------------------------------
  70 bind 192.168.4.50 127.0.0.1     #核心步骤
  93 port 6350
  501 requirepass 123456 
  ------------------------------------------------------>
  ~]# /etc/init.d/redis_6379 restart

  ~]# netstat -utnlp | grep redis
  tcp   0  0 127.0.0.1:6350     0.0.0.0:*   LISTEN    18723/redis-server  
  tcp   0  0 192.168.4.50:6350  0.0.0.0:*   LISTEN    18723/redis-server
●50，51主机分别在原有的LAMP，LNMP基础上，书写测试脚本,并访问页面

-----------------50---------------------------
~]# cat /var/www/html/test1.php 
<?php
  $redis = new redis();
  $redis->connect("127.0.0.1",6350);
  $redis->auth("123456");
  $redis->set("loc","505050");
  echo $redis->get("loc");
  echo "\n";
?>
[root@mysql50 ~]# curl localhost/test1.php
505050
---------------------------------------------------

-----------------51----------------------------
~]# cat /usr/local/nginx/html/redis3.php
<?php
$redis = new redis();
$redis->connect("192.168.4.50",6350);
$redis->auth("123456");
$redis->set("remote","515151");
echo $redis->get("remote");
echo "\n";
?> 
~]# curl localhost/redis3.php
515151
------------------------------------------------ 

●50本机查看变量
  192.168.4.50:6350> keys *
  1) "loc"
  2) "remote"
  192.168.4.50:6350> get loc
  "505050"
  192.168.4.50:6350> get remote
  "515151" 
 
 
 
 
 

















 
