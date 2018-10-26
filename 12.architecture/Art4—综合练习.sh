案例2:综合练习
1. 练习插件
2. 安装一台Apache服务并配置
3. 使用filebeat收集Apache服务器的日志
4. 使用grok处理filebeat发送过来的日志
5. 存入elasticsearch

● 编写logstash配置文件
[root@logstash logstash]# vim logstash.conf 
input{
  file{
       path => ["/tmp/a.log"]
       sincedb_path => "/var/lib/logstash/since.db"
       start_position => "beginning"
       type => "weblog"
  }
  tcp  {
        mode => "server"
        host => "0.0.0.0"
        port => "8888"
        type => "tcp_log"
  }
  udp  {
        port => "8888"
        type => "udp_log"
  }
  syslog {
        type => "syslog_tag"
  }
  if [type]=="apachelog"{
  beats {
    port => 5044
  }}
}
filter{
  grok   {
         match => [ "message", "(?<IP>([12][0-9]{0,2}\.){3}[0-9]{3}) - - \[(?<timestamp>.* \+[0-9]{4})\]\s*\"(?<method>(GET|POST))\s*\/\s*(?<protocol>[A-Z]*)\/(?<version>[0-9]*\.[0-9]*)\""]
  }  #也可以上网搜索
}
output{
  stdout{
        codec => "rubydebug"
  }
  if [type]== "apachelog" {
  elasticsearch {
        hosts => ["192.168.1.11:9200","192.168.1.13:9200"]
        index => "weblog"
  }}
}

● 搭建http，filebeat #filebeat是请量花的logstash
  [root@client ~]# yum -y install httpd
  [root@client ~]# echo "<h1>client" > /var/www/html/index.html
  [root@client ~]# systemctl restart httpd
  [root@client ~]# curl localhost
  [root@client ~]# yum -y install filebeat-1.2.3-x86_64.rpm  #老师提供rpm
  [root@client ~]# rpm -qc filebeat
  [root@client ~]# vim /etc/filebeat/filebeat.yml
  [root@client ~]# sed -n '14p;15p;72p;280p' /etc/filebeat/filebeat.yml
      paths:
        - /var/log/httpd/access_log
      document_type: apachelog
    hosts: ["192.168.1.20:5044"]


● 测试，在head上的7验证请查看图片
[root@room11pc19 sh]# curl 192.168.1.10  #在主机10上搭建httpd
<h1>client

[root@logstash logstash]# logstash -f logstash.conf
Settings: Default pipeline workers: 2
Pipeline main started
{
       "message" => "192.168.1.254 - - [26/Oct/2018:19:33:13 +0800] \"GET / HTTP/1.1\" 200 11 \"-\" \"curl/7.29.0\"",
      "@version" => "1",
    "@timestamp" => "2018-10-26T11:33:13.963Z",
          "type" => "apachelog",
         "count" => 1,
        "fields" => nil,
        "source" => "/var/log/httpd/access_log",
        "offset" => 2393,
    "input_type" => "log",
          "beat" => {
        "hostname" => "client",
            "name" => "client"
    },
          "host" => "client",
          "tags" => [
        [0] "beats_input_codec_plain_applied"
    ],
            "IP" => "192.168.1.254",
     "timestamp" => "26/Oct/2018:19:33:13 +0800",
        "method" => "GET",
      "protocol" => "HTTP",
##################################################################################
● 扩展  //可以在grok里面调用  作者定义好的变量 
filter{
  grok   {
         match => [ "message", "%{%{COMMONAPACHELOG}}"]  #这个没有agent,也就是浏览器信息
  }
}

filter{
  grok   {
         match => [ "message", "%{COMBINEDAPACHELOG}" ] #有agent信息
  }
}








