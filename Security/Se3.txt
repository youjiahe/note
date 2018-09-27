
##################################################################################
审计

●审计记录日志：
a) 日期、事件、结果
b) 用户
c) 认证机制
d) 关键数据文件修改

●audit是linux自带审计软件
●jumpserver #国产审计软件

●文件
/etc/audit/auditd.conf
/var/log/audit/audit.log

●基本命令
auditctl -s #查看状态
auditctl -l #查看规则
auditctl -D #删除规则

●修改日志规则
临时：
auditctl -w /etc/ssh/sshd_config  -p wa -k ssh_ch
# 语法格式：auditctl  -w  path  -p  permission  -k  key_name
# path:文件或目录
# permission:r,w,x,a【属性变化】
# Key_name:标签，方便日志查找
永久：
修改配置文件，最后追加
vim /etc/audit/rules.d/audit.rules
-w /etc/ssh/sshd_config  -p wa -k ssh_ch

●日志字段
# type为类型
# msg为(time_stamp:ID)，时间是date +%s（1970-1-1至今的秒数）
# arch=c000003e，代表x86_64（16进制）
# success=yes/no，事件是否成功
# a0-a3是程序调用时前4个参数，16进制编码了
# ppid父进程ID，如bash，pid进程ID，如cat命令
# auid是审核用户的id，su - test, 依然可以追踪su前的账户
# uid，gid用户与组
# tty:从哪个终端执行的命令
# comm="cat"            用户在命令行执行的指令
# exe="/bin/cat"        实际程序的路径
# key="sshd_config"    管理员定义的策略关键字key
# type=CWD        用来记录当前工作目录
# cwd="/home/username"
# type=PATH
# ouid(owner's user id）    对象所有者id
# guid(owner's groupid）    对象所有者id

●日志过滤
ausearch -k ssh_change -i #-k,标签；-i,可读编译；

##################################################################################
加固常见服务的安全
##################################################################################
Nginx安全
●删除不需要的模块
 --without-http_ssi_module  #禁用服务器端包含ssi的模块
 --without-http_autoindex_module #无首页文件时，列出根目录下的所有文件，不安全
●查看网页头部信息
[root@room11pc19 sh]# curl -I www.nginx.org  #-I，只显示头部信息；-i，显示头部及页面

●隐藏nginx版本号
1、进入nginx配置文件的目录
在http 加上server_tokens off; 如
http {
server_tokens off;
}
●修改版本号显示内容
修改源码
# vim +48 src/http/ngx_http_header_filter_module.c   #+48，为直接进入48行
//注意：vim这条命令必须在nginx-1.12源码包目录下执行！！！！！！
//该文件修改前效果如下：
static .."Server: nginx" CRLF;
static .."Server: nginx" NGINX_VER CRLF;
static .."Server: nginx" NGINX_VER_BUILD CRLF;
//下面是我们修改后的效果：
static .."Server: JD" CRLF;
static .."Server: JD" CRLF;
static .."Server: JD" CRLF;

● 限制单个IP并发量
默认装ngx_http_limit_req_module，限制DDOS
配置文件
http{
.. ..
limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s  
                                  #zone=one:10m,1m可以存8千个IPv4; rate=1r/s:每秒响应1次请求；
}
   server {
    ..
   limit_req zone=one burst=5;    #burst=5，每秒处理1个请求，多与放进漏斗，其余不响应
 }
##################################################################################
httpd安全
get,post,delete,put,head
● 拒绝非法的请求
if($request_method !~ ^(GET|POST)){
   return 405;
}

curl -i -X HEAD 192.168.2.100
curl -i -X GET 192.168.2.100
●防止buffer溢出（用的时候复制）
当客户端连接服务器时，服务器会启用各种缓存，用来存放连接的状态信息。
如果攻击者发送大量的连接请求，而服务器不对缓存做限制的话，内存数据就有可能溢出（空间不足）。
修改Nginx配置文件，调整各种buffer参数，可以有效降低溢出风险。
http{
client_body_buffer_size  1K;
client_header_buffer_size 1k;
client_max_body_size 1k;
large_client_header_buffers 2 1k;
 … …
}
##################################################################################
数据库安全

● 初始化安全脚本
systemctl status mariadb
//确保服务已启动 
运行安全脚本:
mysql_secure_installation
根据提示进行回答

● 密码安全
明文修改不安全：
通过mysqldamin修改，则会显示在历史命令中
进入mysql修改，则会在/root/.mysql_history中记录
binlog日志里面会有明文密码，新版本软件修复了

● 数据备份
备份:
[root@proxy ~]# mysqldump -uroot -predhat mydb table > table.sql
//备份数据库中的某个数据表
[root@proxy ~]# mysqldump -uroot -predhat mydb > mydb.sql
//备份某个数据库
[root@proxy ~]# mysqldump -uroot -predhat --all-databases > all.sql
//备份所有数据库
还原:
[root@proxy ~]# mysql -uroot -predhat mydb  < table.sql            //还原数据表
[root@proxy ~]# mysql -uroot -predhat mydb  < mydb.sql            //还原数据库
[root@proxy ~]# mysql -uroot -predhat < all.sql                    //还原所有数据库

● 数据安全
参考案例
如何解决数据库明文传送？

可以使用SSH远程连接服务器后，再从本地登陆数据库（避免在网络中传输数据，因为网络环境中不知道有没有抓包者）。
或者也可以使用SSL对MySQL服务器进行加密，类似与HTTP+SSL一样，MySQL也支持SSL加密（确保网络中传输的数据是被加密的）。
##################################################################################
Tomcat安全
● 隐藏版本信息
部署Tomcat
#以下修改会出现在404报错界面：
yum -y install java-1.8.0-openjdk-devel
cd /usr/local/tomcat/lib
jar -xf catalina.jar
vim org/apache/catalina/util/ServerInfo.properties  #不记
更改 server.info=aaaaaa

#以下修改会出现在头部信息中：
配置文件：
<Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" server="iiiii"/>  #增加 "server="iiiii""

[root@web1 ~]# curl -I 192.168.2.100:8080
..
Server: iiii

● 降级启动
Tomcat默认以root启动，不安全，需要降级启动
useradd tomcat
chown tomcat:tomcat /usr/local/tomcat
su -c /usr/local/tomcat/bin/startup.sh tomcat
##################################################################################
使用diff和patch工具打补丁
●生成补丁包
  diff                    #查两个文件不一样
  diff -u 文件1 文件2         #显示如何将文件1，修改为文件2
  diff -u 文件1 文件2  > test.patch #生成补丁文件

  [root@web1 ~]# diff test1.sh test2.sh 
    2c2,3
    < echo "hello world"       #<,表示左文件
     ---
    > echo "hello the world"   #>,表示右文件
    > echo "test2"             
●打补丁
  yum -y install patch
  patch -p0 < test.patch      #根据头部信息打补丁，执行"diff -u"就会有头部信息 
  patch -RE -p0 < test.patch  #撤销补丁; p0,去多少层目录可以找到文件
##################################################################################
补丁案例
●环境准备
[root@proxy ~]# mkdir demo/source{1,2}
[root@proxy ~]# cd demo/
[root@proxy demo]# ls
source1  source2
[root@proxy demo]# echo "hello" > source1/test.sh
[root@proxy demo]# cp /bin/find source1/
[root@proxy demo]# echo "hello the world" > source2/test.sh
[root@proxy demo]# echo "test" > source2/tmp.txt
[root@proxy demo]# cp /bin/find source2/
[root@proxy demo]# echo 1 >> source2/find 
[root@proxy demo]# tree  #需要装包
.
├── source1
│   ├── find
│   └── test.sh
└── source2
    ├── find
    ├── test.sh
    └── tmp.txt
2 directories, 5 files

●diff -Nura #生成补丁
[root@proxy demo]# diff -Naru source1/ source2/ > patch
  选项：
 -u	输出统一内容的头部信息（打补丁使用），计算机知道是哪个文件需要修改
 -r	递归对比目录中的所有资源（可以对比目录）
 -a	所有文件视为文本（包括二进制程序）
 -N	无文件视为空文件（空文件怎么变成第二个文件）
 -N选项备注说明：见案例

●patch -p1 < ../patch   #打补丁

●md5sum                 #校验文件hash值
[root@proxy ~]# md5sum demo/source1/find demo/source2/find 
29b6030ce0d35abd03d089ce0c6f0b18  demo/source1/find
29b6030ce0d35abd03d089ce0c6f0b18  demo/source2/find





































































