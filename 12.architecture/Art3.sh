大型架构及配置技术
NSD ARCHITECTURE DAY03

1.分布式ELK平台
2.ES集群安装
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
• ElasticSearch是一个基于Lucene的搜索服务器。它
   提供了一个分布式多用户能力的全文搜索引擎,基于
  RESTful API的Web接口
• Elasticsearch是用Java开发的,幵作为Apache许可
   条款下的开放源码发布,是当前流行的企业级搜索引
   擎。设计用于云计算中,能够达到实时搜索,稳定,
   可靠,快速,安装使用方便
• 主要特点
   – 实时分析
   – 分布式实时文件存储,并将每一个字段都编入索引
   – 文档导向,所有的对象全部是文档
   – 高可用性,易扩展,支持集群(Cluster)、分片和复制(Shards 和 Replicas)
   – 接口友好,支持JSONElasticsearch部分(续2)
• ES没有什么
  – Elasticsearch没有典型意义的事务
  – Elasticsearch是一种面向文档的数据库
  – Elasticsearch没有提供授权和认证特性
• 相关概念
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
安装ELK
5台1.5G  ElasticSearch 集群
1台1.5G  Kibana
1台2G    Logstash 
##################################################################################
ES集群安装
• 安装第一台ES服务器
  – 设置主机名称和ip对应关系
  – 解决依赖关系
  – 安装软件包
  – 修改配置文件
  – 启动服务
  – 检查服务

  mkdir /elk
  70  tar -xf elk.tar  -C /elk/
   71  ls /elk/
   72  yum -y install createrepo
   73  createrepo /elk/
   74  vim /etc/yum.repos.d/centos7.repo 
   79  yum -y install java-1.8.0-openjdk
   80  yum -y install elasticsearch.noarch 
   81  vim /etc/elasticsearch/elasticsearch.yml 
   82  systemctl restart elasticsearch.service 
   83  ss -untlp | grep 9200

































