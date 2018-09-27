#################################################################
问题总结

break

ip_hash #只读取IP前面3位
                      web1(登陆)[用户,密码]
   proxy                       
    记录客户端ip        web2(登陆)


proxy [http]
       [tcp]  --with-stream
upstream xyz {
        server ip1:20;
        server ip2:80;
}
server {
          
}

###################################################################
案例1：构建memcached服务
案例2：LNMP+memcached
案例3：PHP的本地Session信息
案例4：PHP实现session共享

###################################################################
问题提出：
●因为：
Mysql，SQL server，Oracle
以上都是RDBMS  -----关系型数据库，数据之间有关联性
传统数据库架构，是数据存储速度最慢的   #CPU缓存>内存>磁盘>数据库

●所以：
需要用更快的数据库-------key-value,缓存数据库
例如memcached

●key-value特点
优点：速度极快
缺点：功能简单，数据会丢失

●结果：
需要把mysql，根memcache联合起来用
类似以下过程
if 先查memcached内存；then
    从内存取，给用户
else
    从硬盘mysql查，给用户
fi
#########################################################################
案例1：构建memcached服务
●装包：memcached
●端口号：11211
●补充
以下目录是存放服务的配置文件的，存在的服务，才能用systemctl起服务
/usr/lib/systemd/system
●对于memcached
/usr/lib/systemd/system/memcached.service
ExecStart=/usr/bin/memcached -u $USER -p $PORT -m $CACHESIZE -c $MAXCONN $OPTIONS
-m:内存空间
/etc/sysconfig/memcached   存放变量

●装包telnet，测试memcache
[root@proxy ~]# telnet 192.168.4.5 11211
Trying 192.168.4.5...
..
##提示：0表示不压缩，180为数据缓存时间，3为需要存储的数据字节数量。
set i 0 100 3
get i
delete i
replace i 0 100 3    #替换值
add i 0 100 3        #新建变量，存在则报错
append i 0 100 3     #追加变量内容
stats                #查看状态
flush_all            #清空所有

#####################################################################
案例2：LNMP+Memcache
步骤1：搭建LNMP
步骤2:安装php与memcached的连接程序
     查看哪些包yum list | grep memca
     装扩展包php-pecl-memcache
     起服务php-fpm
步骤3：把php脚本拷贝到html下
####################################################################
案例3：proxy做代理服务器，web1，web2做后端服务器，搭建lnmp+Memcache
注意：需要把前面proxy下的LNMP+MEMCACHE 的配置注释掉
●批量注释的方法：Ctrl+v---->上下键------>shift + i----->输入#------> Esc
●session和cookie
client-------------------->web
                          sid[tom]session
cookie=sid 
client-------------------->web
浏览器发送sid------------->

●部署测试页面
1）部署测试页面(Web1服务器）。
测试页面可以参考lnmp_soft/php_scripts/php-memcached-demo.tar.gz。
2）登陆
[root@web1 ~]# firefox http://192.168.2.100            //填写账户信息
[root@web1 ~]# cd /var/lib/php/session/            //查看服务器本地的Session信息




























