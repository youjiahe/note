大型架构及配置技术
NSD ARCHITECTURE DAY06

1.完全分布式
  1.1 mapreduce 部署
  1.2 yarn部署
2.节点管理
  2.1 hdfs节点管理
  2.2 yarn节点管理
3.NFS网关
##################################################################################
完全分布式
● 系统规划
          主机                            角色                软件
   192.168.1.100  Nn01        NameNode          HDFS
                         SecondaryNameNode      YARN
                            ResouceManager
   192.168.1.101  Node1       DataNode          HDFS
                             NodeManager        YARN
                             
   192.168.1.102  Node2       DataNode          HDFS
                             NodeManager        YARN
                             
   192.168.1.103  Node3       DataNode          HDFS
                             NodeManager        YARN   
   
● 安装与部署
• Hadoop三大核心组件
   – 分布式文件系统
     – HDFS已经部署完毕
   – 分布式计算框架
     – MapReduce
   – 集群资源管
     – yarn
##################################################################################
完全分布式
mapred部署
• 分布式计算框架mapred-site.xml
  – 改名
    FROM:mapred-site.xml.template
    To:mapred-site.xml
  – 资源管理类
    mapreduce.framework.name    
    
• 分布式计算框架mapred-site.xml
  – 只支持local和yarn两种
  – 单机使用local
  – 集群使用yarn
& 在配置<configuration>中 加入mapred-site.xml  
  <property>
      <name>mapreduce.framework.name</name>
      <value>yarn</value>
  </property>    
##################################################################################
完全分布式
yarn部署
• 资源管理 yarn-site.xml
– resourcemanager 地址
  yarn.resourcemanager.hostname
– nodemanager 使用哪个计算框架
  yarn.nodemanager.aux-services
– mapreduce_shuffle 计算框架的名称
  mapreduce_shuffle
  
[root@nn01 hadoop]# tail -12 etc/hadoop/yarn-site.xml 
<configuration>

<!-- Site specific YARN configuration properties -->
     <property>
          <name>yarn.resourcemanager.hostname</name>
          <value>nn01</value>
     </property>
     <property>
          <name>yarn.nodemanager.aux-services</name>
          <value>mapreduce_shuffle</value>
     </property>
</configuration>
##################################################################################
完全分布式
● 同步配置文件到其他三台虚拟机
[root@nn01 hadoop]# cat /root/node*
#!/bin/bash
while inotifywait -rqq /usr/local/hadoop/etc/hadoop
  do
     rsync -az --delete /usr/local/hadoop/etc/hadoop/ node1:/usr/local/hadoop/etc/hadoop
  done &
    
#!/bin/bash
while inotifywait -rqq /usr/local/hadoop/etc/hadoop
  do
     rsync -az --delete /usr/local/hadoop/etc/hadoop/ node2:/usr/local/hadoop/etc/hadoop
  done &
    
#!/bin/bash
while inotifywait -rqq /usr/local/hadoop/etc/hadoop
  do
     rsync -az --delete /usr/local/hadoop/etc/hadoop/ node3:/usr/local/hadoop/etc/hadoop
  done &

##################################################################################
完全分布式
● 起服务验证
[root@nn01 hadoop]# ./sbin/start-yarn.sh
[root@nn01 hadoop]# ./sbin/start-dfs.sh

● 验证
  & jps角色验证
   [root@room11pc19 ~]# pssh -i -h hosts.txt "jps"
   [1] 09:45:03 [SUCCESS] 192.168.1.102
   21600 NodeManager
   20983 DataNode
   5198 Jps
   
   [2] 09:45:03 [SUCCESS] 192.168.1.101
   21553 NodeManager
   5159 Jps
   20942 DataNode
   
   [3] 09:45:03 [SUCCESS] 192.168.1.103
   5232 Jps
   21621 NodeManager
   21004 DataNode
   
   [4] 09:45:03 [SUCCESS] 192.168.1.100
   21283 SecondaryNameNode
   21767 ResourceManager
   5625 Jps
   20749 NameNode    
       
 & 节点验证
  [root@nn01 hadoop]# ./bin/hdfs dfsadmin -report  
     
  [root@nn01 hadoop]# ./bin/yarn node --list
  18/10/30 18:02:42 INFO client.RMProxy: Connecting to ResourceManager at nn01/192.168.1.100:8032
  Total Nodes:3
  Node-Id	 Node-State	Node-Http-Address	Number-of-Running-Containers
  node1:33706  RUNNING	  node1:8042	          0
  node2:46047  RUNNING	  node2:8042	          0
  node3:36878  RUNNING	  node3:8042	          0

 & 使用Web访问Hadoop 
  – namenode web页面(nn01)
    # http://192.168.1.100:50070/    #在上方选项'Utilities可以看到文件系统'
  – secondory namenode web 页面(nn01)
    # http://192.168.1.100:50090/
  – datanode web 页面(node1,node2,node3)
    # http://192.168.1.101:50075/
    
  – resourcemanager web页面(nn01)
    # http://192.168.1.100:8088/
  – nodemanager web页面(node1,node2,node3)
    # http://192.168.1.101:8042/
##################################################################################    
完全分布式
● 使用hadoop
命令
   ls     ./bin/hadoop fs -ls /
   文件夹    ./bin/hadoop fs -mkdir /abc
   文件      ./bin/hadoop fs -touchz /1.txt
   上传文件  ./bin/hadoop fs -put *.txt /abc
   

● 创建目录
  [root@nn01 hadoop]# ./bin/hadoop fs -ls /
  [root@nn01 hadoop]# ./bin/hadoop fs -mkdir /8uuuuuuuuuu
  [root@nn01 hadoop]# ./bin/hadoop fs -ls /
  Found 1 items
  drwxr-xr-x   - root supergroup          0 2018-10-30 18:25 /8uuuuuuuuuu 
     
● 创建文件    
  [root@nn01 hadoop]# ./bin/hadoop fs -touchz /1.txt

● 上传文件
  [root@nn01 hadoop]# ./bin/hadoop fs -put *.txt /wen
##################################################################################    
案例2:Hadoop词频统计
  1. 在集群文件系统里创建文件夹
  2. 上传要分析的文件到目录中
  3. 分析上传文件
  4. 展示结果    
  
  [root@nn01 hadoop]# history
  370  ./bin/hadoop fs -mkdir /wen
  371  ./bin/hadoop fs -put *.txt /wen
  375  ./bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.6.jar wordcount /wen/wenzhang.txt /output
  377  ./bin/hadoop fs -ls /
  380  ./bin/hadoop fs -cat /output/*  | sort -n -k 2 

##################################################################################
完全分布式
● 故障恢复方式
 1.stop-all.sh
 2.rm -rf logs
 3.start-all.sh

● 重新初始化集群
 1.stop-all.sh
 2.清空所有机器的数据根目录 /var/hadoop
 3.hdfs namenode -format
 4.start-all.sh    
##################################################################################
节点管理
HDFS节点管理
● 增加节点
 & 新节点设置ssh无密码登陆
     //新节点设置ssh_config文件 "StrictHostKeyChecking no"
 & 新节点装包 java-1.8.0-openjdk-devel
 & 新节点创建文件夹 /var/hadoop  /usr/local/hadoop     
 & /etc/hosts添加节点，同步到每一个节点
 & NameNode主机配置 slaves文件，添加新节点 
 & NameNode同步 /usr/local/hadoop目录到新节点
 & 新节点启动datanode
  [root@node4 hadoop]# ./sbin/hadoop-daemon.sh start datanode
  
 & 设置同步带宽，并同步数据
  [root@nn01 hadoop]# ./bin/hdfs dfsadmin -setBalancerBandwidth 67108864
  [root@nn01 hadoop]# ./sbin/start-balancer.sh
 & 验证    
  [root@nn01 hadoop]# ./bin/hadoop fs -df -h /  #由原来3个节点的60G，变为80G
  Filesystem          Size   Used  Available  Use%
  hdfs://nn01:9000  80.0 G  1.0 M     71.8 G    0%
  
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
