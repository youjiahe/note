#题目比较全的网址
https://blog.csdn.net/fsx2550553488/article/details/80603497  
http://blog.51cto.com/hujiangtao/1940375
#查看系统负载命令
https://blog.csdn.net/fsx2550553488/article/details/82053051
#mysql数据库占cpu过高问题
https://blog.csdn.net/sjhnanwang/article/details/37883147
https://blog.csdn.net/nuli888/article/details/52435807
#Python面试题
https://mp.weixin.qq.com/s?__biz=MzA3NzIwNDg3NQ==&mid=2649971855&idx=1&sn=46dca7fb20fe0ec64d3ab3ad88dd6721&chksm=8752606bb025e97d9d55f133768b71f6dad76292d6349ec9ba453e79942b2a5700cf270d4c71&mpshare=1&scene=23&srcid=0716eFGeqS982p33kldeM4uZ&pass_ticket=gll6PzEJT%2FLDJpgg5eIlZUab3WcYZ%2FPz4wuL2VzBfZXhV1HDZ5KKjTIQPFlk1%2FUr#rd
##################################################################################
●如何控制容器占用系统资源的份额？  #更详细请看网上知识文件夹下的《docker资源配额》
docker run -tid –cpu-shares 100 centos:latest  #在创建容器时指定容器所使用的CPU份额值，权重值0
docker run -tid –cpu-period 1000000 –cpu-quota 200000 centos #容器进程每1秒使用单个CPU的0.2秒时间
##################################################################################
●如何修改docker默认存储设置
	如果是centos7：

	修改docker.service文件，使用-g参数指定存储位置

	vi /usr/lib/systemd/system/docker.service  

	ExecStart=/usr/bin/dockerd --graph /new-path/docker 

	 // reload配置文件 

	systemctl daemon-reload 

	 // 重启docker 

	systemctl restart docker.service

	//查看 Docker Root Dir: /var/lib/docker是否改成设定的目录/new-path/docker 

	docker info
##################################################################################
●Docker镜像构建的优化总结   #自动化运维非常重要的工具
 一、镜像最小化
	1、选择最精简的基础镜像
		选择体积最小的基础镜像可有效降低镜像体积。如：alpine、busybox等
	2、清理镜像构建的中间产物。
		构建镜像的过程中，当dockerfile的指令执行完成后，删除镜像不需要用的的文件。
		如使用yum安装组件，最后可使用yum clean all镜像清理不需要的文件
	3、减少镜像的层数
		镜像是一个分层存储的文件，并且镜像对层数也是有一定数量的限制，
		当前镜像的层数最高是127层，如果不多加注意，将会导致镜像越来越臃肿。
		在使用dockerfile构建镜像时，dockerfile中的每一条指令都会生成一个层，
		因此可以通过合并dockerfile中可合并的指令，减少最终生成镜像的层数。
		例如：在dockerfile中使用RUN执行shell命令是，可以用"&&"将多条命令连接起来。

二、构建速度最快化
	1、充分利用镜像构建缓存
		我们可以利用构建的缓存来加快镜像构建速度，Docker构建默认会开启缓存，
		缓存生效有三个关键点，镜像父层没有发生变化，构建指令不变，添加文件校验和一致。
		只要一个构建指令满足这三个条件，这一层镜像构建就不会再执行，它会直接利用之前构建的结果。
	
	2、删除构建目录中（默认：Dockerfile所在目录）不需要用的的文件。

	3、注意优化网络请求
		我们使用一些镜像源或者在dockerfile中使用互联网上的url时，
		去用一些网络比较好的开源站点，这样可以节约时间、减少失败率

三、dockerfile指令优化
	1.尽量使用COPY，少用ADD；
           因为使用ADD命令时，会创建更多的镜像层，当然镜像的也会更大； 官方推荐wget、curl代替ADD从远程拷贝文件
	2.CMD 与 ENTRYPOINT的区别
		2.1 CMD应该尽量使用 JSON 格式
		2.2 当需要把容器当作命令行使用，推荐通过 ENTRYPOINT 指令设置镜像入口程序
	http://blog.51cto.com/aaronsa/2132222
##################################################################################
●为什么要使用 Docker? 使用 Docker 能给企业带来哪些好处?
	1、更简单、更快速、更易用:
	 &更加简单： 与虚拟机相比,部署多个应用无需安装创建多个虚拟机,安装多个操作系统,所有的应用模块都寄存
		      于宿主机的操作系统,共享宿主机硬件资源,多个应用模块类似于宿主机上多个“应用进程”;
	 & 更加快速：与虚拟机相比,容器的启动、停止等能都实现秒级的速度,从而实现业务系统服务的快速弹性扩展;
	 & 更加易用：所有的运维基础服务(如 mysql redis 等)以及公司自有模块都可以随意封装为镜像,
		      只要有宿主机系统环境,就可以无需部署,直接启动服务,从而实现“一次封装,到处运行”;
	2、更灵活的硬件资源调整、管控:
		所有容器能够针对 CPU,内存、磁盘 IO、网络等进行更细化的调整控制,让所有容器更能充分利用
		宿主机的硬件资源;
	3、透明部署,促进企业实现真正的 DevOps:
		docker 的出现,让运维、测试、研发等企业技术人员,都在一个环境下进行业务发布流程,
		避免环境部署带来的各种问题，实现真正的企业内部业务系统的“透明部署”,
		简化了技术部门产品发布的流程;
##################################################################################
●Docker 镜像、容器、仓库
	Docker镜像：类似于虚拟机的镜像，是一个面向Docker引擎的只读模板，包含了文件系统。

	Docker容器：通过Docker镜像实例化的一个可运行的简易版的Linux系统环境。

	Docker仓库：是Docker集中存放镜像文件的场所。
##################################################################################
●docker四种网络模式
	1 host模式
	2 container模式
	3 none模式
	4 bridge模式
##################################################################################
Dockerfile指令
	FROM	<image>：基础镜像，这个是Dockerfile的开始
	MAINTAINER ：作者信息
	RUN：指定当前镜像中运行的命令
	EXPOSE：指定运行该镜像开启的端口号
	CMD：指定容器运行的行为
	ADD：将文件或者目录复制到docker容器中，包含解压缩功能
	COPY：将文件或者目录复制到docker容器中，单纯的复制
	VOLUME：向基于镜像的容器添加卷，可以存在于一个或者多个目录，可以绕过联合文件系统，提供共享数据或者数据持久化的功能
	WORKDIR：在容器内部设置工作目录
	ENV：设置环境变量
	USER：指定镜像以什么用户身份运行，默认是root
##################################################################################
●mysql的innodb如何定位锁问题:
  死锁一般是事务相互等待对方资源，最后形成环路造成的。

  在使用 show engine innodb status检查引擎状态时，发现了死锁问题
  在打印出来的信息中找到“LATEST DETECTED DEADLOCK”一节内容，看图中红线

  在5.5中，information_schema 库中增加了三个关于锁的表（MEMORY引擎）

  innodb_trx         ## 当前运行的所有事务，找出线程号与  上述命令一致且状态为sleep的进程号

  innodb_locks     ## 当前出现的锁

  innodb_lock_waits  ## 锁等待的对应关系
##################################################################################
●主从延迟原因及解决
  原因：
    1.单线程同步数据；
        数据库版本是5.6前的；
    2.网络延迟；
    3.硬件性能，从库比主库差太多；
    4.日志参数，写入、刷新策略太安全，不适用于并发量大的场合；
    5.MyISAM表较多，锁冲突
  解决方法：
    1.1单线程转为多线程；调整参数解决；
    1.2升级数据库到5.6或以上版本
    2.网络设备升级；部署链路聚合；
    3.服务器硬件升级；或部署专用的同步服务器
    4.调整日志相关参数，使其释放更多的磁盘IO的同时，不影响并发访问性能。
    5.根据实际调整使用MyISAM的表数量
##################################################################################
●SQL的四大功能：

	数据定义：DDL(data definition language)，定义三大模式结构、两级映射、约束等。以CREATE、ALTER、DROP、COMMIT、TRUNCATE等为主
	数据操作：DML(data manipulation language)，增删改查等功能，以INSERT、UPDATE、DELETE、SELECT、LOCK等主为
	数据控制：DCL(data control language )，包括对基本表和视图的授权，完整性规则的描述，事务控制等内容，以GRANT、REVOKE等为主
	事务操作：DTL 事务命令 roll back
##################################################################################
●MyISAM和InnoDB的主要区别和应用场景
	— 主要区别
		MyISAM是非事务安全型的，而InnoDB是事务安全型的。
		MyISAM锁的粒度是表级，而InnoDB支持行级锁定。
		MyISAM支持全文类型索引，而InnoDB不支持全文索引。
		MyISAM不支持外键，而InnoDB支持外键。
		MyISAM相对简单，所以在效率上要优于InnoDB，小型应用可以考虑使用MyISAM。
		MyISAM表是保存成文件的形式，在跨平台的数据转移中使用MyISAM存储会省去不少的麻烦。
		InnoDB表比MyISAM表更安全，可以在保证数据不会丢失的情况下，切换非事务表到事务表
	
	— 应用场景
		& MyISAM管理非事务表。它提供高速存储和检索，以及全文搜索能力。
		   如果应用中需要执行大量的SELECT查询，那么MyISAM是更好的选择。
		   
		& InnoDB用于事务处理应用程序，具有众多特性，包括ACID事务支持。
		   如果应用中需要执行大量的INSERT或UPDATE操作，则应该使用InnoDB，
		   这样可以提高多用户并发操作的性能。
##################################################################################
●MySQL binlog的几种日志录入格式以及区别

Mysql的二进制日志格式：
	基于语句：statement，对语句进行了简单的记录
	基于行数据：row，有些数据在不同环境执行可能会有不同结果
	混合：mixed，musql自身提供鉴别机制，根据判断执行STATEMENT还是ROW
##################################################################################
●mysql数据库占cpu过高问题
https://blog.csdn.net/sjhnanwang/article/details/37883147
https://blog.csdn.net/nuli888/article/details/52435807

步骤：
& 1、通过show processlist找到耗时最长的
mysql> show processlist;
+----+------+-----------------+------+---------+------+--------------+------------------------------------------------------------------------------------------------------+
| Id | User | Host            | db   | Command | Time | State        | Info                                                                                                 |
+----+------+-----------------+------+---------+------+--------------+------------------------------------------------------------------------------------------------------+
| 19 | root | localhost:60604 | big  | Query   | 1533 | Sending data | SELECT count(*) num,city FROM `ih_user_temp` where city in (select city from ih_user_temp where city |
| 25 | root | localhost       | NULL | Query   |    0 | NULL         | show processlist                                                                                     |
+----+------+-----------------+------+---------+------+--------------+------------------------------------------------------------------------------------------------------+
2 rows in set (0.00 sec)

& 2、先杀掉该进程
mysql> kill 19;
Query OK, 0 rows affected (0.01 sec)

& 3、通过慢查询日志找到具体的sql语句

开启慢查询：
[mysqld]
slow_query_log=1  #开启慢查询
long_query_time=5 #慢查询时间
log-slow-queries = /var/log/mysql/slowquery.log #需有写入权限

& 4、使用explain 优化sql语句，参考：mysql使用explain优化sql语句
引起cpu过高的sql一般集中在order by、group by、批量insert、嵌套子查询等sql语句中

& 5、调整my.cnf的query_cache_size和tmp_table_size的值
##################################################################################
●redis的并发竞争问题如何解决
	方案一：可以使用独占锁的方式，类似操作系统的mutex机制。
	（网上有例子，http://blog.csdn.net/black_ox/article/details/48972085 
	不过实现相对复杂，成本较高）

	方案二：使用乐观锁的方式进行解决（成本较低，非阻塞，性能较高）
		如何用乐观锁方式进行解决？
		本质上是假设不会进行冲突，使用redis的命令watch进行构造条件。伪代码如下：
		watch price

		get price $price

		$price = $price + 10

		multi

		set price $price

		exec

		解释一下：
		watch这里表示监控该key值，后面的事务是有条件的执行，
		如果从watch的exec语句执行时，watch的key对应的value值
##################################################################################
●Nginx php-fpm 经常出现的错误是 502 和 504，分别出现在什么情况？
	502   （错误网关） 服务器作为网关或代理，从上游服务器收到无效响应。
	504   （网关超时）  服务器作为网关或代理，但是没有及时从上游服务器收到请求。 
##################################################################################	 
●Web项目上线流程
   1. 程序员提交代码更新到软件仓库(SVN/GIT) <-----------------+
  2. CI服务器基于计划任务查询仓库，并下载代码            |
  3. CI服务器运行构建过程并生成软件包(war包)             |
   4. 向开发团队发送构建通知 -------------------------------------------+
##################################################################################
●如何根据容器的名字列出容器状态
	docker status 容器id
##################################################################################
●Linux 开机过程
	1. BIOS     硬件检测，加载MBR
	2. MBR      存储BootLoader信息，加载GRUB
	3. GRUB     查找并加载kernel
	4. Kernel   装载驱动，挂载rootfs，执行/sbin/init
	5. Init     OS初始化，执行runlevel相关程序
	6. Runlevel 启动指定级别的服务
##################################################################################
●RedHat6版本与RedHat7版本区别
	1.引导程序
	   6： grub  7：grub2
	2.主机名q
	  6. /etc/sysconfig/network   HOSTNAME
	       sysctl  kernel.hostname
	   7  /etc/hostname  马上生效
	      hostnamectl
	3.上帝进程  
	    6：initd   7：systemd
	4.服务管理
	   6：  service chkconfig    7.systemctl  
	5.防火墙
	   6：iptables    7：firewalld
	6.普通用户uid
	   6：500   7：1000
##################################################################################
●修改内核如何生效
	sysctl -p
##################################################################################
● 如何优化 Linux系统（可以不说太具体）？

	1. 不用root，添加普通用户，通过sudo授权管理
	更改默认的远程连接SSH服务端口及禁止root用户远程连接
	定时自动更新服务器时间
	配置国内yum源
	关闭selinux及iptables（iptables工作场景如果有外网IP一定要打开，高并发除外）
	调整文件描述符的数量
	精简开机启动服务（crond rsyslog network sshd）
	内核参数优化（/etc/sysctl.conf）
	更改字符集，支持中文，但建议还是用英文字符集，防止乱码
	锁定关键系统文件
	清空/etc/issue，去除系统及内核版本登录前的屏幕显
##################################################################################
●软连接：
	保存了一个指向另一个文件的路径，软连接的大小就是文件路径的字符串大小。软连接特点：
	软链接，以路径的形式存在
	软链接可以 跨文件系统
	软链接可以对一个不存在的文件名进行链接
	软链接可以对目录进行链接
●硬连接：
	指向同一个inode号的不同文件名，同一个文件使用多个别名
	
	硬连接的特点：
	以文件副本的形式存在，但不占用实际空间
	目录无法创建硬链接
	硬连接不能跨文件系统

##################################################################################
● 描述下 raid0 raid1 raid10 raid5
raid0: 条带模式，2块以上磁盘；优点：并行写入，效率高；缺点:无数据冗余
raid1：镜像模式，2块以上磁盘；优点：数据冗余，可靠性高；缺点：成本高
raid10：raid1+raid0；4块以上磁盘；综合了raid1，raid0的优点：数据备份，数据并行写入；
raid5：高性价比模式，3块以上磁盘；有一块磁盘存储校验数据，允许坏一块磁盘； 缺点：写性能不好；

冗余从好到坏：RAID1 RAID10 RAID 5 RAID0
性能从好到坏：RAID0 RAID10 RAID5 RAID1
成本从低到高：RAID0 RAID5 RAID1 RAID10

单台服务器：很重要盘不多，系统盘，RAID1
数据库服务器：主库：RAID10 从库 RAID5\RAID0（为了维护成本，RAID10）
WEB服务器，如果没有太多的数据的话，RAID5,RAID0（单盘）
有多台，监控、应用服务器，RAID0 RAID5
##################################################################################
●git初始化和更新子模块
	git submodule init 初始化子模块
	git submodule update 更新子模块
##################################################################################
● keepalived工作原理
	Layer3,4,&5工作早IP/TCP协议栈的IP层，TCP层，及应用层
	原理：
	Layer3:keepalived使用layer3的方式工作时，keepalived会定期向服务器群中发送一个ICMP的数据包（即我们平时用的ping程序），如果发现某台服务器的IP地址没有激活，keepalived便会报告这台服务器是小，并将他从服务器群中剔除。Layer3的方式是以服务器的IP第孩子是否有效作为服务器工作正常与否的标准。

	Layer4:主要以TCP端口的状态来决定服务器工作正常与否。如web sercer的服务端口一般是80.如果keepalived检测到80端口没有启动，则keepalived将这台服务器从服务群中删除。

	Layer5:layer5就是工作载具体的应用层，比layer3,4要复杂一点，载网络上占用的宽带也要打一些。Keepalived将根据用户的设定检查服务器的运行是否正常。如果设定不相符，则keepalived将把服务器从群中踢除。
##################################################################################
●keepalive的工作原理和如何做到健康检查

	keepalived健康性检查是以VRRP协议为实现基础的，
	VRRP全称Virtual Router Redundancy Protocol，即虚拟路由冗余协议。
	虚拟路由冗余协议，可以认为是实现路由器高可用的协议，
	即将N台提供相同功能的路由器组成一个路由器组，这个组里面有一个master和多个backup，
	master上面有一个对外提供服务的vip（该路由器所在局域网内其他机器的默认路由为该vip），
	master会发组播，当backup收不到vrrp包时就认为master宕掉了，
	这时就需要根据VRRP的优先级来选举一个backup当master。这样的话就可以保证路由器的高可用了。

	keepalived主要有三个模块，分别是core、check和vrrp。
	core模块为keepalived的核心，负责主进程的启动、维护以及全局配置文件的加载和解析。
	check负责健康检查，包括常见的各种检查方式。
	vrrp模块是来实现VRRP协议的。

	Keepalived健康检查方式配置
##################################################################################
LVS Haproxy nginx 的区别，工作中的选择
请看 目录 网上的知识
##################################################################################
●网络访问整个流程

	如：在浏览器中输入www.baidu.com后执行的全部过程

	域名解析

	为了将消息从 客户端 上传到服务器上， 需要用到 IP 协议、 ARP 协议和 OSPF 协议。 

	发起 TCP 的 3 次握手 

	建立 TCP 连接后发起 http 请求 

	服务器响应 http 请求 

	浏览器解析 html 代码， 并请求 html 代码中的资源（如 js、 css、 图片等） 

	发起TCP的四次挥手，断开 TCP 连接 
##################################################################################
●在10.0.0.8/8中划分出3个子网，保证每个子网有4089个私有ip
##################################################################################
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
##################################################################################
●什么是VFS？
	vfs：linux虚拟文件系统，为各类文件系统提供了一个统一的操作界面和应用编程接口。
	VFS是一个可以让系统调用不用关心底层的存储介质和文件系统类型就可以工作的粘合层。
##################################################################################
●HTTP的工作过程：
	& 地址解析：包括协议名、主机名、端口、对象路径等部分
	& 封装HTTP请求数据包：把以上部分结合本机自己的信息，封装成一个HTTP请求数据包
	& 封装成TCP包，建立TCP连接：TCP的三次握手
	& 客户机发送请求命令：建立连接后，客户机发送一个请求给服务器，
	   请求方式的格式为：统一资源标识符（URL）、协议版本号，
	   后边是MIME信息包括请求修饰符、客户机信息和可内容。
	& 服务器响应：服务器接到请求后，给予相应的响应信息，
	   其格式为一个状态行，包括信息的协议版本号、一个成功或错误的代码，
	   后边是MIME信息包括服务器信息、实体信息和可能的内容。
	& 服务器关闭TCP连接
##################################################################################
●Apache与Nginx的优缺点比较 
	& nginx相对于apache的优点： 
		1. 轻量级，同样起web 服务，比apache 占用更少的内存及资源 
		2. 抗并发，nginx 处理请求是异步非阻塞的，而apache 则是阻塞型的，
			在高并发下nginx 能保持低资源低消耗高性能 ，从而解决C10K问题；
			apache是同步多进程模型，一个连接对应一个进程，nginx是异步的，
			多个连接（万级别）可以对应一个进程 
		3. 高度模块化的设计，编写模块相对简单 
		4. 社区活跃，各种高性能模块出品迅速啊 
		5. 可以做反向代理服务器、负载均衡服务器，
		
	& apache 相对于nginx 的优点： 
		1. rewrite 能力比nginx强大 
		2. 模块超多，基本想到的都可以找到 
		3. 稳定，少bug ，nginx 的bug 相对较多
		4. 处理动态请求的能力强
		 
	& 总结：需要性能的web服务，用nginx 。
	         如果不需要性能只求稳定，那就apache 
##################################################################################
● 讲述一下Tomcat8005、8009、8080三个端口的含义？
8005==》 关闭时使用
8009==》 为AJP端口，即容器使用，如Apache能通过AJP协议访问Tomcat的8009端口
8080==》 一般应用使用
##################################################################################
● 什么叫CDN？
- 即内容分发网络
- 其目的是通过在现有的Internet中增加一层新的网络架构，将网站的内容发布到
最接近用户的网络边缘，使用户可就近取得所需的内容，提高用户访问网站的速度
##################################################################################
● 有个客户说访问不到你们的网站，但是你们自己测试内网和外网访问都没问题。你会怎么排查并解决客户的问题？

笔者回答：我们自己测了都没问题，只是这个客户访问有问题，那肯定是要先联系到这个客户，
能远程最好，问一下客户的网络是不是正常的，访问其它的网站有没有问题（比如京东、百度什么的）。
如果访问其它网站有问题，那叫客户解决本身网络问题。
如果访问其它网站都没问题，用ping和nslookup解析一下我们的网站是不是正常的，
让客户用IP来访问我们的网站是否可行，如果IP访问没问题，那就是客户的DNS服务器有问题或者DNS服务器解析不到我们的网站。
还有一种可能就是跨运营商访问的问题，比如我们的服务器用的是北方联通、而客户用的是南方移动，就也有可能突然在某个时间段访问不到，这种情况在庞大的中国网络环境中经常发生（一般是靠CDN解决）。
还有可能就是我们的网站没有SSL证书，在公网是使用的是http协议，这种情况有可能就是没有用https协议网站被运营商劫持了。
##################################################################################
● 你会用什么方法查看某个应用服务的流量使用情况？
笔者回答：如果是单一应用的服务器，只需要用iftop、sar等工具统计网卡流量就可以。
如果服务器跑了多个应用，可以使用nethogs工具实现，它的特别之处在于可以显示每个进程的带宽占用情况，
这样可以更直观获取网络使用情况。

& 需要先装包：
	rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
	yum -y install nethogs
& 再使用

##################################################################################
● 谈下python的GIL
	GIL 是python的全局解释器锁，同一进程中假如有多个线程运行，
	一个线程在运行python程序的时候会霸占python解释器（加了一把锁即GIL），
	使该进程内的其他线程无法运行，等该线程运行完后其他线程才能运行。
	如果线程运行过程中遇到耗时操作，则解释器锁解开，使其他线程运行。
	所以在多线程中，线程的运行仍是有先后顺序的，并不是同时进行。

	多进程中因为每个进程都能被系统分配资源，相当于每个进程有了一个python解释器，
	所以多进程可以实现多个进程的同时运行，缺点是进程系统资源开销大
##################################################################################
一句话解释什么样的语言能够用装饰器?
	函数可以作为参数传递的语言，可以使用装饰器

##################################################################################
生成随机小数
	#（1）随机小数
	import random
	print(random.random())  #随机大于0 且小于1 之间的小数
	'''
	0.9441832228391154
	'''

	print(random.uniform(0,9))   #随机一个大于0小于9的小数
	'''结果：
	7.646583891572416
	'''
##################################################################################
● MTV模式  （很重要）
	•  Django的MTV模式本质上和MVC是一样的,也是为
		了各组件间保持松耦合关系,只是定义上有些许不同
		–  M 代表模型(Model):负责业务对象和数据库的关
			系映射(ORM)
		–  T 代表模板 (Template):负责如何把页面展示给用户
			(html)
		–  V 代表视图(View):负责业务逻辑,并在适当时候
			调用Model和Template
	•  除了以上三层之外,还需要一个URL分发器,
		它的作用是将一个个URL的页面请求分发给不同的View处理,
		View再调用相应的Model和Template
##################################################################################
● 实时抓取并显示当前系统中tcp 80端口的网络数据信息，请写出完整操作命令

tcpdump -nn tcp port 80

##################################################################################
●Python处理中文时出现错误
	import sys
	default_encoding = 'utf-8'
	if sys.getdefaultencoding() != default_encoding:
		 reload(sys)
		 sys.setdefaultencoding(default_encoding)
		 
●请写出一段python代码实现删除一个list里面的重复元素
  1.方法1：
	for i in list1:
		 if i not in list2:
			 list2.append(i)
		 else:
			  continue
	list1=list2
  2.方法2
     list(set(list))
##################################################################################
● 现在给你三百台服务器，你怎么对他们进行管理？
管理3百台服务器的方式：
1）设定跳板机，使用统一账号登录，便于安全与登录的考量。  LDAP
2）使用ansiable进行系统的统一调度与配置的统一管理。
3）建立简单的服务器的系统、配置、应用的cmdb信息管理。便于查阅每台服务器上的各种信息记录。 
##################################################################################
● 你对现在运维工程师的理解和以及对其工作的认识

运维工程师在公司当中责任重大，需要保证时刻为公司及客户提供最高、最快、最稳定、最安全的服务

运维工程师的一个小小的失误，很有可能会对公司及客户造成重大损失

因此运维工程师的工作需要严谨及富有创新精神

##################################################################################










