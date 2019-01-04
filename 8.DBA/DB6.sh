DBA2 day1

1.MySQL 主从同步
  1.1 主从同步概述
       1.1.1 案例拓扑
       1.1.2 主从同步原理
  1.2 构建主从同步
       1.2.1 构建思路
       1.2.2 确保数据一致
       1.2.3 配置主库
       1.2.4 配置从库
       1.2.5 测试配置
  1.3 常用配置选项
       1.3.1 主库配置选项
            binlog_ignore_db=库名,库名
            binlog_do_db=库名,库名
       1.3.2 从库配置选项
            log_slave_updates
            replicate_do_db=
            replicate_ignore_db=
2.主从同步模式
  2.1 结构类型
      一主一从、一主多从、主从从、主主
  2.2 配置主从从结构
  2.3 复制模式
      2.3.1 全同步模式
      2.3.2 异步模式
      2.3.3 半同步模式
  2.4配置半同步模式
##################################################################################
MySQL主从同步
从数据库服务器自动同步主库上的数据到
主数据库服务器：接受客户端访问的数据库服务器
从数据库服务器：自动同步主数据库服务器上的数据到本机
##################################################################################
部署MySQL主从同步
案例1：
192.168.4.51作主库
192.168.4.52作从库
●前提：主库数据==从库数据
       51 ~]# mysqldump -uroot -p123456 -A > /mysql51_bak  #备份
       52 ~]# mysql -uroot -p123qqq...A < mysql51_bak      #导入
●主数据库配置步骤
  &启用binlog日志
  51 ~]# vim /etc/my.cnf
  --------------------------------------------
  [mysqld]
  server_id=51 
  log-bin
  binlog-format="mixed"
  --------------------------------------------
  &授权(从库连接主库，需要有一个授权用户)
  mysql> grant replication slave on *.* 
         to repluser@'%' 
         identified by '123456';
  &查看日志信息
  show master status;
  mysql> show master status;
  +-------------+----------+--------------+
  | File        | Position | 
  +-------------+----------+--------------+
  | db51.000002 |      441 |     
  +-------------+----------+-
●从数据库配置步骤
  &指定server_id
  52 ~]# vim /etc/my.cnf
  [mysqld]
  server_id=52 
  &指定主库信息
   mysql> change master to
   master_host="192.168.4.51",
   master_user="repluser",
   master_password="123456",
   master_log_file="db51.000002",
   master_log_pos="441";
  
  &启动slave程序
  &查看slave程序运行状态
   mysql>  show slave status\G;
   --------------------------------------------
   Slave_IO_Running: Yes
   Slave_SQL_Running: Yes
   Last_IO_Error:             #记录IO线程错误信息
   Last_SQL_Error:            #记录SQL线程错误信息
   --------------------------------------------
●客户端测试
  &授权  主机192.168.4.51：
  mysql>  grant all on db5.* to yaya@'%' identified by '123456';
  &
  
##################################################################################
MySQL主从同步工作原理
从库(IO线程)---copy--->主库(binlog日志)--------->从库本机(中继日志)-------->从库(SQL线程执行命令)

●IO线程、SQL线程
  IO线程：把主库binlog日志文件拷贝到本地
  SQL线程：根据binlog日志执行命令
●中继日志文件
  从库的IO线程把主库binlog日志文件拷贝到本地为中继日志文件
  [root@mysql52 mysql]# ls | grep relay
  mysql52-relay-bin.000001     #中继日志文件
  mysql52-relay-bin.000002     #中继日志文件
  mysql52-relay-bin.index      #中继日志文件索引
  relay-log.info               #从库正在使用的中继文件
                                        #主库binlog日志信息(偏移量，文件名)
##################################################################################  
从库相关配置
●MySQL从库相关配置文件  
  master.info                  #主库信息
  mysql52-relay-bin.000001     #中继日志文件
  mysql52-relay-bin.index      #中继日志文件索引
  relay-log.info               #中继日志信息(偏移量等)
●临时不同步
  从库操作 mysql> stop slave;
●从库撤销同步,还原为独立库
  rm -rf 以上四种文件
  rm -rf master.info mysql52-relay-bin.* relay-log.info 
  systemctl restart mysqld
##################################################################################   
MySQL主从同步常见问题
1.主从的UUID相等报错
  修改文件：/var/lib/mysql/auto.cnf    #mysql的UUID文件
2.从库下会自动生成上述四种文件，当启动时报错信息是".. ..relay log info.. .."时：
  rm -rf /var/lib/mysql/relay-log.info
   systemctl restart mysqld
##################################################################################
扩展
##################################################################################
MySQL主从同步结构
●一主一从    #生产环境用得多，可单独用
●一主多从    #生产环境用得多，可单独用
●主从从      #需要配合第三方软件，做高可用集群得数据库
●主主        #互为主从，需要配合第三方软件，做高可用集群得数据库
##################################################################################
部署MySQL主从从   #晚上练习
中间的从库：
[mysqld]
server_id=52
log-bin=db52
binlog-format="mixed"
log_slave_updates    #级联复制；用于主从从；不加该参数，最后一个从不能同步数据；

部署MySQL主主     #晚上练习

##################################################################################
主库配置选项
●主从同步控制——通过修改binlog日志记录对象实现
   binlog_do_db=name,game   #binlog日志白名单，只记录name库,game库
   binlog_ignore_db=name    #binlog日志黑名单，不记录name库
##################################################################################   
从库配置选项  
●级联复制
  log_slave_updates          #级联复制；用于主从从；不加该参数，最后一个从不能同步数据；
●从库同步控制
  replicate_do_db=mysql      #从库同步白名单；
  replicate_ignore_db=mysql  #从库同步黑名单；
##################################################################################
MySQL主从同步复制模式
●全同步模式--------------mysql组同步配置
  所有从库都同步成功后，主库应答客户端；  
●异步模式    #默认模式
  无论从库是否成功同步，主库马上应答客户端
●半同步模式
  一个或以上的从库同步成功后，主库应答客户端
##################################################################################
部署半同步模式
●3个步骤临时生效
+查看加载模块状态
 show variables like 'have_dynamic_loading';  #查看是否支持动态加载模块
 &查看主库
 select plugin_name,plugin_status from plugins where plugin_name like "%semi%";
 &查看从库
 select plugin_name,pugin_status from plugins where pulgin_name like "%semi%";;
+命令行加载模块(马上生效，重启服务后无效)
 &主库执行：
 install plugin rpl_semi_sync_master soname 'semisync_master.so'; #加载半同步主库模块
 &从库执行：
 install plugin rpl_semi_sync_slave  soname 'semisync_slave.so';  #加载半同步从库模块
+临时启用半同步模式
  &主库执行：
 set global rpl_semi_sync_master_enabled=1; 
  &从库执行：
 set global rpl_semi_sync_slave_enabled=1; 
  &查看
 show variables like ‘rpl_semi_sync_%enabled’；
 
●修改配置文件永久生效
+主库
 [mysqld]
 plugin-load=rpl_semi_sync_master=semisync_master.so
 rpl_semi_sync_master_enabled=1
+从库
 [mysqld]
 plugin-load=rpl_semi_sync_slave=semisync_slave.so
 rpl_semi_sync_slave_enabled=1
+主从库都起服务





















































































































































































































