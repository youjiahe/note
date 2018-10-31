大型架构及配置技术
NSD ARCHITECTURE  DAY07

1.常用组件
  1.1 Zoopkeeper
2.
##################################################################################
常用组件
● Zookeeper
  & 什么是Zookeeper
    Zookeeper是一个开源的分布式应用程序协调服务
    
  & Zoopkeeper能做什么？
    Zoopkeeper是用来保证数据在集群间的事务一致性  
    #事务：
    #一系列相关联的操作，事情；
    #包括从开始到结束的所有操作；
    
  & Zoopkeeper应用场景
     — 集群分布式锁      #保证操作的一致性
     — 集群统一命名服务  
     — 分布式协调服务
   
● 使用锁的目的
   — 保证共享资源在同一时间只有只有一个客户端对共性资源进行操作，
   — 在高并发的环境下保证同一时间只有一个线程操作共享数据，  
   — 提升效率     #采取锁定可以避免不必要的执行相同的工作
   — 提升正确性   #采取锁可以更好的规范排列线程之间的关系

● 分布式锁设计原则
     1. 互斥性，同一时间只有一个线程持有锁
     2. 容错性，即使某一个持有锁的线程，异常退出，其他线程仍然可以获得锁
     3. 隔离性，线程只能解自己的锁不能解其他线程的锁
##################################################################################
● 角色与特性
 & Zookeeper角色与特性
   – Leader:接受所有Follower的提案请求并统一协调发起
               提案的投票,负责不所有的Follower迚行内部数据交换
   – Follower:直接为客户端服务并参不提案的投票,同时
                  与Leader迚行数据交换
   – Observer:直接为客户端服务但并不参与提案的投票,
                  同时也与Leader进行数据交换

● 角色与选举
 & Zookeeper角色与选举
      – 服务在启动的时候是没有角色的(LOOKING)
      – 角色是通过选举产生的
      – 选举产生一个Leader,剩下的是Follower
 & 选举Leader原则
      – 集群中超过半数机器投票选择Leader
      – 假如集群中拥有n台服务器,那么Leader必须得到
        n/2+1台服务器的投票

 & Zookeeper角色与选举特点  #集群数量最好是奇数
      – 如果Leader死亡,重新选举Leader
      – 如果死亡的机器数量达到一半,则集群挂掉
      – 如果无法得到足够的投票数量,就重新发起投票,如
         果参与投票的机器不足n/2+1,则集群停止工作  #反正就是达到一半就down集群
      – 如果Follower死亡过多,剩余机器不足n/2+1,则集
         群也会停止工作
     – Observer不计算在投票总设备数量里面
##################################################################################
Zookeeper原理与设计
● Zookeeper可伸缩扩展性原理与设计
   – Leader所有写相关操作
   – Follower读操作不响应Leader提议
   – 在Observer出现以前,Zookeeper的伸缩性由Follower
      来实现,我们可以通过添加Follower节点的数量来保证
     Zookeeper服务的读性能,但是随着Follower节点数量
      的增加,Zookeeper服务的写性能受到了影响

  – 客户端提交一个请求,若是读请求,则由每台Server的本地
     副本数据库直接响应。若是写请求,需要通过一致性协议
    (Zab)来处理

  — 因为Leader节点必须等待集群中过半Server响应投票,
     是节点的增加使得部分计算机运行较慢,从而拖慢整个投
     票过程的可能性也随之提高,随着集群变大,写操作也会随之下降
     
  — 所以,我们不得不在增加Client数量的期望和我们希望保
      持较好吞吐性能的期望间进行权衡。要打破这一耦合关系,
     我们引入了不参与投票的服务器Observer。
     
● Observer   
  — Observer可以接受客户端的连接,并将写请求转发给Leader节点。但
    Leader节点不会要求Observer参加投票,和其他服务节点一起得到投票结果
  – Observer的扩展,给Zookeeper的可伸缩性带来了全新的景象。
     加入许多Observer节点,无须担心严重影响写吞吐量。
  – Observer提升读性能的可伸缩性
  – Observer提供了广域网能力
##################################################################################
Zookeeper集群
• Zookeeper集群的安装配置

 & 配置文件改名zoo.cfg
    [root@nn01 ~]# cd /usr/local/zookeeper/conf/
    [root@nn01 ~]# mv zoo_sample.cfg zoo.cfg
    
 & zoo.cfg文件最后添加如下内容   #同步/usr/local/zookeeper 到所有节点
    server.1=node1:2888:3888
    server.2=node2:2888:3888
    server.3=node3:2888:3888
    server.4=hann1:2888:3888:observer
    
 & 创建datadirz指定的目录
   [root@nn01 ~]# pssh -h hosts.txt "mkdir /tmp/zookeeper"
   [1] 18:44:20 [SUCCESS] 192.168.1.102
   [2] 18:44:20 [SUCCESS] 192.168.1.103
   [3] 18:44:20 [SUCCESS] 192.168.1.101
   [4] 18:44:20 [SUCCESS] 192.168.1.100 #这是nn01
 
 & 设置myid文件 
   [root@nn01 ~]# ssh node1 'echo 1 > /tmp/zookeeper/myid'
   [root@nn01 ~]# ssh node2 'echo 2 > /tmp/zookeeper/myid'
   [root@nn01 ~]# ssh node3 'echo 3 > /tmp/zookeeper/myid'
   [root@nn01 ~]# ssh nn01 'echo 4 > /tmp/zookeeper/myid'

 & 启动zookeeper  
  [root@node1 ~]# /usr/local/zookeeper/bin/zkServer.sh start
  [root@node2 ~]# /usr/local/zookeeper/bin/zkServer.sh start
  [root@node3 ~]# /usr/local/zookeeper/bin/zkServer.sh start 
  
 & 查看状态 
 [root@node1 ~]# /usr/local/zookeeper/bin/zkServer.sh  status
  ZooKeeper JMX enabled by default
  Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
  Mode: follower
  
 [root@node2 ~]# /usr/local/zookeeper/bin/zkServer.sh status
  Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
  Mode: leader 

 [root@node3 ~]# /usr/local/zookeeper/bin/zkServer.sh status
  ZooKeeper JMX enabled by default
  Using config: /usr/local/zookeeper/bin/../conf/zoo.cfg
  Mode: follower
 
################################################################################## 
管理zookeeper
●  Zookeeper管理文档
 http://zookeeper.apache.org/doc/r3.4.10/zookeeperAdmin.html
● 常用命令 
 conf  #查看节点配置
 ruok  #are you ok？
 stat  #查看节点状态

● 管理方式
  telnet node1 2181
  nc node1 2181
  文件描述符+网络重定向  
   // exec 7<>/dev/tcp/192.168.1.101/2181
   // echo 'stat' >&7   && cat <&7 | grep "^Mode:"
################################################################################## 
● Kafka    #自己上网搜资料
 & Kafka是什么
  – Kafka是由LinkedIn开发的一个分布式的消息系统
  – Kafka是使用Scala编写
  – Kafka是一种消息中间件
 & 为什么要使用Kafka
  – 解耦、冗余、提高扩展性、缓冲
  – 保证顺序,灵活,削峰填谷
  – 异步通信
  
● Kafka角色
 & Kafka角色与集群结构
   – producer:生产者,负责发布消息
   – consumer:消费者,负责读取处理消息
   – topic:消息的类别
   – Parition:每个Topic包含一个或多个Partition
   – Broker:Kafka集群包含一个或多个服务器
 & Kafka通过Zookeeper管理集群配置,选举Leader
 
• Kafka角色与集群结构 
##################################################################################
 
 
 
查看topic
.bin/kafka-topics.sh --list --zookeeper localhost:2181  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

















