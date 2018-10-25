大型架构及配置技术
NSD ARCHITECTURE DAY03

1.分布式ELK平台
2.ES集群安装
   2.1 ES集群安装
   2.2 ES集群测试
3.扩展插件
4.Kibana安装
##################################################################################
基础知识
重定向
● 文件描述符 #看视频
文件描述符0、1和2分别代表stdin、stdout和stderr。

● 网络重定向
[root@ansible ~]# echo nsd1806 >  /dev/udp/192.168.1.11/8888
[root@web1 ~]# tcpdump -A  -i eth0 host 192.168.1.11 and udp portrange 0-29999
18:12:47.046860 IP ansible.37158 > web1.nupaper-ss: UDP, length 8
E..$.L@.@......
.....&/Y....nsd1806

● HTTP 协议简介
  & http请求由三部分组成
     – 分别是:请求行、消息报头、请求正文
     – 请求行以一个方法符号开头,以空格分开,后面跟着
        请求的URI和协议版本,格式如下:
       Method Request-URI HTTP-Version CRLF
  & http请求方法
     – 常用方法 GET,POST,HEAD
     – 其他方法 OPTIONS,PUT,DELETE,TRACE和CONNECT
  & ES 常用
    – PUT
     — 增
    – DELETE --- 删
    – POST --- 改
    – GET --- 查
    
● 系统命令 curl
  & 在linux中curl是一个利用URL规则在命令行下工作的
    文件传输工具,可以说是一款很强大的http命令行工
    具。它支持多种请求模式,自定义请求头等强大功能,
    是一款综合工具
  & curl 常用参数介绍
     – -A 修改请求 agent
     – -X 设置请求方法
     – -i 显示返回头信息
  & 例子：       
    curl -i -X HEAD 192.168.2.100
    curl -i -X GET 192.168.2.100
  & 用云主机来测试  
[root@els11 ~]# curl -XPUT http://118.144.89.240/info.php
<pre>
[ REQUEST_METHOD] ==> PUT
[    REMOTE_ADDR] ==> 113.67.159.120
[HTTP_USER_AGENT] ==> curl/7.29.0
[   HTTP_REFERER] ==> 

--- --- PUT options is --- ---
Array
(
)

##################################################################################
分布式ELK平台
ELK简介
● 什么是ELK
  & ELK是一整套解决方案,是三个软件产品的首字母缩写,
     很多公司都在使用,如:Sina、携程、华为、美团等
  & ELK分别代表
    – Elasticsearch:负责日志检索和储存
    – Logstash:负责日志的收集和分析、处理
    – Kibana:负责日志的可视化  #web页面
  & 这三款软件都是开源软件,通常是配合使用,而且又先后
     归于Elastic.co公司名下,故被简称为ELK
  & 类比
      LKEL---------LAMP
     Kibana       Apache
 Elasticsearch     Mysql
    Logstash        php
    
● ELK能做什么
  & ELK组件在海量日志系统的运维中,可用于解决
     – 分布式日志数据集中式查询和管理
     – 系统监控,包含系统硬件和应用各个组件的监控
     – 故障排查
     – 安全信息和事件管理
     – 报表功能
##################################################################################
Elasticsearch
● ElasticSearch是一个基于Lucene的搜索服务器。它
   提供了一个分布式多用户能力的全文搜索引擎,基于
  RESTful API的Web接口
● Elasticsearch是用Java开发的,幵作为Apache许可
   条款下的开放源码发布,是当前流行的企业级搜索引
   擎。设计用于云计算中,能够达到实时搜索,稳定,
   可靠,快速,安装使用方便
● 主要特点
   – 实时分析
   – 分布式实时文件存储,并将每一个字段都编入索引
   – 文档导向,所有的对象全部是文档
   – 高可用性,易扩展,支持集群(Cluster)、分片和复制(Shards 和 Replicas)
   – 接口友好,支持JSONElasticsearch部分(续2)
● ES没有什么
  – Elasticsearch没有典型意义的事务
  – Elasticsearch是一种面向文档的数据库
  – Elasticsearch没有提供授权和认证特性
● 相关概念
  – Node: 装有一个ES服务器的节点
  – Cluster: 有多个Node组成的集群
  – Document: 一个可被搜索的基础信息单元
  – Index: 拥有相似特征的文档的集合          #理解成库
  – Type: 一个索引中可以定义一种或多种类型   #理解成表
  – Filed: 是ES的最小单位,相当于数据的某一列
  – Shards: 索引的分片,每一个分片就是一个Shard
  – Replicas: 索引的拷贝
##################################################################################  
SQL与NoSQL与ES对比
● ES与关系型数据库的对比1
   – 在ES中,文档归属于一种 类型(type),而这些类型
     存在于索引(index)中,类比传统关系型数据库
     
   – DB -> Databases -> Tables -> Rows -> Columns
   – 关系型    数据库         表          行          列
   – ES -> Indices -> Types -> Documents -> Fields
   – ES       索引        类型         文档        域(字段)
● ES与关系型数据库的对比2
   RDBMS             Elasticsearch
   database              index
   table                 type
   row                   document
   column                field
   schema                mapping
   index                 everything is indexed
   SQL                   Qurey DSL
   select * from         GET http://
   update table set      PUT http://
  
##################################################################################
● 安装ELK
环境准备
5台1.5G  ElasticSearch 集群
1台1.5G  Kibana
1台2G   Logstash 

##################################################################################
ES集群安装  #5台都安装

● 安装第一台ES服务器
  – 设置主机名称和ip对应关系
  – 解决依赖关系
  – 安装软件包
  – 修改配置文件
  – 启动服务
  – 检查服务

[root@els11 ~]# mkdir /elk
[root@els11 ~]# tar -xf elk.tar  -C /elk/  #老师提供
[root@els11 ~]# yum -y install createrepo
[root@els11 ~]# createrepo /elk/
[root@els11 ~]# ls /elk/
accounts.json.gz               filebeat-1.2.3-x86_64.rpm
alog.gz                        kibana-4.5.2-1.x86_64.rpm
bigdesk-master.zip             logs.jsonl.gz
elasticsearch-2.3.4.rpm        logstash-2.3.4-1.noarch.rpm
elasticsearch-head-master.zip  repodata
elasticsearch-kopf-master.zip  shakespeare.json.gz

[root@els11 ~]# cat /etc/yum.repos.d/centos7.repo 
  [centos7]
  name=centos7
  baseurl=ftp://192.168.1.254/centos7
  enable=1
  gpgcheck=1
  [elk]
  name=elk
  baseurl=file:///elk
  enable=1
  gpgcheck=0
[root@els11 ~]# tail -7  /etc/hosts
192.168.1.11 els11
192.168.1.12 els12
192.168.1.13 els13
192.168.1.14 els14
192.168.1.15 els15
192.168.1.16 kibana
192.168.1.20 logstash

[root@els11 ~]# yum -y install java-1.8.0-openjdk
[root@els11 ~]# yum -y install elasticsearch.noarch 
[root@els11 ~]# vim /etc/elasticsearch/elasticsearch.yml 
[root@els11 ~]# systemctl restart elasticsearch.service 
[root@els11 ~]# ss -untlp | grep 9200

● ES集群安装 测试单机
  [root@room11pc19 ~]# curl 192.168.1.15:9200 #5台都是这样测试
{
  "name" : "Punchout",
  "cluster_name" : "elasticsearch",
  "version" : {
    "number" : "2.3.4",
    "build_hash" : "e455fd0c13dceca8dbbdbb1665d068ae55dabe3f",
    "build_timestamp" : "2016-06-30T11:24:31Z",
    "build_snapshot" : false,
    "lucene_version" : "5.5.0"
  },
  "tagline" : "You Know, for Search"
}

##################################################################################s
ES集群安装  #5台

● ES集群配置 #都配置
  – ES集群配置也很简单,只需要对配置文件做少量的修
     改即可,其他步骤和单机完全一致
  – ES集群配置文件
    17 cluster.name: els1806
    23 node.name: els11
    54 network.host: 0.0.0.0
    68 discovery.zen.ping.unicast.hosts: ["els11", "els12", "els13", "els14", "els15" ]

● 测试集群  #可以看到cluster_name是刚配置的els1806，节点有5个
  & ES 集群验证
     – 返回字段解析
    – "status " : " green " 
        集群状态,绿色为正常,黄色表示有问题但不是很严重,红色表示严重故障
    – "number_of_nodes" : 5, 表示集群中节点的数量
    — 端口号：9200，9300
  & 命令行执行
  [root@room11pc19 ~]# curl 192.168.1.13:9200/_cluster/health?pretty  #竖显示
  {
  "cluster_name" : "els1806",
  "status" : "green",          
  "timed_out" : false,
  "number_of_nodes" : 5,
  "number_of_data_nodes" : 5,
  "active_primary_shards" : 0,
  "active_shards" : 0,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
  }

  [root@els11 ~]# ss -untlp | egrep "9[23]00"
##################################################################################
ES插件的使用
● ES常用插件
  & head插件
     – 它展现ES集群的拓扑结构,并且可以通过它来进行索
        引(Index)和节点(Node)级别的操作
     – 它提供一组针对集群的查询API,并将结果以json和表
        格形式返回
     – 它提供一些快捷菜单,用以展现集群的各种状态
  & kopf插件
     – 是一个ElasticSearch的管理工具
     – 它提供了对ES集群操作的API
  & bigdesk插件
     – 是elasticsearch的一个集群监控工具
     – 可以通过它来查看es集群的各种状态,如:cpu、内存
        使用情况,索引数据、搜索情况,http连接数等

● ES插件安装、查看
   – 查看安装的插件
     /usr/share/elasticsearch/bin/plugin list
   – 安装插件例子
     /usr/share/elasticsearch/bin/plugin install
     ftp://192.168.4.254/head.zip
     /usr/share/elasticsearch/bin/plugin install
     file:///tmp/kopf.zip
   – 这里必须使用 url 的方式进行安装,如果文件在本地,
      也需要使用 file:// 的方式指定路径,例如文件在
     /tmp/xxx下面,要写成 file:///tmp/xxx , 删除使用
     remove 指令
     
● 安装bigdesk插件  #5台都安装
 & 安装插件
  [root@els11 ~]# rpm -ql elasticsearch  | grep plugin #查看插件安装命令路径
  /usr/share/elasticsearch/bin/plugin
  [root@els11 ~]# cd /usr/share/elasticsearch/bin/
  [root@els11 bin]# ./plugin install file:///elk/bigdesk-master.zip
  [root@els11 bin]# ./plugin install file:///elk/elasticsearch-kopf-master.zip 
  [root@els11 bin]# ./plugin install file:///elk/elasticsearch-head-master.zip
  
 & 查看插件  
  [root@els11 bin]# ./plugin list
Installed plugins in /usr/share/elasticsearch/plugins:
    - bigdesk
    - head
    - kopf

● 查看页面
  firefox http://192.168.1.11:9200/_plugin/head  
  firefox http://192.168.1.11:9200/_plugin/kopf
  firefox http://192.168.1.11:9200/_plugin/kopf
##################################################################################
扩展插件
● RESTful API
  — 检查集群、节点、索引的健康度、状态和统计
  – 管理集群、节点、索引的数据及元数据
  – 对索引进行CRUD操作及查询操作
  – 执行其他高级操作如分页、排序、过滤等
● POST戒PUT数据使用json格式
● RESTful API的简单使用
  – _cat API查询集群状态,节点信息
  – v参数显示详绅信息
    http://192.168.1.15:9200/_cat/health?v
  – help显示帮劣信息
    http://192.168.1.15:9200/_cat/health?help
    
● API的信息查看 _cat
  [root@els11 bin]# curl -XGET 192.168.1.11:9200/_cat
  =^.^=
  /_cat/allocation
  /_cat/shards
  /_cat/shards/{index}
  /_cat/master
  /_cat/nodes
  /_cat/indices
  /_cat/indices/{index}
  /_cat/segments
  /_cat/segments/{index}
  /_cat/count
  /_cat/count/{index}
  /_cat/recovery
  /_cat/recovery/{index}
  /_cat/health
  /_cat/pending_tasks
  /_cat/aliases
  /_cat/aliases/{alias}
  /_cat/thread_pool
  /_cat/plugins
  /_cat/fielddata
  /_cat/fielddata/{fields}
  /_cat/nodeattrs
  /_cat/repositories
  /_cat/snapshots/{repository}

  [root@els11 bin]# curl -XGET 192.168.1.11:9200/_cat/nodes
  192.168.1.12 192.168.1.12 12 57 0.00 d m els12 
  192.168.1.11 192.168.1.11  9 94 0.00 d * els11 
  192.168.1.14 192.168.1.14 11 57 0.00 d m els14 
  192.168.1.15 192.168.1.15 11 56 0.00 d m els15 
  192.168.1.13 192.168.1.13 11 57 0.00 d m els13
##################################################################################
ES插件的使用
● 图形新建索引
  http://192.168.1.11:9200/_plugin/head/
   //效果请查看文件夹“Art3”图片
   
● 命令行创建索引
   & 找一个文档写一个
<------------------------------------------------------------------------
curl -XPUT 192.168.1.11:9200/nsd1806 -d '
{ "setting":{
      "index":{
         "number_of_shards":5,
         "number_of_replicas":1
      }
    }
}'
------------------------------------------------------------------------>

   & 新建索引nsd1806
[root@els11 ~]# curl -XPUT 192.168.1.11:9200/nsd1806 -d '
> { "setting":{
>       "index":{
>          "number_of_shards":5,
>          "number_of_replicas":1
>       }
>     }
> }'
{"acknowledged":true}

   & 删除索引
[root@els11 ~]# curl -XDELETE 192.168.1.11:9200/index1
##################################################################################
ES插件的使用
● 对索引(库)做增删改查
 & 增 PUT
 //t:表名；  1：_id值；  -d:上传数据
 curl -XPUT 192.168.1.11:9200/nsd1806/t/1 -d '  
{"姓名":"杨紫","身高":"167cm","出生年月":"1992年11月","职业":"演员、歌手"}'
 curl -XPUT 192.168.1.11:9200/nsd1806/t/2 -d '
 {"姓名":"迪丽热巴","身高":"168cm","出生年月":"1992年6月","职业":"演员"}'
 
 & 查 GET
   [root@els11 ~]# curl -XGET 192.168.1.11:9200/nsd1806/t/2
{"_index":"nsd1806","_type":"t","_id":"2","_version":1,"found":true,"_source":
 {"姓名":"迪丽热巴","身高":"168cm","出生年月":"1992年6月","职业":"演员"}}
 
 [root@els11 ~]# curl -XGET 192.168.1.11:9200/nsd1806/t/2?pretty  
{
  "_index" : "nsd1806",
  "_type" : "t",
  "_id" : "2",
  "_version" : 1,
  "found" : true,
  "_source" : {
    "姓名" : "迪丽热巴",
    "身高" : "168cm",
    "出生年月" : "1992年6月",
    "职业" : "演员"
  }
}

 & 改 POST   _update
 [root@els11 ~]# curl -XPOST 192.168.1.11:9200/nsd1806/t/1/_update -d '
{"doc":{"代表作":"家有儿女"}}'

 & 删 DELETE
  [root@els11 ~]# curl -XDELETE els11:9200/nsd1806/t/4
##################################################################################
kibana
Kibana安装与配置
 & kibana是什么
    – 数据可视化平台工具
 & 特点:
    – 灵活的分析和可视化平台
    – 实时总结流量和数据的图表
    – 为丌同的用户显示直观的界面
    – 即时分享和嵌入的仦表板
##################################################################################
kibana
● 安装  #在主机kibana上安装
  & 装包
   [root@kibana ~]# rpm -ivh /elk/kibana-4.5.2-1.x86_64.rpm  
  
  & 配置
    kibana 默认安装在 /opt/kibana 下面,配置文件在
    /opt/kibana/config/kibana.yml
 & kibana.yml的配置
   [root@kibana elk]# rpm -qc kibana
   /opt/kibana/config/kibana.yml
   
   – server.port: 5601
   – server.host: "0.0.0.0"
   – elasticsearch.url: "http://els11:9200"   #记得写/etc/hosts
   – kibana.index: ".kibana"
   – kibana.defaultAppId: "discover"
   – elasticsearch.pingTimeout: 1500
   – elasticsearch.requestTimeout: 30000
   //#只需要改 elasticsearch.url:
   //其他项取消注释就可以
   
 & 起服务
   [root@kibana ~]# systemctl restart kibana
   [root@kibana ~]# systemctl enable kibana
 & 
  http://192.168.1.16:5601 


































