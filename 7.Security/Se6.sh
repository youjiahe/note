1.VM1用test1用户登陆系统，使用su命令切换为test2账户，在tmp下创建一个文件（非交互式）,为什么提示需要密码
[test1@vm1 ~]$ su - test2 -c "touch /tmp/test2.txt"
密码：
2.修改txt的文件内容，文件属性没改(权限)，ctime也会变，为什么？
3.http_ssi_module有什么作用
4.以下命令结果的"@@ -1,2 +1,3 @@"，有什么含义？
[root@web1 ~]# diff -u test1.sh  test2.sh 
--- test1.sh	2018-09-01 17:36:00.237559570 +0800
+++ test2.sh	2018-09-01 17:36:29.135559570 +0800
@@ -1,2 +1,3 @@
5.Nginx优化并发量时，要改内核参数；Zabbix服务器的搭建也需要优化Nginx的fastcgi缓存参数，等等例子；每次听到缓存，内核，CPU，内存等硬件相关内容时，都觉得比较抽象。希望听到丁大神讲讲计算机工作的原理，过程，举些例子
6.配置了主动监控的主机web2，自动地就不能监控了，为什么？

##################################################################################
以下所有配置都是图形的，参看案例
##################################################################################
Zabbix报警

●自定义监控默认不会自动报警，需要配置触发器
●概念
触发器(trigger)------------条件
动作(action)-----------------执行

●触发器表达式
{<server>:<key>.<function>(<parameter>)}<operator>
<constant>

●步骤1：添加触发器
  --报警级别
  Severity(报警级别)
  Not classified   #未分类
  Information      #
  Warning
  Average
  High
  Disaster
  时间偏移量
  Time shift

●步骤2：设置邮件
  1）创建Media
  通过Administration（管理）-->Media Type（报警媒体类型）-->选择Email（邮件）
  2)为用户添加Media
  在Administration（管理）-->Users（用户）中找到选择admin账户


●步骤3：创建Action动作
  1）Action动作
  Action（动作）是定义当触发器被触发时的时候，执行什么行为。
  通过Configuration（配置）-->Actions（动作）-->Create action（创建动作）

  2）配置Action动作的触发条件
  填写Action动作的名称，配置什么触发器被触发时会执行本Action动作（账户数量大于26）

  3）配置Action动作的具体行为
  配置动作的具体操作行为（发送信息或执行远程命令），无限次数发送邮件，60秒1次，发送给Admin用户


##################################################################################
Zabbix自动发现主机

●自动发现可以实现：
自动发现、添加主机，自动添加主机到组；
自动连接模板到主机，自动创建监控项目与图形等。

●自动发现（Discovery）流程：
创建自动发现规则
创建Action动作，说明发现主机后自动执行什么动作
通过动作，执行添加主机，链接模板到主机等操作

##################################################################################
Zabbix主动监控

被动监控：Server向Agent发起连接，发送监控key，Agent接受请求，响应监控数据。
主动监控：Agent向Server发起连接，Agent请求需要检测的监控项目列表，Server响应Agent发送一个items列表，Agent确认收到监控列表，TCP连接完成，会话关闭，Agent开始周期性地收集数据。

●被监控端配置：
/usr/local/etc/zabbix_agentd.conf
Server=192.168.2.5  #被动监控 需要注释掉
StartAgents=0       #被动监控时启动多个进程
                          #设置为0，则禁止被动监控，不启动zabbix_agentd服务
ServerActive=192.168.2.5
                          #允许哪些主机监控本机（主动模式），一定要取消127.0.0.1
Hostname=zabbixclient_web #告诉监控服务器，是谁发的数据信息
                                 #一定要和zabbix服务器配置的监控主机名称一致
RefreshActiveChecks=120   #默认120秒检测一次
UnsafeUserParameters=1    #允许自定义key
Include=/usr/local/etc/zabbix_agentd.conf.d/


●监控端配置：图形操作，参考案例

##################################################################################
拓扑图
配置--------拓扑图
##################################################################################
聚合图形

##################################################################################
多参数自定义监控项

案例：监控页面状态数据

被监控端：192.168.2.100（web1）
●安装模块
http_stub_status模块
修改nginx配置文件
------------------------------------------------
location /status {
        stub_status on;
    }
------------------------------------------------
●curl 访问nginx状态监控
 # curl http://127.0.0.1/status
Active connections: 11921           #当前nginx正在处理的活动连接数.
server accepts handled requests     #总共处理了11989个连接 , 成功创建11989次握手, 
 11989 11989 11991 1930854          #总共处理了11991个请求，总处理时间为1930854毫秒
Reading: 0 Writing: 7 Waiting: 42

//Reading: nginx读取到客户端的Header信息数.
//Writing: nginx返回给客户端的Header信息数.
//Waiting: 开启keep-alive的情况下,这个值等于 active – (reading + writing),
         意思就是nginx已经处理完成,正在等候下一次请求指令的驻留连接。
         
●书写监控脚本
curl -s #不输出流量信息
-----------------------------------------------------------------------------
#!/bin/bash
url="192.168.2.5/status"
case $1 in
act)
    curl -s $url | awk '/Active/{print $3}';;
req)
    curl -s $url | awk 'NR==3{print $NF}';;
wait)
    curl -s $url | awk '/Waiting/{print $NF}';;
esac
-----------------------------------------------------------------------------
●参数传递
UserParameter=key[*],<command>
key里的所有参数，都会传递给后面命令的位置变量
UserParameter=ping[*],echo $1
ping[0]，	返回的结果都是0
ping[aaa]，	返回的结果都是aaa

●书写监控项文件
/usr/local/etc/zabbix_agentd.conf.d/nginx.status
-----------------------------------------------------------------------------------------------------------------
UserParameter=nginx.status[*],/usr/local/bin/nginx_status.sh $1
-----------------------------------------------------------------------------------------------------------------


监控端：192.168.2.5（zab_server）
●命令行测试
zabbix_get -s 192.168.2.100 -k nginx.status[req]
zabbix_get -s 192.168.2.100 -k nginx.status[act]
zabbix_get -s 192.168.2.100 -k nginx.status[wait]

##################################################################################
监控网络连接状态

单工：
全双工：
ss -tanlp | grep 22  #只检查tcp的
ESTAB   #已连接的

--------------------------------------------------------------
TCP三次握手：
    A                  B
SYN_SEND    
             SYN    SYN_RCVD
           SYN,ACK
ESTABLISH    
             ACK    ESTABLISH
--------------------------------------------------------------
TCP四次断开：
    A                   B
FIN_WAIT1
           FIN ACK  CLOSE_WAIT
               ACK
FIN_WAIT2      
                     LAST_ACK
             FIN
TIME_WAIT
             ACK     CLOSED
CLOSED
--------------------------------------------------------------
●为什么TCP协议终止链接要四次？
1、当主机A确认发送完数据且知道B已经接受完了，想要关闭发送数据口（当然确认信号还是可以发），就会发FIN给主机B。
2、主机B收到A发送的FIN，表示收到了，就会发送ACK回复。
3、但这是B可能还在发送数据，没有想要关闭数据口的意思，所以FIN与ACK不是同时发送的，而是等到B数据发送完了，才会发送FIN给主机A。
4、A收到B发来的FIN，知道B的数据也发送完了，回复ACK， A等待2MSL以后，没有收到B传来的任何消息，知道B已经收到自己的ACK了，A就关闭链接，B也关闭链接了。

●A为什么等待2MSl，从TIME_WAIT到CLOSE？
    在Client发送出最后的ACK回复，但该ACK可能丢失。Server如果没有收到ACK，将不断重复发送FIN片段。所以Client不能立即关闭，它必须确认Server接收到了该ACK。Client会在发送出ACK之后进入到TIME_WAIT状态。Client会设置一个计时器，等待2MSL的时间。如果在该时间内再次收到FIN，那么Client会重发ACK并再次等待2MSL。所谓的2MSL是两倍的MSL(Maximum Segment Lifetime)。MSL指一个片段在网络中最大的存活时间，2MSL就是一个发送和一个回复所需的最大时间。如果直到2MSL，Client都没有再次收到FIN，那么Client推断ACK已经被成功接收，则结束TCP连接。























