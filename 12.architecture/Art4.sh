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
   – 插件及文档地址
     https://github.com/logstash-plugins
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
Kibana使用
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
● Logstash里面的类型
   – 布尔值类型:  ssl_enable => true
   – 字节类型:    bytes => "1MiB"
   – 字符串类型:  name => "xkops"
   – 数值类型:    port => 22
   – 数组:        match => ["datetime","UNIX"]
   – 哈希:        options => {k => "v",k2 => "v2"}
   – 编码解码:    codec => "json"
   – 路径:        file_path => "/tmp/filename"
   – 注释:         #
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
                                      { ES }  |---http
                                              |---elasticsearch
##################################################################################                                              
logstash 配置
● 配置格式
 input{ file }  #应用中配置这个
 filter{ip,time,met}
 output{file,es,mysql} 
##################################################################################
总结；
input{
    file{
        #path属性接受的参数是一个数组，其含义是标明需要读取的文件位置
        path => [‘pathA’，‘pathB’]
        #表示多就去path路径下查看是够有新的文件产生。默认是15秒检查一次。

        sincedb_path => ’$HOME/. sincedb‘
        #logstash 从什么 位置开始读取文件数据， 默认是结束位置 也可以设置为：beginning 从头开始

        start_position => ‘beginning’
        #注意：这里需要提醒大家的是，如果你需要每次都从同开始读取文件的话，
        设置start_position => beginning是没有用的，
        你可以选择sincedb_path 定义为 /dev/null
    }            
}
################################################################################## 
logstash 配置 #熟悉语法
● 插件
   – 插件及文档地址
     https://github.com/logstash-plugins  #找到相应的插件
   
 & 列出所有插件 
  [root@logstash logstash]# echo "PATH=/opt/logstash/bin:$PATH" >> /etc/profile
  [root@logstash logstash]# logstash-plugin list  
  logstash-codec-json
  logstash-input-stdin   
  logstash-output-stdout

● 第一个logstash配置文件  #类似于cat，标准输入(键盘鼠标)

  [root@logstash logstash]# vim logstash.conf 
   input{
       stdin{}
       }
   filter{}
   output{
         stdout{}
         }
 & 执行logstash -f logstash.conf  #可以看到输入什么，输出什么
  [root@logstash logstash]# logstash -f logstash.conf 
  123456789
  Settings: Default pipeline workers: 2
  Pipeline main started
  2018-10-26T14:25:42.946Z logstash 123456789

● 修改上面的配置文件
 [root@logstash logstash]# vim logstash.conf 
 <-----------------------------------------------
  input{
    stdin{codec => "json"}      
  }
  filter{}
  output{
    stdout{codec => "rubydebug"}    #一般都用rubydebug解析输出
 }
 ----------------------------------------------->
 [root@logstash logstash]# logstash -f logstash.conf
  Settings: Default pipeline workers: 2
  Pipeline main started
{"a":1,"b":2,"c":3}        #输入json
{
             "a" => 1,
             "b" => 2,
             "c" => 3,
      "@version" => "1",
    "@timestamp" => "2018-10-26T14:42:13.191Z",
          "host" => "logstash"
}
abcs     #输入字符串
{
       "message" => "abcs",
          "tags" => [
        [0] "_jsonparsefailure" #json解析失败
    ],
      "@version" => "1",
    "@timestamp" => "2018-10-26T14:42:17.844Z",
          "host" => "logstash"
}
################################################################################## 
logstash 配置  文件作为输入  
● 配置从文件里输入   插件 file 练习
  [root@logstash logstash]# vim logstash.conf 
  <-----------------------------------------------
input{
  file{ 
  path => ["/tmp/a.log","/var/log/b.log"]
  }
}
filter{}
output{
  stdout{
  codec => "rubydebug"
  }
}
----------------------------------------------->

● 测试
[root@logstash ~]# echo "youjiahe_$[$RANDOM%1000+1]" >> /var/log/b.log
[root@logstash ~]# echo "youjiahe_$[$RANDOM%1000+1]" >> /tmp/a.log 

[root@logstash logstash]# logstash -f logstash.conf
Settings: Default pipeline workers: 2
Pipeline main started
{
       "message" => "youjiahe_147",
      "@version" => "1",
    "@timestamp" => "2018-10-26T15:02:21.417Z",
          "path" => "/var/log/b.log",
          "host" => "logstash"
}
{
       "message" => "youjiahe_828",
      "@version" => "1",
    "@timestamp" => "2018-10-26T15:02:28.429Z",
          "path" => "/tmp/a.log",
          "host" => "logstash"
}

###################################################################################
logstash 配置 网络作为输入 
● 配置从网络输入  插件 tcp&udp 练习
[root@logstash logstash]# vim logstash.conf 
input{
  file{ 
    path => ["/tmp/a.log"]
    sincedb_path => "/var/lib/logstash/since.db"  #指针文件，记录文件的偏移量
    start_position => "beginning"
    #logstash 从什么位置开始读取文件数据， 默认是end; beginning 从头开始
    type => "weblog"
  }
  tcp {
    mode => "server"  #client，server
    host => "0.0.0.0" #服务器监听地址; 如果mode是"client"，则host是需要连接的地址
    port => "8888"    #监听端口；   如果mode是"client"，则port是需要连接的地址
    type => "tcplog"  #与udp区分开
  }
  udp {
    port => "8888"
    type => "udp_log" 
}
filter{}
output{
  stdout{
  codec => "rubydebug"
  }
}

● 测试
 & 普通网络重定向测试
  [root@kibana ~]# echo "nsd1806" > /dev/tcp/192.168.1.20/8888

  [root@logstash logstash]# logstash -f logstash.conf
  Settings: Default pipeline workers: 2
  Pipeline main started
    {
       "message" => "nsd1806",
      "@version" => "1",
    "@timestamp" => "2018-10-26T16:17:18.141Z",
          "host" => "192.168.1.16",
          "port" => 55584,
          "type" => "tcp_log"

 & 使用文件描述符 重定向测试
  [root@kibana ~]# exec 14<>/dev/tcp/192.168.1.20/8888
  [root@kibana ~]# exec 15<>/dev/udp/192.168.1.20/8888
  [root@kibana ~]# echo "uuuuuuuuuuuuuuu" >&14
  [root@kibana ~]# echo "udp" >&15

  [root@logstash logstash]# logstash -f logstash.conf 
   {
       "message" => "uuuuuuuuuuuuuuu",
      "@version" => "1",
    "@timestamp" => "2018-10-26T16:20:41.358Z",
          "host" => "192.168.1.16",
          "port" => 56058,
          "type" => "tcp_log"
   }
   {
       "message" => "udp\n",
      "@version" => "1",
    "@timestamp" => "2018-10-26T16:27:26.357Z",
          "type" => "udp_log",
          "host" => "192.168.1.16"
   }
###################################################################################
logstash 配置 网络作为输入 
● 配置从网络输入  插件 syslog 练习
  [root@kibana ~]# vim /etc/rsyslog.conf 
    *.* @@192.168.1.20:514  #添加这行
  [root@kibana ~]# systemctl restart rsyslog #起服务 
  root@logstash logstash]# vim logstash.conf  #在input{}里，添加以下三行
  syslog { 
        type => "syslog_tag"
  }
  
  
● 测试
  [root@kibana ~]# logger -p local0.info -t test "Delay no more"
  
  [root@logstash logstash]# logstash -f logstash.conf
   Settings: Default pipeline workers: 2
   Pipeline main started
   {
           "message" => "Delay no more\n",
          "@version" => "1",
        "@timestamp" => "2018-10-26T16:48:48.000Z",
              "type" => "syslog_tag",
              "host" => "192.168.1.16",
          "priority" => 134,
         "timestamp" => "Oct 27 00:48:48",
         "logsource" => "kibana",
           "program" => "test",
          "severity" => 6,
          "facility" => 16,
    "facility_label" => "local0",
    "severity_label" => "Informational"
   }
###################################################################################
logstash 配置 过滤数据
● 处理数据 filter grok插件
[root@logstash logstash]# pwd
/opt/logstash
[root@logstash logstash]# ls -R | grep pattern  #以下路径写了elk作者总结的正则，可调用
./vendor/bundle/jruby/1.9/gems/logstash-patterns-core-2.0.5/lib/logstash/patterns

input {
  file{ 
    path => ["/var/log/httpd/access_log"]
    sincedb_path => "/dev/null"  #指针文件，记录文件的偏移量
    start_position => "beginning"
    #logstash 从什么位置开始读取文件数据， 默认是end; beginning 从头开始
    type => "weblog"
   }
}
 filter {
    if [type] == "weblog"
    grok {
      }
 }

output {
if [type] == "weblog"{
elasticsearch {
   hosts => ["192.168.1.15:9200"]
   index => "weblog"
   flush_size => 2000
   idle_flush_time => 10
}}
}
###################################################################################
• input filebeats插件
beats {
port => 5044
codec => "json"   #监听http的话，去掉
}
– 这个插件主要用来接收beats类软件发送过来的数据,
   由于logstash依赖JAVA环境,而且占用资源非常大,
   因此会使用更轻量的filebeat替代
   
[root@client ~]# sed -n '14p;72p;280p' /etc/filebeat/filebeat.yml
      paths:
      document_type: apachelog
    hosts: ["192.168.1.20:5044"]
###################################################################################
案例2:综合练习
1. 练习插件
2. 安装一台Apache服务并配置
3. 使用filebeat收集Apache服务器的日志
4. 使用grok处理filebeat发送过来的日志
5. 存入elasticsearch


































