大型架构及配置技术
NSD ARCHITECTURE  DAY04

1.Kibana使用
   1.1 批量导入数据
   1.2 数据批量查询
  1.3 map 映射
  1.4 Kibana 部分
  1.5 Kibana修改时间
  1.6 Kibana数据展示
  1.7 Kibana展示方式
2.Logstash配置扩展插件
Logstash
2.1 Logstash是什么
2.2 Logstash安装
2.3 Logstash类型及条件判断
2.4 Logstash配置文件
2.5 插件
2.6 filebeat安装配置
##################################################################################
基础知识：
tar
##################################################################################
Kibana使用
● 批量导入数据
  & 使用_bulk批量导入数据
    – 批量导入数据使用POST方式,数据格式为json,url
       编码使用data-binary
    – 导入含有index配置的json文件
   
  [root@kibana elk]# gzip -d logs.jsonl.gz
  [root@kibana elk]# gzip -d shakespeare.json.gz 
  [root@kibana elk]# gzip -d accounts.json.gz
  [root@kibana elk]# ls 
  accounts.json                  filebeat-1.2.3-x86_64.rpm
  alog.gz                        kibana-4.5.2-1.x86_64.rpm
  bigdesk-master.zip             logs.jsonl
  elasticsearch-2.3.4.rpm        logstash-2.3.4-1.noarch.rpm
  elasticsearch-head-master.zip  shakespeare.json
  elasticsearch-kopf-master.zip

  [root@kibana elk]# curl -XPOST 192.168.1.11:9200/_bulk \
                    --data-binary @shakespeare.json        #json里面有指定index，type

  [root@kibana elk]# curl -XPOST 192.168.1.11:9200/art4/acc/_bulk \
                    --data-binary @accounts.json

  [root@kibana ~]# curl -XPOST 192.168.1.11:9200/_bulk \
                   --data-binary @logs.jsonl
##################################################################################
● 复合查询
curl -XGET 192.168.1.12:9200/_mget?pretty -d '
{ "docs":[
   { 
    "_index":"logstash-2015.05.19",
     "_type":"log",
       "_id":"AWavudH9sxVRJs5FKY0t"
   },
   { 
    "_index":"art4",
     "_type":"acc",
       "_id":"17"
   },
   { 
    "_index":"shakespeare",
     "_type":"line",
       "_id":"109272"
   }   
   ]
}'

curl -XGET 192.168.1.11:9200/_mget?pretty -d ' 
{ "docs":[
   { 
     "_index":"logstash-2015.05.19",
     "_type":"log",
     "_id":"AWavudH8sxVRJs5FKYwE"
    },
    { 
     "_index":"art4",
     "_type":"acc",
     "_id":88
    } ]
}'
##################################################################################
map 映射  #看视频
• mapping:
   – 映射:创建索引的时候,可以预先定义字段的类型及
     相关属性
   – 作用:这样会让索引建立得更加的绅致和完善
   – 分类:静态映射和劢态映射
   – 劢态映射:自劢根据数据迚行相应的映射 
   – 静态映射:自定义字段映射数据类型
##################################################################################
Kibana使用
真机 firefox http://192.168.1.16:5601

● 指定索引  #图形
  & Index name or pattern : 
     填写  logstash-*
  & Time-field name 
      选择 @timestamp #用户画图     
● discovery --  Last 5 years
##################################################################################
● Visualize
  创建新的图(饼状图，折线图)
  图形在文件夹 Art4_picture
##################################################################################
Logstash配置扩展插件
● Logstash是什么
  & 是一个数据采集、加工处理以及传输的工具
  & 特点
     – 所有类型的数据集中处理
     – 不同模式和格式数据的正常化
     – 自定义日志格式的迅速扩展
     – 为自定义数据源轻松添加插件
##################################################################################
● logstash安装
  — logstash依赖java环境，需要安装java1.8.0-openjdk
  – Logstash没有默认的配置文件,需要手动配置
  – Logstash安装在/opt/logstash目录下 
  
  [root@logstash elk]# yum -y install java-1.8.0-openjdk 
  [root@logstash elk]# rpm -ivh logstash-2.3.4-1.noarch.rpm
  [root@logstash ~]# ls /opt/logstash/
  bin        CONTRIBUTORS  Gemfile.jruby-1.9.lock  LICENSE     vendor
  CHANGELOG.md  Gemfile       lib                     NOTICE.TXT

● Logstash工作结构
{ 数据源 } ==>
         input { } ==>
                   filter { } ==>
                             output { } ==> --|---mysql
                                      { ES }  |---apache
                                              |---elasticsearch
                                              
● 配置格式
 input{ file }  #应用中配置这个
 filter{ip,time,met}
 output{file,es,mysql} 





























