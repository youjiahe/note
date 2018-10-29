
##################################################################################
●监控的目的
报告系统运行状况
  --CPU负载，内存
   --网站吞吐量，使用率
提前发现问题
  --报警
  --找出系统瓶颈

●监控资源类别
  公有数据
  -web、FTP、SSH、数据库
  -TCP或UDP端口
  私有数据
  -CPU、内存、磁盘、网卡流量
   -用户、进程

●系统监控命令
补充：iostat  #查看磁盘性能，读写速度

●监控软件
  Cacti  #强大的绘图能力，报警机制差；适合监控网站，基于SNMP协议
  Nagios #强大的报警机制，绘图能力弱；
  Zabbix #强大的绘图能力，良好的报警机制；支持分布式监控
●监控软件的作用
  过滤出数据，并作图
##################################################################################
部署Zabbix服务器

●步骤1：搭建LNMP
    fastcgi_buffers 8 16k;                      //缓存php生成的页面内容，8个16k
    fastcgi_buffer_size 32k;                      //缓存php生产的头部信息
    fastcgi_connect_timeout 300;                 //连接PHP的超时时间
    fastcgi_send_timeout 300;                     //发送请求的超时时间
    fastcgi_read_timeout 300;                        //读取请求的超时时间
●步骤2：部署Zabbix软件
安装Zabbix依赖包
net-snmp-devel #监控网络数据,可以监控网络设备(交换机，路由器)
curl-devel     #监控公有数据
libevent-devel #类似于use epoll，提供处理事件的方法

安装源码包
tar -xf zabbix-3.4.4.tar.gz
./configure \
--enable-server \ #安装监控服务器.客户端不需要
--enable-proxy \  #分布式监控需要装这个包
--enable-agent \  #被监控软件，有监控自己的需求
--with-mysql=/usr/bin/mysql_config \ #程序，可以获得mysql的重要路径
--with-libcurl \  #启动监控公有数据功能
--with-net-snmp   #启动监控网络数据公您呢个

安装完成后查看命令
zabbix_<Tab><Tab>
zabbix_agentd  
zabbix_get      #从客户端获取数据
zabbix_proxy   
zabbix_sender   #发送数据到客户端
zabbix_server  

●步骤3：初始化Zabbix数据库
建立zabbix库
mysql> create database zabbix character set utf8;
创建用户管理该库
mysql> grant all on zabbix.* to zabbix@'localhost' identified by 'zabbix';

●步骤4：导入zabbix数据库————初始化Zabbix
源码包含Zabbix数据库
cd lnmp_soft/zabbix-3.4.4/database/mysql/
mysql -uzabbix -pzabbix zabbix < schema.sql
mysql -uzabbix -pzabbix zabbix < images.sql
mysql -uzabbix -pzabbix zabbix < data.sql

●步骤5:部署Zabbix页面
源码包含Zabbix的Web页面
cd lnmp_soft/zabbix-3.4.4/frontends/php/
cp -r * /usr/local/nginx/html/
chmod -R 777 /usr/local/nginx/html/*

●步骤6:修改服务端配置文件/usr/local/etc/zabbix_server.conf
vim /usr/local/etc/zabbix_server.conf
------------------------------------------------------------------------------------------------------
DBHost=localhost  #数据库主机，默认该行被注释
DBName=zabbix     #数据库名称
DBUser=zabbix     #数据库账户
DBPassword=zabbix #数据库密码，默认该行被注释
LogFile=/tmp/zabbix_server.log    #日志路径
------------------------------------------------------------------------------------------------------

●步骤9:起服务，查端口
useradd -s /sbin/nologin zabbix   #不创建用户无法启动服务
zabbix_server                     #起服务
ss -utanlp | grep zabbix_server   #确认zabbix，端口10051状态
tcp  LISTEN   0    128   *:10051      *:*      users:

●步骤10:访问安装检测页面
192.168.2.5/setup.php
##################################################################################
Zabbix服务端安装检查

软件修复
●依赖包不足错误
php-gd        #画图用的依赖包
php-xml       #画图用的依赖包
php-bcmath    #运算支持包
php-mbstring  #字符处理支持包
●PHP配置文件错误
vim /etc/php.ini   #内容参考页面fail项
<--------------------------------
672 post_max_size = 16M
384 max_execution_time = 300
394 max_input_time = 300
878 date.timezone = Asia/Shanghai
--------------------------------->
●在登陆页面
用户:admin
密码:zabbix
语言设为中文
##################################################################################
配置服务器为被监控端

●修改服务端代理配置文件
vim /usr/local/etc/zabbix_agentd.conf
------------------------------------------------------------------------------------------------------
Server=127.0.0.1,192.168.2.5           #允许哪些主机监控本机
ServerActive=127.0.0.1,192.168.2.5     #允许哪些主机通过主动模式监控本机
Hostname=zabbix_server                 #设置本机主机名
LogFile=/tmp/zabbix_server.log         #设置日志文件
UnsafeUserParameters=1                 #是否允许自定义脚本，集成到里面
------------------------------------------------------------------------------------------------------
●起服务，确认端口
zabbix_agentd                          #启动监控agent
ss -utanlp | grep zabbix_agentd        #确认10050端口
##################################################################################
配置客户机为被监控端
●部署被监控端Zabbix软件
useradd -s /sbin/nologin  zabbix
yum -y install gcc pcre-devel
tar -xf zabbix-3.4.4.tar.gz 
cd zabbix-3.4.4/
./configure --enable-agent
make && make install 

●修改agent配置文件，启动Agent
vim /usr/local/etc/zabbix_agentd.conf
------------------------------------------------------------------------------------------------------
Server=127.0.0.1,192.168.2.5           #谁可以监控本机（被动监控模式）
ServerActive=127.0.0.1,192.168.2.5     #谁可以监控本机（主动监控模式）
Hostname=zabbixclient_web1             #被监控端自己的主机名
EnableRemoteCommands=1    
#监控异常后，是否允许服务器远程过来执行命令，如重启某个服务
UnsafeUserParameters=1                 #是否允许自定义key监控
------------------------------------------------------------------------------------------------------
abbix_agentd                           #启动agent服务
##################################################################################
配置监控属性
192.168.2.5/index.php 
配置----主机----创建主机
查看监控内容
监测中------最新数据
●创建主机      #图形
●监控模版      #绑定主机
●应用集        #绑定监控项目
●监控项

##################################################################################
配置自定义监控
●web1操作  #被监控端
vim /usr/local/etc/zabbix_agentd.conf
Include=/usr/local/etc/zabbix_agentd.conf.d/      //取消注释，加载配置文件目录
●书写配置文件
cd /usr/local/etc/zabbix_agentd.conf.d/
vim 文件名
UserParameter=文件名,命令

●书写配置文件
服务端测试自定义监控
zabbix_get -s 192.168.2.100 -k 文件名   
##################################################################################
配置自动刷新监控
●创建监控模版
●创建应用集
●创建监控项  #绑定上面的文件
●创建图形
●主机添加该模版

























