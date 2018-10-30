大型架构及配置技术
NSD ARCHITECTURE  DAY05
1.大数据
2.Hadoop
3.Hadoop安装与配置
4.HDFS

##################################################################################
● 大数据的由来
• 大数据
– 随着计算机技术的发展,互联网的普及,信息的积累
   已经到了一个非常庞大的地步,信息的增长也在不断
   的加快,随着互联网、物联网建设的加快,信息更是
   爆炸式增长,收集、检索、统计这些信息越发困难, 
   必须使用新的技术来解决这些问题

● 什么是大数据
• 大数据的定义
– 大数据指无法在一定时间范围内用常规软件工具进行捕捉、
   管理和处理的数据集合,需要新处理模式才能更好处理管理的信息资产

• 大数据能做什么
– 企业组织利用相关数据分析帮助他们降低成本、提高
   效率、开发新产品、做出更明智的业务决策等
– 把数据集合并后进行分析得出的信息和数据关系性,
   用来察觉商业趋势、判定研究质量、避免疾病扩散、
   打击犯罪或测定即时交通路况等
– 大规模并行处理数据库,数据挖掘电网,分布式文件
   系统或数据库,云计算平和可扩展的存储系统等

● 大数据特性
• 大数据的5V特性是什么?
– (V)olume (大量)
   可从数百TB到数十数百PB、甚至EB的规模
– (V)ariety(多样性)
   大数据包括各种格式和形态的数据
– (V)elocity(时效性)
   很多大数据需要在一定的时间限度下得到及时处理
– (V)eracity(准确性)
   处理的结果要保证一定的准确性
– (V)alue(大价值)
   大数据包含很多深度的价值,大数据分析挖掘和利用将带来巨大
   的商业价值

● 大数据与Hadoop
• Hadoop是什么
  – Hadoop是一种分析和处理海量数据的软件平台
  – Hadoop是一款开源软件,使用JAVA开发
  – Hadoop可以提供一个分布式基础架构
• Hadoop特点
  – 高可靠性、高扩展性、高效性、高容错性、低成本
##################################################################################
Hadoop

   Hadoop历史起源 Hadoop起源
   Hadoop组件 Hadoop常用组件
   Hadoop核心组件
   Hadoop生态系统
   HDFS结构
   HDFS角色及概念
   MapReduce结构
   MapReduce结构及概念
   Yarn结构
   Yarn角色及概念
##################################################################################
Hadoop起源
• 2003年开始Google陆续发表了3篇论文
  – GFS,MapReduce,BigTable
• GFS
  – GFS是一个可扩展的分布式文件系统,用于大型的、分布式
     的、对大量数据进行访问的应用
  – 可以运行于廉价的普通硬件上,提供容错功能
• MapReduce
  – MapReduce是针对分布式并行计算的一套编程模型,由
    Map和Reduce组成,Map是映射,把指令分发到多个
    worker上,Reduce是规约,把worker计算出的结果合并

• BigTable
  – BigTable是存储结构化数据
  – BigTable建立在GFS,Scheduler,Lock Service和
    MapReduce之上
  – 每个Table都是一个多维的稀疏图

##################################################################################
● Hadoop历史起源
• GFS、MapReduce和BigTable三大技术被称为
  Google的三驾马车,虽然没有公布源码,但发布了
  这三个产品的详细设计论
• Yahoo资助的Hadoop,是按照这三篇论文的开源
  Java实现的,但在性能上Hadoop比Google要差很多
  – GFS - - -> HDFS
  – MapReduce - - -> MapReduce
  – BigTable - - -> Hbase

● Hadoop常用组件(三大核心组件)
  • HDFS:Hadoop分布式文件系统(核心组件)
  • MapReduce:分布式计算框架(核心组件)
  • Yarn:集群资源管理系统(核心组件)
  • Zookeeper:分布式协作服务(运维组件)
  • Flume:日志收集工具(运维组件)
##################################################################################
HDFS
● HDFS结构
  
● HDFS角色及概念(续1)
• Hadoop体系中数据存储管理的基础,是一个高度容
   错的系统,用于在低成本的通用硬件上运行
• 角色和概念
  – Client
  – Namenode
  – Secondarynode
  – Datanode

• NameNode
  – Master节点,管理HDFS的名称空间和数据块映射表
     息,配置副本策略,处理所有客户端请求
• Secondary NameNode
  – 定期合并fsimage 和fsedits,推送给NameNode  #fsedits 是文件系统日志文件
     定期合并日志，变更fsimage
  – 紧急情况下,可辅助恢复NameNode
  • 但Secondary NameNode并非NameNode的热备
• DataNode
  – 数据存储节点,存储实际的数据
  – 汇报存储信息给NameNode
• client
  – 切分文件
  – 访问HDFS
  – 与NameNode交互,获取文件位置信息
  – 与DataNode交互,读取和写入数据

• Block
  – 每块缺省64MB大小
  – 每块可以多个副本
##################################################################################
MapReduce
● 结构
• 源自于Google的MapReduce论文,JAVA实现的分
  布式计算框架
• 角色和概念
  – JobTracker
  – TaskTracker
  – Map Task
  – Reducer Task
##################################################################################
Yarn
● Yarn角色及概念(续1)
• Yarn是Hadoop的一个通用的资源管理系统
• Yarn角色
  – Resourcemanager
  – Nodemanager

  – ApplicationMaster
  – Container
  – Client

• ResourceManager
  – 处理客户端请求
  – 启动/监控ApplicationMaster
  – 监控NodeManager
  – 资源分配不调度
• NodeManager
  – 单个节点上的资源管理
  – 处理来自ResourceManager的命令
  – 处理来自ApplicationMaster的命令

• Container
  – 对任务运行环境的抽象,封装了CPU 、内存等
  – 多维资源以及环境变量、启动命令等任务运行相关的
     信息资源分配不调度
• ApplicationMaster
  – 数据切分
  – 为应用程序申请资源,并分配给内部任务
  – 任务监控不容错
• Client
  – 用户与Yarn交互的客户端程序
  – 提交应用程序、监控应用程序状态,杀死应用程序等
##################################################################################、
补充：NFS高可用
第一种就是借助RSYNC+inotify来实现主从同步数据。
第二种借助DRBD，实现文件同步。
1 NFS高可用解决方案之DRBD+heartbeat搭建

##################################################################################
Hadoop安装与配置
● Hadoop的部署模式有三种
  – 单机
  – 伪分布式
  – 完全分布式

● Hadoop配置文件及格式
• 文件格式
– Hadoop-env.sh  JAVA_HOME  HADOOP_CONF_DIR
– xml文件配置格式  ----------------------------------------------------- #常用
<property>
   <name>关键字</name>
   <value>变量值</value>
   <description> 描述 </description>
</property>

<configuration>
     <property>
          <name></name>
          <value></value>
     </property>
     <property>
          <name></name>
          <value></value>
     </property>
     <property>
          <name></name>
          <value></value>
     </property>
</configuration>

● Hadoop配置文件
  hadoop-env.sh   
  core-site.xml   #全局配置文件
  hdfs-site.xml
  mapred-site-xml
  yarn-site.xml
  slaves
##################################################################################
单机安装
● 安装
  [root@hadoop0 ~]# unzip Hadoop.zip  #老师提供
  [root@hadoop0 ~]# cd hadoop/
  [root@hadoop0 hadoop]# ls
  hadoop-2.7.6.tar.gz  kafka_2.10-0.10.2.1.tgz  zookeeper-3.4.10.tar.gz
  [root@hadoop0 hadoop]# tar -xf hadoop-2.7.6.tar.gz
  [root@hadoop0 hadoop]# mv hadoop-2.7.6 /usr/local/hadoop
  [root@hadoop0 hadoop]# yum -y install java-1.8.0-openjdk-devel
  
● 配置
   [root@nn01 hadoop]# rpm -ql java-1.8.0-openjdk  #找到jdk家目录
   /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-11.b12.el7.x86_64/jre/bin/policytool

  [root@nn01 ~]# vim /usr/local/hadoop/etc/hadoop/hadoop-env.sh  
 25 export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-11.b12.el7.x86_64/jre/
 33 export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop
  
● 测试  
  [root@hadoop0 hadoop]# pwd
  /usr/local/hadoop
  [root@hadoop0 hadoop]# ./bin/hadoop versions
  Hadoop 2.7.6

  [root@hadoop0 hadoop]# bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.6.jar worcount test.txt result1
  //jar 算法程序的压缩格式
  //wordcount  命令
  //test.txt   源文件 
  //result1    结果输出文件
##################################################################################
HDFS
● 系统规划
          主机                            角色                软件
   192.168.1.100  Nn01        NameNode          HDFS
                         SecondaryNameNode   
   192.168.1.101  Node1       DataNode          HDFS
   192.168.1.102  Node2       DataNode          HDFS
   192.168.1.103  Node3       DataNode          HDFS
##################################################################################   
● HDFS分布式文件系统
• 基础环境准备
   – 在4台机器上配置/etc/hosts
   – 注意:所有主机都能ping通namenode的主机名,
     namenode能ping通所有节点
   – java -version 验证java安装 #java-1.8.0-openjdk-devel
   – jps 验证角色
   — ssh可以免密登陆
   
• 配置SSH信任关系(NameNode)
– 注意:不能出现要求输入yes的情况,每台机器都要能
   登录成功,包括本机!!!
– ssh_config
  StrictHostKeyChecking no
  
 [root@room11pc19 ~]# pssh -h hosts.txt "sed -i '/^Host /a  \
 StrictHostKeychecking no' /etc/ssh/ssh_config"
 [root@room11pc19 ~]# pssh -h hosts.txt "rm -rf /root/.ssh/know*"

##################################################################################
● 搭建完全分布式
   // 可参考http://hadoop.apache.org/old  #找到2.7.6的hadoop,再找到configuration
   
  & 配置全局配置文件  core-site.xml
  [root@nn01 hadoop]# vim etc/hadoop/core-site.xml
<--------------------------------------------------------------------------------
<configuration>
   <property>
      <name>fs.defaultFS</name>  #指定 默认存储,由value来设定
      <value>hdfs://nn01:9000</value>    #默认存储为本地 单机时可以写"file:///"
      <description>文件系统</description> 
   </property>     
   <property>
      <name>hadoop.tmp.dir</name>  #指定hadoop数据根目录
      <value>/var/hadoop</value>    
   </property>     
</configuration>
-------------------------------------------------------------------------------->

  & 配置hdfs配置文件  hdfs-site.xml
<--------------------------------------------------------------------------------  
<configuration>
     <property>
          <name>dfs.namenode.http-address</name>
          <value>192.168.1.100:50070</value>
     </property>
     <property>
          <name>dfs.namenode.secondary.http-address</name>
          <value>192.168.1.100:50090</value>
     </property>
     <property>
          <name>dfs.replication</name>
          <value>2</value>
     </property>
</configuration>
  -------------------------------------------------------------------------------->

  & 配置节点配置文件  slaves
  [root@nn01 hadoop]# cat etc/hadoop/slaves 
  node1
  node2
  node3
  
  & 把/usr/local/hadoop 拷贝到node1，node2，node3
  [root@nn01 hadoop]# pscp.pssh -r -h /root/hosts.txt /usr/local/hadoop/ /usr/local/

  & 格式化
 [root@nn01 hadoop]# ./bin/hdfs namenode -format
  & 起服务
 [root@nn01 hadoop]# ./sbin/start-dfs.sh
##################################################################################
• JPS验证角色
– NameNode验证
  [root@nn01 hadoop]# jps
   29826 SecondaryNameNode
   31237 Jps
   29643 NameNode
– DataNode验证
  [root@node1 ~]# jps
   24472 Jps
   24027 DataNode

• 节点验证
– NameNode上
– bin/hdfs dfsadmin -report
  [root@nn01 hadoop]# bin/hdfs dfsadmin -report
  Configured Capacity: 51505004544 (47.97 GB)
  DFS Used: 733184 (716 KB)



























 
