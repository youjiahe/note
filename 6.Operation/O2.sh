
#############################################
SSL虚拟主机
http协议是明文（httpd nginx Tomcat weblogic）
https 
加密(AES DES)：
对称算法：AES DES  （单机加密）
非对称算法：RSA DSA （网络传输）

server {
        listen       443 ssl;
        server_name  www.ssl.com;
        ssl_certificate      cert.pem;
        ssl_certificate_key  cert.key;
        ssl_session_cache    shared:SSL:1m;   #
        ssl_session_timeout  5m;               #超时时间5min
        ssl_ciphers  HIGH:!aaNULL:!MD5;   #不能用空密码，不能用MD5加密算法
        ssl_prefer_server_ciphers  on;     #
        location / {
            root   html;
            index  index.html index.htm;
        }
    }

  #############################################
静态，动态页面
静态：html写成的文件或者纯字体，图片，歌曲，视频   #Nginx在网页根目录找
动态：需要shell，php，java解析代码   #PHP只能做网页，java用途很广泛
动静分离
nginx实现：
如果用户访问的是静态页面，则自己直接找到页面，直接返回。
如果用户访问的是动态php，则转发给9000端口，解释后，再给nginx，nginx再给客户。


location  /  {
              allow all;
 }
location /test {
              allow all;
              deny 1.1.1.1;
}
location ～ \.php$ {
              root html;
              fastcgi_pass 127.0.0.1:9000;   #转发给9000，9000做代码解析                          
}

location:
1.location 可以出现很多次
2.location匹配用户地址栏
3.location / 的优先级最低；location会先匹配其他的目录，最后在匹配 /
4.location ~\.php$       #”~”表示正则匹配  
#######################################
LNMP（Linux Nginx Mysql PHP）
搭建
步骤1：装包
N：nginx
M：mariadb-server mariadb mariadb-devel     
#mariadb 是一个软件，-server只是一个服务，需要有软件的支持；mariadb-devel   
  依赖包
P：php php-fpm php-mysql  
   #php-mysql可以让php连接mysql； 
   php-fpm可以启动9000端口，持续服务；php只能执行一次

补充
修改CentOS[
我们的是标准DVD.iso
everyting ISO 包含所有的包(老师是从这里拿php-fpm的包的)
]默认yum源为国内yum镜像源
https://blog.csdn.net/inslow/article/details/54177191


步骤2：起服务
mariadb
php-fpm

步骤3：确认端口情况
   netstat -utanlp | grep :80         #nginx
   netstat -utanlp | grep :3306      #mariadb
   netstat -utanlp | grep :9000      #php

步骤4：查看php-fpm配置文件
[root@proxy etc]# vim /etc/php-fpm.d/www.conf
[www]
listen = 127.0.0.1:9000            //PHP端口号
pm.max_children = 32                //最大进程数量
pm.start_servers = 15                //最小进程数量
pm.min_spare_servers = 5            //最少需要几个空闲着的进程，保证预启动
pm.max_spare_servers = 32            //最多允许几个进程处于空闲状态

步骤5：修改主配置文件(先备份原来的nginx.conf；再用nginx.conf.default覆盖)
location ~ \.php$ {
            root           html;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            include     fastcgi.conf
        }
[
fastcgi_params：
1.这个是老版本的文件，本身存在问题。
2.而且会让nginx运行速度变慢];    #包括这个配置文件下的东西也会被运

步骤6：如出错则查看日志文件
Nginx的默认错误日志文件为       /usr/local/nginx/logs/error.log
PHP默认错误日志文件为           /var/log/php-fpm/www-error.log
     
   #常见错误
    file not found         -----selinux
    an error              -----服务php-fpm，mariadb等服务没开
空                    -----php脚本错误
mysql.php没有反应   -----如果服务都起了，则有可能是php-mysql没有装

总结：
nginx[返回静态页面，转发动态页面给9000端口]
php-fpm[读取php脚本，并从头执行到尾；也可以连接数据库]
mysql[存储数据]

 ##########################################
地址重写
例子：
www.360buy.com -------> www.jd.com
www.jd.com ---------------->https://www.jd.com
www.jd.com/jpg/a.jpg -->www.jd.com/pic/a.jpg
配置
rewrite：
rewrite regex replacement flag   #regex 正则表达式
rewrite 旧地址 新地址 [选项]   
#选项可以不写，选项redirect（地址栏也更改为新地址）

案例1：访问192.168.4.5时定向到www.tmooc.cn
rewrite ^/ www.tmooc.cn   #^/，正则匹配

案例2：访问192.168.4.5下的所有，都定向到www.tmooc.cn下相同的内容
rewrite ^/(.*) www.tmooc.cn/$1;   # $1相当于 \1； 把前面的(.*)粘贴一遍

 #########################################
Nginx的默认访问日志文件为      
 /usr/local/nginx/logs/access.log
IP - USER p [time] “details”  运行代码  “-”  “http_user_agent（包括系统，浏览器信息）”    
#可以通过这里判断，访问者是电脑还是手机，因此可以返回不同的页面


if($http_user_agent ~* firefox){   #~表示正则匹配，*表示不区分大小写
   rewrite ^/(.*)  /firefox/$1;
}

 ############################################
地址重写格式【总结】
rewrite 旧地址 新地址 [选项];
last 不再读其他rewrite
break 不再读其他语句，结束请求
redirect 临时重定向
permanent 永久重定向----------------------会让网站数据库更改数据库（比如百度）
