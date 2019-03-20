###########################################
#统计数据库表数量
select count(*) from information_schema.tables where table_schema='db_name';
#统计数据库表行数
select sum(TABLE_ROWS) from information_schema.tables where TABLE_SCHEMA = 'db_name';
#查询出来的是每张表的行数
select table_name,table_rows from tables where TABLE_SCHEMA = '数据库名' order by table_rows desc;
###########################################
#MySQL大小写区分规则
Linux
（1）数据库名与表名是严格区分大小写的；
（2）表的别名是严格区分大小写的；
（3）列名与列的别名在所有的情况下均是忽略大小写的；
（4）变量名也是严格区分大小写的。
#linux 配置
编辑mysql安装目录配置文件mysql.conf
# vim /etc/mysql/mysql.conf
在mysql.cnf中的[mysqld]的后面加上一行代码
lower_case_table_names = 0
重启mysql服务
# service mysql restart
