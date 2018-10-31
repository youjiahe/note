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
     
  [root@nn01 hadoop]# ./bin/yarn node -list
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
  
● 修复节点
 & HDFS修复节点    
    – 修复节点比较简单,与增加节点基本一致
    – 注意:新节点的ip和主机名要与损坏节点的一致
    – 启动服务
      # ./sbin/hadoop-daemon.sh start datanode
    – 数据恢复是自动的
    – 上线以后会自动恢复数据,如果数据量非常巨大,可
       能需要一定的时间

● 删除节点
   & 去掉之前添加的node4
    [root@nn01 hadoop]# vim /usr/local/hadoop/etc/hadoop/slaves        
    node1
    node2
    node3
   & 在此配置文件里面加入下面四行   #同步到其他节点
    [root@nn01 hadoop]# vim /usr/local/hadoop/etc/hadoop/hdfs-site.xml          
    <property>                                      
       <name>dfs.hosts.exclude</name>
       <value>/usr/local/hadoop/etc/hadoop/exclude</value>
    </property>  
  & 指定删除的节点    
    [root@nn01 hadoop]# vim /usr/local/hadoop/etc/hadoop/exclude
    node4
  & 导出数据
    [root@nn01 hadoop]# ./bin/hdfs dfsadmin -refreshNodes
    Refresh nodes successful
    [root@nn01 hadoop]# ./bin/hdfs dfsadmin -report  
      //查看node4显示Decommissioned
      
  & 查看node4显示Decommissioned后，停止datanode
   [root@node4 hadoop]# ./sbin/hadoop-daemon.sh stop datanode 
    stopping datanode
 ##################################################################################      
yarn节点管理    
• yarn的相关操作
– 由于Hadoop在2.x引入了yarn框架,对于计算节点的
   操作已经变得非常简单
– 增加节点
   # sbin/yarn-daemon.sh start nodemanager
– 删除节点
   # sbin/yarn-daemon.sh stop nodemanager
– 查看节点 (ResourceManager)
   # ./bin/yarn node -list    
    
##################################################################################
NFS网关    
    1.环境准备
      两台机
      NFSGW   192.168.1.110   装java-1.8.0-openjdk  卸载nfs-utils
      client  192.168.1.111   装nfs-utils
##################################################################################    
NFS网关
• NFS 网关用途  #代理整个namenode集群
  – 用户可以通过操作系统兼容的本地NFSv3客户端来浏
     览HDFS文件系统
  – 用户可以从HDFS文件系统下载文档到本地文件系统
  – 用户可以通过挂载点直接流化数据,支持文件附加,
     但是不支持随机写
  – NFS网关支持NFSv3和允许HDFS作为客户端文件系统
     的一部分被挂载   
    
• 特性
  – HDFS超级用户是与NameNode进程本身具有相同标
     识的用户,超级用户可以执行任何操作,因为权限检
     查永远不会认为超级用户失败   
     
• 注意事项
  – 在非安全模式下,运行网关进程的用户是代理用户
  – 在安全模式下,Kerberos keytab中的用户是代理用户  
  
• 调试
  – 在配置NFS网关过程中经常会碰到各种各样的错误,如
     果出现错误,打开调试日志是一个不错的选择
• 日志排错(log4j.property)
  – log4j.logger.org.apache.hadoop.hdfs.nfs=DEBUG
  – log4j.logger.org.apache.hadoop.oncrpc=DEBUG 
##################################################################################    
NFS网关
● 配置代理用户
  – 在NameNode和NFSGW上添加代理用户
  – 代理用户的UID,GID,用户名必须完全相同  
    
● 停止hadoop集群   
  [root@nn01 hadoop]# ./sbin/stop-all.sh
    
● 核心配置 core-site.xml    
   hadoop.proxyuser.{代理用户}.groups
   hadoop.proxyuser.{代理用户}.hosts
    – 这里的{代理用户}是主机上真实运行的nfs3的用户
    – 在非安全模式下,运行nfs网关的用户为代理用户
    – groups为挂载点用户所使用的组
    – hosts为挂载点主机地址

[root@nn01 hadoop]# vim etc/hadoop/core-site.xml #实时同步到其他主机，主要是nfsgw
   <property>
      <name>hadoop.proxyuser.tedu.groups</name>
      <value>*</value>
   </property>
   <property>
      <name>hadoop.proxyuser.tedu.hosts</name>
      <value>*</value>
   </property>
    

● 启动 hdfs
  # ./sbin/start-dfs.sh

● 配置文件hdfs-site.xml
  & 配置 * rw   #设置nfs的访问属性
     ... ...
    <property>
         <name>nfs.exports.allowed.hosts</name>
         <value>* rw</value>
    </property>
     ... ...

  & 设定缓存用的临时文件夹  #中断后重新上传可以，有数据
   – nfs.dump.dir
    ... ...
   <property> 
         <name>nfs.dump.dir</name>
         <value>/var/nfstmp</value>
   </property>
    ... ...

● 修改权限
  & 临时文件夹
   [root@nn01 hadoop]# chown tedu:tedu /var/nfstmp/
   
  & 日志文件夹  #这样nfsgw主机才可以往这写日志  
   [root@nfsgw hadoop]# setfacl -m u:tedu:rwx /usr/local/hadoop/logs/
##################################################################################
NFS启动与挂载
● 使用root用户启动portmap服务  #主机nfsgw操作
  [root@nfsgw hadoop]# ./sbin/hadoop-daemon.sh --script ./bin/hdfs start portmap
  
● 使用代理用户启动nfs3        #主机nfsgw操作
  [root@nfsgw hadoop]# su -tedu
  [tedu@nfsgw ~]$ cd /usr/local/hadoop/
  [tedu@nfsgw hadoop]$ ./sbin/hadoop-daemon.sh --script ./bin/hdfs start nfs3
  
● 客户端挂载  #需要先装包 nfs-tuils
[root@client ~]# mount -t nfs -o vers=3,proto=tcp,nolock,sync,noatime 192.168.1.110：/ /mnt

  – 目前NFSGW只能使用v3版本
     vers=3
  – 仅使用TCP作为传输协议
     proto=tcp
  – 不支持NLM
     nolock
  – 禁用access time的时间更新  #节省资源
     noatime
  – 强烈建议使用安装选项sync,它可以最小化避免重排
     序写入造成不可预测的吞吐量,未指定同步选项可能
     会导致上传大文件时出现不可靠行为


























    
