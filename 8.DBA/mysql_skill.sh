###########################################
#统计数据库表数量
select count(*) from information_schema.tables where table_schema='db_name';
#统计数据库表行数
select sum(TABLE_ROWS) from information_schema.tables where TABLE_SCHEMA = 'db_name';
#查询出来的是每张表的行数
select table_name,table_rows from tables where TABLE_SCHEMA = '数据库名' order by table_rows desc;
