DBA1 day5

1.mysqldump
  1.1 数据库备份概述
       1.1.1 数据备份方式
       1.1.2 数据备份策略 [完全|增量|差异]
  1.2 物理热备 cp、tar
  1.3 逻辑备份 mysqldump mysql
2.实时增量备份/恢复
  2.1 binlog简介
  2.2 使用binlog日志
       2.2.1 启用binlog日志
       2.2.2 清理binlog日志
       2.2.3 分析binlog日志
  2.3 binlog恢复数据
3.innobackupex
  3.1 MySQL备份工具
       3.1.1 常用备份工具
       3.1.2 XtraBackup
  3.2 安装percona
       3.2.1 安装percona
       3.2.2 innobackupex基本选项
  3.3 innobackupex案例
       3.3.1 完全备份与恢复
       3.3.2 增量备份与恢复
       3.3.3 从完全备份中恢复单个表

##################################################################################
mysqldump备份/恢复
●数据备份方式：
  &物理备份
   冷备份：cp,tar...
  &逻辑备份
   mysqldump
   mysql
   
●初始化数据库
  systemctl stop mysqld
  rm -rf /var/lib/mysql/
  systemctl start mysqld
  grep “t.* password“ /var/log/mysqld.log | less 
  mysql -uroot -p初始密码
##################################################################################  
逻辑备份方式 
●完全备份
  备份所有数据：
  一台服务器的所有数据
  一个库的所有数据
  一张表的所有数据           
            
●备份新产生的数据
  差异备份：备份完全备份后，所有新产生的数据
  增量备份：备份上次备份后，所有新产生的数据                     
 
 完全备份+差异备份
                 06:00   文件名     数据
1   完全          10    1.sql      10
2   差异          3     2.sql      3
3             5	3.sql      8
4		  2   4.sql	    10
5		  7	5.sql	    17
6		  4	6.sql	    21
7  差异            1	7.sql	    22    	                     
                     
 完全备份+增量备份
                06:00     文件名        数据
1   完全         10       1.sql	 10
2   增量         3       2.sql	 3
3            5	 3.sql       5
4		 2	 4.sql	 2
5		 7	 5.sql	 7
6		 4	 6.sql	 4
7  增量          1	 7.sql        1 
##################################################################################                      
完全备份  mysqldump
完全恢复  mysql/source
                                
●备份操作：
  &格式：
  mysqldump -uroot -p密码 库名 > xxxx.sql                  
  mysqldump -uroot -p密码 -A > xxxx.sql     #-A，备份所有
  &备份对象
    库名
    库名 表名
   -A              #所有库
   -B 库1 库2  .. ..  #多个库 
●恢复操作：                     
  &方法一：
  ]# mysql -u root -p密码 <  整个数据库的备份文件,多个库的备份        
  ]# mysql -u root -p密码 库名 <  某个库的备份文件                  
  &方法二：
  进入数据库，创建库，进入库
  source  某个库的备份文件              
●缺点
  &只能恢复到备份时刻的数据
  &恢复，备份时，会加写锁
  &备份时间长
  &跨平台性差
##################################################################################  
增量备份
●方法1：实时增量备份  启用binlog日志
●方法2：使用第3放软件percona提供的命令 innobackupex 做增量备份                      
          &完全备份和恢复
          &增量备份，增量恢复
          &在线热备，不锁表
##################################################################################
增量备份方法1：
binlog日志 实时增量备份  

●特点/属性
  &二进制日志，记录在数据库服务器上执行的出查询之外的sql命令
  &默认不启动
  &默认超过500M时自动创建新的日志文件
●启用日志
  vim /etc/my.cnf
  --------------------------------------
  [mysqld]
  server_id=50
  log-bin=/mydb/yjh          #指定目录，文件名前缀；yjh为命名前缀
  binlog-format="mixed"
  --------------------------------------
●binlog格式：
  &statement     #记录执行sql数据更新结果
  &row           #不记录sql语句上下文信息，仅保存命令
  &mixed         #既记录命令，也记录数据更新结果
    
   mysql> show variables like "binlog_format";
   +---------------+-------+
   | Variable_name | Value |
   +---------------+-------+
   | binlog_format | ROW   |
   +---------------+-------+
●binlog日志文件                      
  yjh.index      #日志文件的索引；记录已有的日志文件名
  yjh.000001     #日志文件               
●查看日志文件
  ]# mysqlbinlog /mydb/yjh.000001 
   
●binlog记录sql命令的方法
    &偏移量 position
    &时间点                  
●恢复数据
  &标准恢复：
  ]# mysqlbinlog /mydb/yjh.000001 | mysql -uroot -p123456
  &偏移量恢复：
   mysqlbinlog /mydb/yjh.000001 \
   --start-position=xx \          #在日志文件找出命令上方at 对应偏移量
   --stop-position=yy \           #找到“commit“下面的偏移量
   /mydb/yjh.000001 | \
   mysql -uroot -p123456
                     
●案例
+使用binlog恢复数据
&备份表bbs.user  
 ]# mysqldump -uroot -p123456 bbs user > /sqlbak/user.sql  
&添加内容          
 mysql> use bbs                   
 mysql> insert into user(user,uid) values("jojo",1234);
 mysql> insert into user(user,uid) values("job",1234);
 mysql> insert into user(user,uid) values("jeep",1234);
&查看binlog记录的命令
 ]# mysqlbinlog /mydb/yjh.000001| grep insert
 insert into user(user,uid) values("jojo",1234)
 insert into user(user,uid) values("job",1234)
 insert into user(user,uid) values("jeep",1234)
##################################################################################
管理binlog日志文件
●修改日志文件存储路径，文件名前缀
  ]# mkdir /mydb
  ]# chown mysql /mydb                   
  ]# vim /etc/my.cnf
  --------------------------------------
  [mysqld]
  server_id=50
  log-bin=/mydb/yjh          #指定目录为/mydb，文件名前缀为yjh
  binlog-format="mixed"
  --------------------------------------                 
  ]# systemctl restart mysqld                   
  ]# vim /etc/my.cnf                  
  ]# ls /mydb   
   yjh.000001  yjh.index             

●默认超过500M时自动创建新的日志文件
  
●手动建新的日志文件           
  & mysql> flush logs;
    mysql> show master status;   #查看当前使用的日志文件                
   & 重启服务也会生成新的日志文件       #生产中不用         
  & ]# mysql -uroot -p123456 -e "flush logs"                  
  & ]# mysqldump  -uroot  -p654321  --flush-logs  db3.user3  >  /root/user3.sql               
                    
●删除已有的binlog日志文件
  mysql> purge master logs to "yjh.000004"; #从起始编号删除到指定
  mysql> reset master；                       #删除所有，并重新创建新的日志文件                   
##################################################################################                    
第三方percona-xtrabackup备份                     

●装包                                 
    yum -y install 
    perl-DBD-MySQL.x86_64              #光盘自带依赖包
    perl-Digest-MD5                    #光盘自带依赖包
    libev-4.15-1.el6.rf.x86_64.rpm     #
    percona-xtrabackup               
●特点
  &在线热备工具
    备份过程不锁表，适合生产环境
  &提供两个命令
  innobackupex        #生产中只用这个；封装好xtrabackup    per语言
  xtrabackup          #C语言
●命令格式
  innobackupex <选项>
  --user
  --password
  --port
  --host
  --databases         #单个库：--databases="库1"；  多个库： --databases="库1 库2 .."；
  --no-timestamp      #不以日期做备份的子目录名
  
  --apply-log         #准备恢复数据
  --copy-back         #把备份目录下的数据，拷贝回/var/lib/mysql

  --redo-only             #合并日志
  --incremental           #指定增量备份目录
  --incremental-basedir   #指定上一次备份的目录
 
  --incremental-dir       #增量备份目录路径
  
  --export                #导出表空间文件
    
   
##################################################################################  
innobackupex 完全备份与恢复
●完全备份
 ]# innobackupex --user root --password 123456  /allback --no-timestamp 
   #整库全备份；备份目录下包含库文件，以及备份的配置文件
●完全恢复
 ]# systemctl stop mysqld
 ]# rm -rf /var/lib/mysql/*
 ]# innobackupex --user root --password 123456 --apply-log /allback  #准备恢复数据
 ]# innobackupex --user root --password 123456 --copy-back /allback
 ]# chown -R mysql:mysql /var/lib/mysql 
################################################################################## 
innobackupex 增量备份与恢复
●增量备份
  +步骤1：周一备份所有
      ]# innobackupex --user root --password 123456 /fullbak --no-timestamp
      mysql> insert into .. ..
  +步骤2：第一次增量备份
      ]# innobackupex --user root --password 123456 --incremental /new1dir --incremental-basedir=/fullbak --no-timestamp
      --------------------------------------------------------------
      ]# ls /new1dir 
         ibdata1.delta ibdata1.meta  #增量备份目录部分文件
      ]# ls /fullbak/
         ibdata1                     #全备份目录部分文件
      ---------------------------------------------------------------
  +步骤3：第二次增量备份
      ]# innobackupex --user root --password 123456 --incremental /new2dir --incremental-basedir=/new1dir --no-timestamp

●增量恢复
  +步骤1：准备恢复数据,恢复增量备份前的日志数据
        ]# innobackupex --user root --password 123456 \
           --apply-log --redo-only /fullbak/
  +步骤2：合并日志
        ]# innobackupex --user root --password 123456 \
           --apply-log --redo-only --incremental-dir="/new1dir" /fullbak/           
        ]# innobackupex --user root --password 123456 \
           --apply-log --redo-only --incremental-dir="/new2dir" /fullbak/ 
                  
  +步骤3：把备份数据拷贝到数据库目录下
        ]# innobackupex --user root --password 123456 \
           --apply-log --redo-only --copy-back /fullbak/ 
           
  +步骤4：修改/var/lib/mysql所有者
        ]# chown -R mysql:mysql  /var/lib/mysql
  +步骤5：启服务
  +步骤6：登陆数据库
  
●相关概念
   在先热备不锁表。对innodb存储引擎的表时，增量备份
  innodb存储引擎的有事务日志和支持事务回滚
  
   +数据库表的元数据
    ----------------------------------- 
    ls /var/lib/mysql
    ibdata1                 #备份执行后，更新的数据
    ib_logfile0             #备份执行时，已经有的数据
    ib_logfile1             #备份执行时，已经有的数据
    -----------------------------------
   以上都是
   元数据是描述数据仓库内数据的结构和建立方法的数据
  
  +LSN日志序列号
     执行增量备份时，会生成一个程序，监控日志文件的序列号有无变化；
     有变化则从上次的LSN序列号为值开始备份到最后一个序列号；
    
  +备份目录下的相关配置文件说明
   &xtrabackup_checkpoints         #本次备份的备份信息；(如：日志序列号范围)   
   -----------------------------------------------------------------------------
   ]# cat /fullbak/xtrabackup_checkpoints 
    backup_type = full-backuped    #完全备份  
    from_lsn = 0                   #起始LSN序列号
    to_lsn = 4408225               #结束LSN序列号 
    
   ]# cat /new1dir/xtrabackup_checkpoints 
    backup_type = incremental
    from_lsn = 4408225
    to_lsn = 4413074
  
   ]# cat /new2dir/xtrabackup_checkpoints 
    backup_type = incremental
    from_lsn = 4413074
    to_lsn = 4415240
   -----------------------------------------------------------------------------
   &ibdata1                        #完全备份执行后，更新的数据
   &ibdata1.meta                   #增量备份执行时，已经存在的数据
   &ibdata1.delta
   &xtrabackup_logfile             #备份执行前，已经提交的命令
##################################################################################  
innobackupex 恢复完全备份中的一个表

●相关概念
  &表空间文件    #存储数据的表文件，如：表.ibd文件  
                                     
●完全备份
]#  innobackupex   --user   root    --password   654321   \
--databases="studb"    /allbakstudb    --no-timestamp

●查看备份目录文件列表
]# ls   /allbakstudb
]# ls   /allbakstudb/studb

●误删除a表:    mysql>  drop   table   studb.a;

●使用完全备份文件恢复单个表
  &导出表信息
   ]#innobackupex --user root --password 654321   \
   --databases="studb"  --apply-log   --export   /allbakstudb
  &创建删除的表(注意表结构要一样)
    create   table  studb.a(name char(10));
  &删除表空间文件
    mysql> alter  table studb.a  discard  tablespace; 
  &拷贝到对应的数据库目录下，
   ]# cp /allbakstudb/studb/a.{cfg,exp,ibd}   /var/lib/mysql/studb/
  &修改所有者和组为mysql
   ]# chown mysql:mysql /var/lib/mysql/studb/a.*

●导入表空间
  mysql>  alter  table  studb.a  import  tablespace; 
  ]# rm  -rf /var/lib/mysql/studb/a.cfg     #表信息.cfg   .exp为文件
  ]# rm  -rf /var/lib/mysql/studb/a.exp

  查看记录
  mysql> select   * from  studb.a;
                                       
                                    
                                     
                                     
                                     
                                     
                                     
                                     
                                     
                                     
                                     
                                     
                                     
                                     
                                     
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                       
                                     
