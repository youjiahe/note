MHA高可用集群
##################################################################################
部署高可用集群环境
●公共配置：在所有主机上安装软件软件包
]# cd  mha-soft-student
]# ls  *.rpm
mha4mysql-node-0.56-0.el6.noarch.rpm
perl-Config-Tiny-2.14-7.el7.noarch.rpm          
perl-Mail-Sender-0.8.23-1.el7.noarch.rpm       
perl-MIME-Types-1.38-2.el7.noarch.rpm
perl-Email-Date-Format-1.002-15.el7.noarch.rpm  
perl-Mail-Sendmail-0.79-21.el7.art.noarch.rpm  
perl-Parallel-ForkManager-1.18-2.el7.noarch.rpm
perl-Log-Dispatch-2.41-1.el7.1.noarch.rpm       
perl-MIME-Lite-3.030-1.el7.noarch.rpm
]# yum -y  install  *.rpm

#################################################################################
部署高可用集群Mysql环境
●拓扑结构
            master51
	        |
		|
______________________________________________________
  |		|         |         |		|              |
 slave52    slave53    slave54     slave55      mgm56 
(备用主库1)   (备用主库2)                                 Manager

●配置所有数据库主机之间可以互相以ssh密钥对方式认证登陆
  真机运行自己写的脚本
  fssh_key.sh   #在百度云盘，或者真机/root/sh
  fssh.sh       #在百度云盘，或者真机/root/sh
  
●配置主从同步,要求如下：
  51 主库	       开半同步复制
  52 从库（备用主库）  开半同步复制         #也需要启用binlog
  53 从库（备用主库）  开半同步复制         #也需要启用binlog
  54 从库 不做备用主库所以不用开半同步复制 
  55 从库 不做备用主库所以不用开半同步复制

●所有服务器上创建root在所有主机可以登陆
  mysql -uroot -p123456 -e "grant all on *.* to root@'%' identified by '123456';"
  mysql -uroot -p123456 -e "set global relay_log_purge=off;"   #自动删除中继日志无效
##################################################################################
配置Master51
●在主库上手动部署vip 地址   192.168.4.98
  [root@db51 ~]# ifconfig  eth0:1 192.168.4.98/24

  [root@db51 ~]# ifconfig  eth0:1  #使eth0单网卡多IP
  eth0:1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.4.98  netmask 255.255.255.0  broadcast 192.168.4.255
        ether 74:52:09:07:51:01  txqueuelen 1000  (Ethernet)
##################################################################################        
配置manager56主机
●配置manager56主机 无密码ssh登录 所有数据库主机
●在主机mgm56上安装管理工具
  ]# yum -y  install    perl-ExtUtils-*     perl-CPAN*
  ]#tar  -zxvf  mha4mysql-manager-0.56.tar.gz
  ]#cd  mha4mysql-manager-0.56
  ]# ls
  AUTHORS  COPYING  inc  Makefile.PL  META.yml  rpm      t
  bin      debian   lib  MANIFEST     README    samples  tests
  ]#perl  Makefile.PL             #mha4mysql-manager是用perl语言写的源码包
  ]#make && make install
  ]#ln -s bin/* /usr/local/bin/   #把mha4mysql-manager命令做软连接到PATH下,可以不做
●创建mha_manager主配置文件
  ~]# cd mha-soft-student/
   ]# mkdir /etc/mha_manager/
   ]# cd mha4mysql-manager-0.56/samples/
   ]# cp conf/app1.cnf /etc/mha_manager/
   ]# vim /etc/mha_manager/app1.cnf
   <----------------------------------------------------------------------------------
  [server default]
  manager_workdir=/var/log/masterha/app1
  manager_log=/var/log/masterha/app1/manager.log
  master_ip_failover_script=/etc/mha_manager/master_ip_failover  #需要添加,故障切换脚本
                             
  ssh_user=root        #需要添加，用于无密码登陆
  ssh_port=22          #需要添加
  repl_user=repluser   #需要添加，用于连接主库-------------需要
  repl_password=123456 #需要添加
  user=root            #需要添加，数据库监控用户
  password=123456      #需要添加
  
  [server1]
  hostname=192.168.4.51
  candidate_master=1   #竞选主库
  
  [server2]
  hostname=192.168.4.52
  candidate_master=1   #竞选主库，备用
   
  [server3]
  hostname=192.168.4.53
  candidate_master=1   #竞选主库，备用
  
  [server4]
  hostname=192.168.4.54
  no_master=1          #不竞选主库
  
  [server5]            #增加一个服务器
  hostname=192.168.4.55
  no_master=1          #不竞选主库
  ---------------------------------------------------------------------------------->
●部署故障切换脚本
  ]# cp mha-soft-student/master_ip_failover /etc/mha_manager/
  ]# chmod +x /etc/mha_manager/master_ip_failover
  ]# vim /etc/mha_manager/master_ip_failover
  <----------------------------------------------------------------------------------
  33 );  
  34 
 35 my $vip = '192.168.4.98/24';  # Virtual IP 
 36 my $key = "1";
 37 my $ssh_start_vip = "/sbin/ifconfig eth0:$key $vip";  #部署在 eth0:1这张网卡上
 38 my $ssh_stop_vip = "/sbin/ifconfig eth0:$key down";
 ---------------------------------------------------------------------------------->
  ]# 
##################################################################################
测试配置
●测试集群配置
  +测试ssh密钥对认证登陆
   masterha_check_ssh --conf=主配置文件
   masterha_check_ssh --conf=/etc/mha_manager/app1.cnf 
  +测试主从同步状态
   masterha_check_repl --conf=管理节点主配置文件
   masterha_check_repl --conf=/etc/mha_manager/app1.cnf
  #我的报错；备用主库52,53没启用binlog
  [error][/usr/local/share/perl5/MHA/MasterMonitor.pm, ln361] 
  None of slaves can be master. Check failover configuration file or log-bin settings in my.cnf
 +启停MHA_Manager
   使用 masterha_manager 工具
   --remove_dead_master_conf #删除宕机主库配置；如当51down机时，自动删除配置文件的[server1]
   --ignore_last_failover    #忽略xxx.health文件；任何故障情况都进行故障切换；默认8小时内不能切换第二次
  &启动 
  ]# masterha_manager --conf=/etc/mha_manager/app1.cnf \
     --remove_dead_master_conf --ignore_last_failover  #会停在当前终端
  &停止  
  ]# masterha_manager stop --conf=/etc/mha_manager/app1.cnf
  &查看状态
  ~]# masterha_check_status --conf=/etc/mha_manager/app1.cnf   #再开一个终端查看
   app1 (pid:7635) is running(0:PING_OK), master:192.168.4.51
●测试集群mysql配置
  +客户端连接vip地址192.168.4.98访问数据库
  ~]# ping -c2 192.168.4.98
  ~]# mysql -u root -p123456 -h192.168.4.98
   建库建表
  mysql> create database vip;
  mysql> create table vip.a(id int);
   所有库上查看
●测试高可用
  +原理：当主库51down机时，56的管理服务会自杀，故障切换脚本自动运行 
  +51主机停止mysqld服务
    systemctl stop mysqld
  +查看从库状态是否为52
    mysql -uroot -p123456 -e "show slave status;\G" | grep  -i master_host
  +查看56管理服务状态  #应为停止状态
    masterha_check_status --conf=/etc/mha_manager
  +查看两台备用主库vip地址
    ifconfig eth0:1
  +客户端修改数据库数据测试集群
##################################################################################
恢复down机主库
●启动数据库51
  ]# systemctl restart mysqld
  mysql> show master status;
  mysql> show slave status\G;
●配置51为新主库52的从库
  ]# mysql -uroot -p123456 -e "change master to master_host=\"192.168.4.52\",\
    master_user=\"repluser\",master_password=\"123456\",master_log_file=\"db52.000001\",\
    master_log_pos=154;"
●修改管理主机56的配置文件  #因为自动删除了，因此需要重新篇日志
   [server1]         
   candidate_master=1
   hostname=192.168.4.51
●启动管理服务
   ]# masterha_manager --conf=/etc/mha_manager/app1.cnf \
   --remove_dead_master_conf --ignore_last_failover
●查看服务
   ]# masterha_check_status --conf=/etc/mha_manager/app1.cnf  
●重新测试
  当前的主库52down机后,在51和53之间选举新的主库
●注意事项
  重新恢复的服务起数据，需要重新导入其他从库导出的数据；保持数据一致性

























































































































