问题点：
1.有什么软件不支持扩展正则？
2.nginx如何开机自启，尝试以下操作，不成功。
[root@web1 ~]# vim /etc/rc.d/rc.local
.. ..
for i in {1..20}
do
   netstat -utanlp | grep nginx
   [ $? -ne 0 ] && nginx
done
[root@web1 ~]# chmod +x /etc/rc.d/rc.local

3.SSL虚拟主机，有公钥，有私钥，有没有CA证书？
4.做curl，firefox访问不同页面的实验时。
  执行firefox 192.168.4.5，显示404 NOT FOUND，需要加上/index.html才会显示页面,解析下为什么？
5.生产环境中需要增加Nginx模块时，也需要重装吗，有没有方法可以不重装添加模块。
6.用Nginx做ssh调度器时，upstream下加上ip_hash,出现报错。为什么，有什么方法可以实现同样功能吗
[root@proxy conf]# nginx -s reload
nginx: [emerg] "ip_hash" directive is not allowed here in /usr/local/nginx/conf/nginx.conf:18

7.use epoll有什么具体作用？
8.把ab命令放到脚本运行后，不出现测试结果。为什么？

脚本内容：
#!/bin/bash
for i in {1..40}
do
   ab -c20000 -n100000 http://201.1.1.5/  '{print $3}'
done

####################################################################################
memcache(内存缓存)
redis(持久存储)

####################################################################################
●搭建以下拓扑

        /<-------------web1(nginx)
          |
proxy+memcache    
          |
        \<-------------web2(nginx)

步骤1：搭建proxy调度器
步骤2：web1，web2分别搭建LNMP+memcached
步骤3：客户机访问192.168.2.5/index.php  (用lnmp_soft/php_scripts/php-memcached-demo.tar.gz作为模版 )
步骤4：在页面重登陆用户
步骤5：telnet 192.168.2.5 11211
      get [Session ID]


########################################################################
●Tomcat 
用java写的网页

●JDK(工具箱，包含JAVA所有的包)
●最好第三方下载open-jdk
●JAVA是开放技术,原来属于(sun)可是已经被ORACLE收购了
●rhel7内置open-jdk
●JRE(JDK的子集)
  --包括核心类库
  --不包含开发工具，适合运维人员
●常见的Servlet容器
  --IBM      websphere
  --Oracle   weblogic
  --Apache   tomcat
  --Redhat   Jboss

补充
sun[java][openoffice][mysql]------->oracle------>apache
         libreoffice  mariadb

######################################################################
搭建Tomcat

●解包tar -xf apache-tomcat-8.0.30.tar.gz
●移动目录mv apache-tomcat-8.0.30 /usr/local/tomcat
●起服务 /usr/local/tomcat/bin/startup.sh
●确认端口：netstat -utanlp | grep java
  有8005，8080,8009端口信息就是正常的
  8009是用来连接httpd的
●Tomcat的端口号只需要定义一遍，下面的每一个虚拟主机都可以用
●/dev/random 系统自带的生成随机数的设备  #工作效率低，高的有/dev/urandom
cat /dev/random  | strings -n 10

●如果8005端口起得慢，则执行
mv /dev/random /dev/random.bak 
ln -s /dev/urandom /dev/random
        

●默认网页根目录
/usr/local/tomcat/webapps/ROOT/
●默认首页文件
index.jsp

#######################################################################
●自定义tomcat java页面
严格区分大小写
test.jsp
<html>
    <body bgcolor=black>
        <center>
            <h1>Now time is:<%=new java.util.Date()%></h1>
        </center>
   </body>
</html>
#######################################################################
●Tomcat配置文件

vim /usr/local/tomcat/conf/server.xml
-------------------------------------------------------------------------------------------------------------
<Server>
    <Service>
           <Connector port=8080 />  #端口号只需要定义一遍，下面的每一个虚拟主机都可以用
           <Connector port=8009 />  
           <Engine defaulthost="www.b.com">  #确定默认网站
              <Host name="www.a.com" appBase="a">
           </Host>
</Engine>
</Service>
</Server>
-------------------------------------------------------------------------------------------------------------
●xml文件格式，两种

第一种(属性多)：
<women>
name=tom
age=16
</women>

第二种：(属性少)
<women name=tom age=16 />

#############################################################################
●Tomcat虚拟主机  #appbase定义
	<Host name="www.a.com" appbase="a" .. />
	</Host>
	[root@web1 ~]# echo "root" > /usr/local/tomcat/a/ROOT/index.html
	[root@web1 ~]# /usr/local/tomcat/bin/shutdown.sh
	[root@web1 ~]# /usr/local/tomcat/bin/startup.sh
#############################################################################
●修改www.b.com网站的首页目录为base #docbase,可以修改网页根目录

1）使用docBase参数可以修改默认网站首页路径
	[root@web1 ~]# vim /usr/local/tomcat/conf/server.xml
	… …
	<Host name="www.b.com" appBase="b" unpackWARS="true" autoDeploy="true">
	<Context path="" docBase="base" reloadable="true"/>
	</Host>
	… …
	[root@web1 ~]# mkdir  /usr/local/tomcat/b/base
	[root@web1 ~]# echo "BASE" > /usr/local/tomcat/b/base/index.html
	[root@web1 ~]# /usr/local/tomcat/bin/shutdown.sh
	[root@web1 ~]# /usr/local/tomcat/bin/startup.sh

●Host与Host之间可以有很多个<Context>
#############################################################################
●访问www.a.com/test时，页面自动跳转到/var/www/html目录下的页面
  [root@web1 ~]# vim /usr/local/tomcat/conf/server.xml
	… …
	<Host name="www.a.com" appBase="a" unpackWARS="true" autoDeploy="true">
	<Context path="/test" docBase="/var/www/html/" />
	</Host>
	… …
	[root@web1 ~]# echo "Test" > /var/www/html/index.html
	[root@web1 ~]# /usr/local/tomcat/bin/shutdown.sh
	[root@web1 ~]# /usr/local/tomcat/bin/startup.sh
#############################################################################
●SSL虚拟主机
命令选项帮助

	1）创建加密用的私钥和证书文件(不需要死记)
	keytool -genkeypair -help
	# keytool -genkeypair -alias tomcat -keyalg RSA -keystore /usr/local/tomcat/keystore                //提示输入密码为:123456
	//-genkeypair     生成密钥对
	//-alias tomcat     密钥别名
	//-keyalg RSA     定义密钥算法为RSA算法
	//-keystore         定义密钥文件存储在:/usr/local/tomcat/keystore

	2）密钥文件/usr/local/tomcat/keystore

	3）修改配置文件(去掉注释，加两句话)
	只要定义一个<Connectorport>,全部虚拟主机都有效

	<!--
		<Connector port="8443" protocol=".. ..".....
		  keystoreFile="/usr/local/tomcat/     keystore" keystorePass="123456"/>
		-->

#############################################################################
●更改访问日志名字                           #只需要在对应虚拟主机，加上<Valve... />
	<Valve ..directory="aa"
	prefix="www_a" suffix="log"      #主要更改这几个参数
	/>

	[root@jiahe ~]# ls /usr/local/tomcat/aa/  #日志文件存在 directory 定义目录下
	base  www_a.2018-11-16.log

#############################################################################
●补充：
stings 
-n：指定生成字符串长度

例子:
cat /dev/urandom | strings -n 10| head -10

##############################################################################
●varnish

nginx【代理】             #适合做集群
varnish【代理】+缓存         #适合做缓存服务器，加速服务器，缓存服务器的数据
●默认缓存到内存

	例子：优酷总部在北京，主服务器也在北京。
	为了不需要全球都跑过来访问北京的主服务器，减轻压力。
	可以在世界各地搭建Varnish代理服务器。
	就可以在任何时候，缓存主服务器的数据，
	当地用户需要看视频时，就可以近距离高速地访问网站

●结合 DNS 分离解析可以做到不同地方访问不同的服务器，就近原则
[root@room11pc19 ~]# nslookup www.tmooc.cn
Server:		176.121.0.100
Address:	176.121.0.100#53

Name:	www.tmooc.cn
Address: 123.59.57.97

[root@room11pc19 ~]# nslookup www.tmooc.cn 8.8.8.8   #8.8.8.8为香港的DNS服务器
Server:		8.8.8.8
Address:	8.8.8.8#53

Non-authoritative answer:
Name:	www.tmooc.cn
Address: 120.132.94.115
################################################################################
●部署varnish
源码包

●步骤1：因此必须先装依赖包
1)gcc 
2)readline-devel 
3)ncurses-devel pcre-devel
4)python-docutils-0.11-0.2.20130715svn7687.el7.noarch.rpm 

●步骤2：创建用户varnish 禁止登陆

●步骤3：安装varnish源码包
装完会有以下命令
[root@proxy varnish-5.2.1]# varnish<tab><tab>
varnishadm   varnishhist  varnishncsa  varnishtest  
varnishd     varnishlog   varnishstat  varnishtop

●步骤4：在源码包目录下，把 etc/example.vcl拷贝到/etc下（文件名任意）
cp etc/example.vcl  /etc/varnish.conf

●步骤5：修改配置文件/etc/varnish.conf
backend default {
     .host = "192.168.2.100"; #改为需要的
     .port = "80";
 }

●步骤6：起服务
varnishd  -f /etc/varnish.conf
//varnishd命令的其他选项说明如下：
//varnishd –s malloc,128M                #定义varnish使用内存作为缓存，空间为128M
//varnishd –s file,/var/lib/varnish_storage.bin,1G #定义varnish使用文件作为缓存

●步骤7：更新缓存数据，可以实时地更新数据
[root@proxy ~]# varnishadm  
varnish> ban req.url ~ .*
//清空缓存数据，支持正则表达式

●步骤8：查看varnish日志
[root@proxy ~]# varnishlog                        //varnish日志，排错用的
[root@proxy ~]# varnishncsa                        //访问日志，



















