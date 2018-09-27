NoSQL_day2

1.转被6台redis服务器，并制定服务使用的ip地址和端口号

2.创建集群
2.1部署集群环境
2.2创建集群
2.2.1部署管理主机(51及提供数据存储服务又做管理主机)
ruby shell python perl lua

2.3查看集群信息

3.工作过程
3.1存储数据的工作过程
3.2查看数据的工作过程
3.3使用集群存储和查看数据

4.管理集群
4.1项集群里添加新主机
4.2从集群里删除主机

##################################################################################
配置Redis集群环境
●安装并运行redis服务------------6台主机
写了脚本：redis_create.sh
  ]# yum -y install gcc gcc-c++
  ]# tar -zxvf redis-4.0.8.tar.gz
  ]# cd redis-4.0.8/
  ]# make
  ]# make install
  ]# ./utils/install_server.sh

●调整配置文件------------6台主机
写了脚本：redis_cluster_conf.sh
  ]# vim /etc/redis/redis.conf
  ：set nu
  70:bind IP地址                      //只写物理接口IP地址
  93:port 6351                  //端口号不要使用默认的6379
  137:daemonize yes             //守护进程方式运行  
  815:cluster-enabled yes       //启用集群
  823:cluster-config-file nodes-6351.conf 
                                         //指定集群信息文件，即cluster nodes查看到的信息   
  829:cluster-node-timeout 5000     //请求超时 5 秒

●查看服务信息------------6台主机
  ~]# /etc/init.d/redis_6379 status
  Redis is running (21201)
  ~]# netstat -utnlp | grep redis-server 192.168.4.51:6351
  21201/redis-server 0.0.0.0:* LISTEN   192.168.4.51:16351   #集群服务端口号+10000

●查看配置集群后的文件------------6台主机
  [root@redis53 ~]# ls /var/lib/redis/6379/  
  dump.rdb  nodes-6353.conf
##################################################################################
创建集群前 
●查看集群信息
  > cluster info //查看集群信息
  > cluster nodes //查看集群节点信息

  [root@host51 ~]# redis-cli -h 192.168.4.51 -p 6351
  192.168.4.50:6350> cluster info
  cluster_state:fail
  cluster_slots_assigned:0
  cluster_slots_ok:0
  cluster_slots_pfail:0
  cluster_slots_fail:0
  cluster_known_nodes:1
  cluster_size:0
  .....
  192.168.4.50:6350>
  
●查看节点信息
   192.168.4.50:6350> cluster nodes
   e081313ec843655d9bc5a17f3bed3de1dccb1d2b
   192.168.4.50:6350@16350 myself,master - 0 1530781129976 11   
   connected        #每一台主机启用集群功能后，都时主库
   192.168.4.50:6350>

##################################################################################
创建集群
●部署管理主机51
  +在选中的一台redis服务器上,执行创建集群脚本
  – 部署ruby脚本运行环境
  – 创建集群
  ]# yum -y install ruby rubygems       
  ]# rpm -ivh --nodeps ruby-devel-2.0.0.648-30.el7.x86_64.rpm #yum源没有
  ]# gem install redis-3.2.1.gem  #yum源没有

●补充知识rubygem
  – RubyGems（简称 gems）是一个用于对 Ruby组件进行打包的 Ruby 打包系统。 
  – 它提供一个分发 Ruby 程序和库的标准格式，还提供一个管理程序包安装的工具

●部署创建集群脚本
  真机操作]# pssh -h host.txt "cp redis-4.0.8/src/redis-trib.rb /usr/bin/"

●创建集群，用ruby脚本
 +操作
   [root@host51 ~]# redis-trib.rb create --replicas 1 \  
    192.168.4.51:6351 192.168.4.52:6352 \
    192.168.4.53:6353 192.168.4.54:6354 \
    192.168.4.55:6355 192.168.4.56:6356     
   >>> Creating cluster
   >>> Performing hash slots allocation on 6 nodes...
   Using 3 masters:            
    192.168.4.51:6351
    192.168.4.52:6352
    192.168.4.53:635
    .. ..
   [OK] All 16384 slots covered.
   
 +说明：
  & 选项 --replicas 1     #指定每一台主库有1个从库
  & 主库的个数必须是奇数；
  & 主库个数至少3个；
  & 例子：若 --replicas 4，则需要有服务器台数 3+4*3=15(台)
  
+创建redis集群常见错误
 &数据库不为空
  [ERR] Node 192.168.4.51:6351 is not empty.
 &数据库槽的状态为忙
  ERR Slot 9678 is already busy (Redis::CommandError)
   
 &处理方法---------每个库都执行,或者错误库执行
   >flushall
   >cluster reset
##################################################################################   
创建集群后
●查看集群信息  
  192.168.4.51:6351> cluster info
  cluster_state:ok
  cluster_slots_assigned:1638
  cluster_slots_ok:16384
  cluster_slots_pfail:0
  cluster_slots_fail:
  cluster_known_nodes:6
  cluster_size:3
  cluster_current_epoch:6
  cluster_my_epoch:1   
●查看节点信息  
  192.168.4.51:6351> cluster nodes  #以下给出 主52，从56的信息
 主： 52主库UID 192.168.4.52:6352@16352 master - 0 1537931125000 2 connected 5461-10922

 从： 56从库UID 192.168.4.56:6356@16356 slave 52主库UID 0 1537931125650 6 connected
●查看主从状态 
  [root@redis51 ~]# redis-trib.rb check -h 192.168.4.51 -p 6351
##################################################################################
初步测试集群
●写入数据测试
  [root@redis52 ~]# redis-cli -h 192.168.4.52 -p 6352 -c
  192.168.4.52:6352> set name52 jack
  -> Redirected to slot [4232] located at 192.168.4.51:6351
  OK
  192.168.4.51:6351>
  
  [root@redis51 ~]# redis-cli -h 192.168.4.51 -p 6351 -c
  192.168.4.51:6351> keys *
  1) "name52"
  

##################################################################################  
工作过程\原理
●槽位(slot)
  +槽位号范围 0~16384 
  +作用：决定存储客户端数据的主库
  +计算
   1. key值与crc16 做 hash7运算，得出一个值，再与16384做求模
    2.再匹配槽号锁在数据库
 
●redis集群的特点
  &连接redis使用-c参数来启动集群模式
  &从库不允许执行set,get;(若执行，会自动切换到其他主库执行)
  &每个主库的数据不一致，从库同步主库数据；分布式存储的特点
  &任意主库down机，对应从库会升级为主库
  缺点：
  &当主库及其下的所有从库故障后，redis集群就不能工作

##################################################################################
管理redis集群
●redis-cli命令
  • 查看命令帮助
    redis-cli -h
  • 常用选项
    -h IP地址
    -p 端口
    -c 集群模式

●redis-trib.rb脚本
 • 语法格式
   redis-trib.rb 选项 参数
 • 选项
   add-node    #添加master主机
   check       #检测集群
   reshard     #新分片
   add-node --slave  #添加slave主机
   del-node    #删除主机
   
●语法格式   
 +添加master主机格式  #不指定时，默认添加为主库
   redis-trib.rb add-node 新主机Ip:端口  集群中存在的主机IP：端口
 +重新分片(交互的)
   redis-trib.rb reshard 192.168.4.51:6351
    – 指定移出hash槽个数  
    – 指定接收上述hash槽主机ID
    – 指定移出hash槽主机ID
 +添加slave主机     #不指定主库ID，则自动作为从库最少主库的从库；相等则随机
   redis-trib.rb add-node --slave [ --master-id id值 ]
    集群中存在的主机IP：端口   
 +移除slave主机
   redis-trib.rb del-node slave主机IP:端口 本机id值
 +移除master主机(需要释放所有的hash槽)
   redis-trib.rb reshard master主机IP:端口
   redis-trib.rb del-node master主机IP:端口 本机id值

##################################################################################
管理redis集群   
●查看集群状态    
   ~]# redis-trib.rb check 192.168.4.51:6351
 >>> Performing Cluster Check (using node 192.168.4.51:6351)
 M: 922fb66c00e6c4ddff5c93f5c9c3d4c612e62a95 192.168.4.51:6351
   slots:0-5460 (5461 slots) master
   1 additional replica(s)
  S: 96c3d3d1d7a51ab17e954f0b3589ba39bf38854b 192.168.4.55:6355
   slots: (0 slots) slave
   replicates 922fb66c00e6c4ddff5c93f5c9c3d4c612e62a95
  M: eea9a06fbb35d00dcefb29f6c972d430fb578cad 192.168.4.52:6352
   slots:5461-10922 (5462 slots) master
   1 additional replica(s)
  M: cb151776058029a2429a76c292c924445bd01511 192.168.4.54:6354
   slots:10923-16383 (5461 slots) master
   0 additional replica(s)
  S: ae51714804c3b2abf7700cf44743d8adb585334d 192.168.4.56:6356
   slots: (0 slots) slave
   replicates eea9a06fbb35d00dcefb29f6c972d430fb578cad
  .. ..
  .. ..
##################################################################################  
管理redis集群
●添加master新主机，并重新分片                             
 1）添加master角色主机：192.168.4.50  #需要配置redis集群环境；见下文配置        
    [root@redis51 ~]# redis-trib.rb check 192.168.4.51:6351  #查看到50称为主库
     .. ..
    M: 655018946f420401090f55db13e1a62a8aa4c1e2 192.168.4.50:6350
    slots: (0 slots) master      #当前hash槽数位0；还不能够存储数据
    0 additional replica(s)
    .. ..
    [OK] All 16384 slots covered.
 2）分配分片到主机：192.168.4.50
  [root@redis51 ~]# redis-trib.rb reshard 192.168.4.51:6351
  .. ..
  .. ..
  M: 655018946f420401090f55db13e1a62a8aa4c1e2 192.168.4.50:6350
     slots: (0 slots) master   
     0 additional replica(s)
  .. ..
  .. ..
  How many slots do you want to move (from 1 to 16384)? 4096  #指定移出槽数
  .. ..
  What is the receiving node ID? 
  655018946f420401090f55db13e1a62a8aa4c1e2 #指定接收主机ID
  .. ..
  Source node #1:all  #all:指定从所有集群中主机移出上述槽数;
                      #done:指定从某主机移出上述槽数；例子如下：
                      //Source node #1:移出上述槽数主机的ID号
                      //Source node #2:done                       
  
  Ready to move 4096 slots.
  .. ..
  .. ..
##################################################################################
管理redis集群
●添加新slave主机 
  添加 192.168.4.57 （需要搭建redis集群环境）
  [root@redis51 ~]# redis-trib.rb add-node --slave 192.168.4.57:6357 192.168.4.51:6351
  .. ..
  Automatically selected master 192.168.4.50:6350
  .. ..
  [OK] New node added correctly.

  [root@redis51 ~]# redis-trib.rb check 192.168.4.51:6351  #看到57成为50的从库
  .. ..
 S: 5efd7b2b848a39e48c4fa2cac9c8b67199747ae7 192.168.4.57:6357
   slots: (0 slots) slave
   replicates 655018946f420401090f55db13e1a62a8aa4c1e2
   .. ..
 M: 655018946f420401090f55db13e1a62a8aa4c1e2 192.168.4.50:6350
   slots:0-1364,5461-6826,10923-12287 (4096 slots) master
   1 additional replica(s)
##################################################################################
管理redis集群
●移除slave主机
  [root@redis51 ~]# redis-trib.rb del-node 192.168.4.57:6357 \
  5efd7b2b848a39e48c4fa2cac9c8b67199747ae7  #对应57ID
●移除master主机   #再整理笔记，从终端复制过来
  先释放占用hash槽
  再移除
##################################################################################  
扩展
##################################################################################
恢复master主机
步骤1：
复位集群--------->cluster reset
    [root@redis50 ~]# redis-cli  -h 192.168.4.50 -p 6350
    192.168.4.50:6350> cluster info
    cluster_state:ok  #依然是ok状态；#因此50本机依然认为自己是集群中的一员；
      #需要做复位操作，才能重新添加50到集群中
    192.168.4.50:6350> cluster reset    #核心步骤
    OK

步骤2：
在管理主机51添加主机50
     参考上述添加master主机步骤(add-node reshard)
##################################################################################     
恢复slave主机
步骤1：
   192.168.4.57:6357> cluster reset
步骤2：
    参考上述添加slave主机步骤(add-node --slave)
##################################################################################
恢复成单独的redis服务器
1.从集群中移除主机
2.复原配置文件 815 823 829 行
3.删除集群信息文件 /var/lib/redis/6379/node-xxxx.conf




























