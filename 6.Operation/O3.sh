
 #######################################################################
案例1：Nginx反向代理
功能：负载均衡，动态感知
<meta>

●步骤1：部署实施后端Web服务器
web1,web2两台服务器分别搭建httpd服务

●步骤2：定义集群，配置调度集群
定义集群：
upstream xyz{
         server 192.168.2.100:80;
         server 192.168.2.200:80;
}
调用集群：
server {
        listen        80;
        server_name  localhost;
            location / {
#通过proxy_pass将用户的请求转发给webserver集群
            proxy_pass http://xyz;
        }
}
 补充：
 做压力测试 ab -c 10 -n 10000 http://192.168.4.5/
 到web服务器查看/var/log/httpd/access_log

●步骤3：配置服务器集群池属性
1)设置失败次数，超时时间，权重
权重(weight)：            默认1。如果两台机分别1，3；则1/4访问第一台机，3/4访问第二台机
失败次数(max_fails)：    超过后，不再访问？？
超时时间(fail_timeout)：失败后，等待该时间，再访问

2)设置相同客户端，访问相同服务器
upstream xyz {
             ip_hash;
             server 192.168.2.100 weight=2 max_fails=1 fail_timeout=10;
             server 192.168.2.200 weight=8 max_fails=2 fail_timeout=30;
             server 192.168.2.101 down;
     }

 ######################################################################
案例2：TCP/UDP调度器
●步骤1：重装Nginx，添加stream模块， ssl模块
PS：ngx_stream_core_module从1.9.0版本起可用

●步骤2：修改配置文件     
stream {
      upstream xyz{          #允许写多个upstream，即定义集群
           ip_hash;
           server 192.168.2.100:22;
           server 192.168.2.200:22;
      }
      server {
           listen 8888;
           proxy_pass xyz;
      }
}
http {

●步骤3：验证
client: ssh  -p8888 root@192.168.4.5

#######################################################################
用户认证
虚拟主机
安全web
动静分离
LNMP
调度器（代理服务器）

RHEL7推荐用ss代替netstat,功能选项都一样

########################################################################
Nginx常见问题
●客户端访问服务器提示“Too many open files”
●解决客户端访问头部信息过长的问题
●让客户端浏览器缓存数据
●自定义返回给客户端的404错误页面
●查看服务器状态信息
●开启gzip压缩功能，提高数据传输效率
●开启文件缓存功能

#########################################################################
问题1：客户端访问服务器提示"Too many open files"
高并发量时提示 scoket:Too many open file●
# ab -c1024 -n1024 http://192.168.4.5/
.. ..
socket: Too many open files (24)  //提示打开文件数量过多

优化并发量：
●步骤1：修改配置文件，
worker_processes 2;          #Nginx的进程数，与CPU核心数量一致
worker_connections 65535;    #每个worker最大并发量，因为电脑的端口数就时65535个
use epoll;

●步骤2：修改内核参数
ulimit -a #查看open file参数，选项-n是修改打开文件数量的
硬限制，软限制
临时修改：
ulimit -Hn 100000  #临时修改硬限制
ulimit -Sn 100000  #临时修改软限制

永久修改：
[root@proxy ~]# vim /etc/security/limits.conf
    .. ..
*               soft    nofile            100000
*               hard    nofile            100000
 ########################################################################
问题2：客户端访问头部信息过长的问题
●414 Request-URI Too Large   //网址太长了
http {
client_header_buffer_size 1K;
large_client_header_buffers 4 1M;   #企业用4 4k足够
 #########################################################################
问题3：浏览器本地缓存静态数据

●缓存时间设置为30天
location ~* \.(jpg)$ {
expires        30d;            //定义客户端缓存时间为30天
}

●到火狐浏览器查看about:cache
#disk
#Number of entries: 	10
#Maximum storage size: 	358400 KiB
#Storage in use: 	134 KiB
#Storage disk location: 	/root/.cache/mozilla/firefox/zrc4q03l.default/cache2
List Cache Entries <-----------再进去这里查看，发现ab.jpg的缓存时间时从8-22到9-21
http://192.168.4.5/ab.jpg  78377 byte 2 2018-08-22 17:28:04 	2018-09-21 17:28:03 	 

●如果没有包括的格式，则会显示1970-01-011
http://192.168.4.5/zxc.gif 	471834 bytes 	1 	2018-08-22 17:36:00 	1970-01-01 08:00:00 	 

##########################################################################
问题4：自定义404报错页面

●error_page 404 /40x.html

●打开网页，按F12,可以看到状态栏显示的状态码

200-300都正常  400都是用户错  500都是服务器错
状态码   功能 
200      一切正常
301      永久重定向
302      临时重定向
401      用户或密码错误
403      禁止访问(用户ip被禁止)
404      文件不存在
500      服务器出错
502     (集群级别) bad gateway

#################################################################
问题5：如何查看服务器状态信息

●步骤1：安装时选以下模块
./configure --help | grep status  -----> --with-http_stub_status_module

[root@proxy nginx-1.12.2]# ./configure   \
> --with-http_ssl_module                        //开启SSL加密功能
> --with-stream                                //开启TCP/UDP代理模块
> --with-http_stub_status_module                //开启status状态页面
[root@proxy nginx-1.12.2]# make && make install    //编译并安装

●步骤2：修改Nginx配置文件，定义状态页面

location /status {
                stub_status on;
                allow  127.0.0.1;   #allow,deny非必要的，写自己的ip，只允许自己访问
                deny   all;
         }

●步骤3：客户机client访问

[root@client ~]# curl 192.168.4.5/status
Active connections: 1               //实时并发量
server accepts handled requests     //
 1 1 1 
Reading: 0 Writing: 1 Waiting: 0   //reading为0时，代表服务器读得快

解析       
#Accepts：已经接受客户端的连接总数量。 
#Handled：已经处理客户端的连接总数量（一般与accepts一致，除非服务器限制了连接数量）。
#Requests：客户端发送的请求数量。
#Reading：当前服务器正在读取客户端请求头的数量。    
#Writing：当前服务器正在写响应信息的数量。
#Waiting：当前多少客户端在等待服务器的响应。

###########################################################################
问题6：开启gzip压缩功能，提高数据传输效率

注意：多媒体格式不要压缩，因为会越压越大（mp3,mp4,gif）

http {
.. ..
gzip on;
gzip_min_length 1k;
gzip_buffers 4 16k;
#gzip_http_version 1.0;
gzip_comp_level 2;
gzip_types text/plain application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;
gzip_vary off;
gzip_disable "MSIE [1-6]\.";

# 第1行：开启Gzip
# 第2行：不压缩临界值，大于1K的才压缩，一般不用改
# 第3行：buffer，就是，嗯，算了不解释了，不用改
# 第4行：用了反向代理的话，末端通信是HTTP/1.0，有需求的应该也不用看我这科普文了；有这句的话注释了就行了，默认是HTTP/1.1
# 第5行：压缩级别，1-10，数字越大压缩的越好，时间也越长，看心情随便改吧
# 第6行：进行压缩的文件类型，缺啥补啥就行了，JavaScript有两种写法，最好都写上吧，总有人抱怨js文件没有压缩，其实多写一种格式就行了
# 第7行：跟Squid等缓存服务有关，on的话会在Header里增加"Vary: Accept-Encoding"，我不需要这玩意，自己对照情况看着办吧
# 第8行：IE6对Gzip不怎么友好，不给它Gzip了
}

###########################################################################
问题7：服务器内存缓存

如果需要处理大量静态文件，可以将文件缓存在内存，下次访问会更快。
http { 
open_file_cache          max=2000  inactive=20s;
        open_file_cache_valid    60s;
        open_file_cache_min_uses 5;
        open_file_cache_errors   off;
//设置服务器最大缓存2000个文件句柄，关闭20秒内无请求的文件句柄
//文件句柄的有效时间是60秒，60秒后过期
//只有访问次数超过5次会被缓存
} 





