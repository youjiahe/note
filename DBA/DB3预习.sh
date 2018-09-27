●存储引擎
show variables like "default_storage_engine%"; #查看默认存储引擎
show engines; #查看所有存储引擎
default-storage-engine=myisam

myisam 不支持外键
.frm
.MYI
.MYD
innodb 支持外键
.frm
.ibd

●锁机制
不理解，没有例子
●事物特性
set autocommit=off
rollback  #不起作用？？

●数据导入导出
mysql> show variables like "secure_file_priv";
+------------------+-----------------------+
| Variable_name    | Value                 |
+------------------+-----------------------+
| secure_file_priv | /var/lib/mysql-files/ |
+------------------+-----------------------+



