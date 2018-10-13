1.搭建HAproxy 基于端口的调度 及 7层调度
2.搭建HAproxy 7层调度,动静分离
##################################################################################  
扩展——TMOOC没有

搭建HAproxy 基于端口的调度 及 7层调度
环境准备
●案例拓扑
             client 30                  #客户端
                     |
            HAproxy 31                  #调度器
                     |
----|---------------|---------------------|--------------------|---
web32    web33       web34       web35  #4台web服务器LNMP
  
●部署以上拓扑  #以上web搭建步骤省略

●部署网页文件  #静态，动态都要  #web32～web35
[root@web32 ~]# echo "web32" >/usr/local/nginx/html/test.html
[root@web32 ~]# echo '<?php
$i=99;
echo $i;
echo "\n";
?>' > /usr/local/nginx/html/index.php
●部署连接数据库网页文件  #web32～web35
[root@web32 ~]# echo '<?php
$x=mysql_connect("localhost","root","")
if($x){ echo "ok\n"; }{ echo "connect_error\n"; }
?>'  > /usr/local/nginx/html/test.php
##################################################################################  
搭建HAproxy基于端口的调度 
●装包
  [root@haproxy31 ~]# yum -y install haproxy
●配置
 &备份
  [root@haproxy31 ~]# cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
 &修改配置
  [root@haproxy31 ~]# vim /etc/haproxy/haproxy.cfg  #配置文件说明请见 CLT3.sh
<-----------------------------------------------------------------------------------
global
.. ..
default
.. ..
stats uri /admin
listen lnmp 192.168.4.31:80
   cookie SERVERID rewrite
   balance roundrobin
   server web32 192.168.4.32:80 cookie web32cok check inter 2000 rise 2 fall 5  
   server web33 192.168.4.33:80 cookie web33cok check inter 2000 rise 2 fall 5 
   server web34 192.168.4.34:80 cookie web34cok check inter 2000 rise 2 fall 5 
   server web35 192.168.4.35:80 cookie web35cok check inter 2000 rise 2 fall 5 
----------------------------------------------------------------------------------->
●起服务
 [root@haproxy31 ~]# systemctl restart haproxy 

●客户端测试    #看到轮询调度效果
  [root@client ~]# curl 192.168.4.31/test.html
  web33
  [root@client ~]# curl 192.168.4.31/test.html
  web34
  [root@client ~]# curl 192.168.4.31/test.html
  web35
  [root@client ~]# curl 192.168.4.31/test.html
  web32
  
●压力测试
  [root@room11pc19 sh]# ab -c 100 -n 42012 http://192.168.4.31/
  Concurrency Level:      100
  Time taken for tests:   159.229 seconds        in
  Complete requests:      42012
  Failed requests:        61   #42012请求数，61个失败
##################################################################################  
搭建HAproxy 7层调度,动静分离
●恢复环境
 & 停服务 
 & 恢复配置文件
   [root@haproxy31 ~]# cp /etc/haproxy/haproxy.cfg.bak /etc/haproxy/haproxy.cfg
●修改配置文件
[root@haproxy31 ~]# vim /etc/haproxy/haproxy.cfg
<-----------------------------------------------------------
    stats uri /admin
frontend  main 192.168.4.31:80
    acl url_html       path_end       -i .html
    acl url_php        path_end       -i .php
    use_backend htmlgrp          if url_html
    use_backend phpgrp           if url_php    
    default_backend              phpgrp 

backend htmlgrp
    balance     roundrobin
    server  web34 192.168.4.34:80 check
    server  web35 192.168.4.35:80 check
    
backend phpgrp
    balance     roundrobin
    server  web32 192.168.4.32:80 check
    server  web33 192.168.4.33:80 check
----------------------------------------------------------->

●配置说明：
 +frontend main 192.168.4.31:80
  //acl:后面跟 acl名称  
  //path_beg是匹配开头，path_end是匹配结尾；
  //-i 不区分大小写
  //use_backend  后端服务器组名  if  acl条件名
  //default_backend  默认调用服务器组名
  
 +backend 定义后端服务器组名
   //server 主机名(随意) IP：PORT check
   
●起服务
  [root@haproxy31 ~]# systemctl restart haproxy

●客户端测试
  [root@client ~]# curl 192.168.4.31  
  web32 
  [root@client ~]# curl 192.168.4.31 
  web33
  #默认访问php页面，分发到phpgrp组轮询处理
  
  [root@client ~]# curl 192.168.4.31/test.html
  web34
  [root@client ~]# curl 192.168.4.31/test.html
  web35
  #访问以".html"结尾的路径，分发到htmlgrp组轮询处理

##################################################################################
lvs haproxy nginx  LB集群
          工作层   健康性检查    适用场合               功能
Lvs     4层        否         不需要按业务调度的      少，负载均衡(LVS/DR)
                                 通常与Keepalived连用
                                 
HAproxy 4/7层      是         按业务区分，动静分离   相对多，高可用，负载均衡

Nginx   4/7层      否,        web,反向代理           多，web，高可用，负载均衡
              (可以指定最大连接错误)
##################################################################################
ceph集群总结








  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
