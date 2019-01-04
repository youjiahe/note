
基本匹配
1.数字匹配 
> < = != >= <=
2.字符匹配
= !=
3.范围匹配
in  no in    between .. and ..
4.空匹配
5.取重显示
6.逻辑与，逻辑或

高级匹配
1.模糊匹配
2.正则匹配
3.四则运算

查询结果操纵
1.排序
2.限制输出行数
3.分组
4.聚集函数
5.having


复制表
create table a select * from b;
连接查询
多表连接查询
select * from t1,t2;
select * from t1,t2 where t1.id=t2.id;
select t1.user,t2.user from t1,t2
左右连接查询
select * from t1 left join t2 on 条件；
select * from t1 right join t2 on 条件；
select t1.* from t1 left join t2 on 条件; 
嵌套查询
select * from user where id>(select avg(id) from user);

show grants;
select @@hostname;
show grants for 用户@主机；
select user();

grant 权限列表 on 库名.表名 to 用户@主机 identified by '密码'；
grant 权限列表 on 库名.表名 to 用户@主机 identified by '密码' with grant option；
revoke 权限列表 on 库名.表名 from 用户@主机;

systemctl stop mysqld
vim /etc/my.cnf
----------------------------------
[mysqld]
skip-grant-tables
----------------------------------
systemctl start mysqld
mysql -uroot -p123456
use mysql;
select host,user,authentication_string from mysql.user;
update mysql.user set authtication_string=password(“123456”) where user="root" and host="localhost";
flush privileges

mysql.db           #存储库信息
mysql.tables_priv  #存储表信息
mysql.column_priv  #存储列信息
mysql.user         #存储授权用户信息
####################################################################################
完全备份
备份 mysqldump -uroot -p123456 选项 > 备份文件名
恢复 mysql -uroot -p123456 选项 <  备份文件名
备份 mysqldump -uroot -p123456 -A > 备份文件名   #全部备份
恢复 mysql -uroot -p123456 < 备份文件名
备份 mysqldump -uroot -p123456 -B 库1 库2 库3 > 备份文件名 #备份部分库
恢复 mysql -uroot -p123456 < 备份文件名
备份 mysqldump -uroot -p123456 库1 表1 > 备份文件名  #备份某表
恢复 mysql -uroot -p123456 库1 < 备份文件名

binlog文件恢复
启用binlog
vim /var/my.cnf
----------------------------
[mysqld]
server_id=50
log-bin=yjh
binlog-format="mixed"
----------------------------
查看mysqlbinlog /var/lib/mysql/yjh.000001 
恢复mysqlbinlog --start-position=455 --stop-position=1586 /var/lib/mysql/yjh.000002 | mysql


第三方软件增量备份
yum -y install libev..  percona...   #yum仓库不自带，需要自己下载
innobackupex
--user
--password
--databases
--no-timestamp
--copy-back
--incremental 
--incremental-basedir
--incremental-dir
--apply-log
--redo-only
--export

完全备份与恢复
备份
innobackupex --user root --password 123456 /allback --no-timestamp
恢复
innobackupex --user root --password 123456 --copy-back /allback

增量备份与恢复
增量备份
步骤1：完全备
innobackupex --user root --password 123456 /fullbak --no-timestamp
步骤2：更改数据，增量备份
insert into 表名 set 字段名="值" where 条件
insert into 表名 set 字段名="值" where 条件
innobackupex --user root --password 12346 --incremental /new1dir --incremental-basedir="/fullbak" --no-timestamp
insert into 表名 set 字段名="值" where 条件
insert into 表名 set 字段名="值" where 条件
innobackupex --user root --password 123456 --incremental /new2dir --incremental-basedir="/new1dir" --no-timestamp
步骤3：删库
systemctl stop mysqld
rm -rf /var/lib/mysql/*
步骤4：恢复
1）准备恢复数据
innobackupex --user root --password 123456 --apply-log --redo-only /fullbak
2）合并日志
innobackupex --user root --password 123456 --apply-log --redo-only --incremental-dir="/new1dir" /fullbak
innobackupex --user root --password 123456 --apply-log --redo-only --incremental-dir="/new2dir" /fullbak
3）恢复完整数据
innobackupex --user root --password 123456 --apply-log --redo-only --copy-back  /fullbak
4）修改权限
chown -R mysql:mysql /var/lib/mysql
5）重起服务


备份及恢复库中的一个表
create database db52;
create table db52.a(id int);
insert into db52.a values(555);
insert into db52.a values(555);
]# innobackupex --user root --password 123456 --databases="db52"  /db52 --no-timestamp
drop table db52.a;
create table db52.a(id int);
alter table db52.a discard tablespace;
]# innobackupex --user root --password 123456 --apply-log --export /db52
]# cp /db52/db52/a.{cfg,exp,ibd} /var/lib/mysql/db52/
]# chown mysql:mysql /var/lib/mysql/db52/a.{cfg,exp,ibd}
alter table db52.a import tablespace;
select * from db52.a;

####################################################################################
主从同步
工作原理
从库(IO线程)----copy----->主库(binlog)-------------->从库(relay-log)--------------从库执行日志命令(SQL线程)

一主一从
主库 mysqldump -u root -p123456 > /mysql_all.sql
    scp
    grant replication slave on *.* to repluser@'%' identified by '123456';
    vim /etc/my.cnf
      ---------------------------
    [mysqld]
    server_id=50
    log-bin=db50
    binlog-format="mixed"
     ---------------------------
    systemctl restart mysqld
     mysql -uroot -p123456
     > show master status;
从库 mysql -uroot -p123456 < /mysql_all.sql
    mysql -uroot -p123456
    change master to 
    master_host="192.168.4.50",
    master_user="repluser",
    master_password="123456",
    master_log_file="db50.000001",
    master_log_pos=154;
    start slave;
    show slave status;
        
主从从
   在中间的从服务器中加一行
   [mysqld]
   .. ..
   log_slave_updates

主主
互为主从

以主多从
在多台虚拟机配置从库，主库一致

主库配置选项
binlog_do_db=name,user #只记录这两个库的日志
binlog_ignore_db=tt    #不同步该库

从库配置选项
log_slave_updates
replicate_do_db=name.user #只同步这两个库
replicate_ignore_db=tt    #不同不该库


全同步模式
异步模式
半同步模式

配置半同步模式
临时
主库
install plugin rpl_semi_sync_master soname "semisync_master.so";
set global rpl_semi_sync_master_enabled=1;
show variables like "rpl_semi_sync_%enabled";
select plugin_name,plugin_status from information_schema.plugins where plugin_name like "%semi%";
从库
install plugin rpl_semi_sync_slave soname "semisync_slave.so";
set global rpl_semi_sync_slave_enabled=1;
show variables like "rpl_semi_sync_%enabled";
select plugin_name,plugin_status from information_schema.plugins where plugin_name like "%semi%";






























