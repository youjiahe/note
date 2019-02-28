Mysql优化
############################################################
#Mysql 5.7默认设置
[mysqld]
innodb_file_per_table = ON          # 每个表都有独立表空间
innodb_stats_on_metadata = OFF      # 动态统计更新索引信息
innodb_buffer_pool_instances = 8 (or 1 if innodb_buffer_pool_size < 1GB)
query_cache_type = 0; (disabling mutex)

# 非默认
max_connections=1000
innodb_buffer_pool_size = 1G # (adjust value here, 50%-70% of total RAM)
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 1 # may change to 2 or 0
innodb_flush_method = O_DIRECT
innodb_buffer_pool_instances = 8
innodb_page_cleaners=4
innodb_purge_threads=1 
innodb_max_dirty_pages_pct=90 
wait_timeout=300

# 从节点增加的操作
innodb_doublewrite=off
innodb_page_cleaners=8
innodb_read_io_threads=64
innodb_write_io_threads=64
read_buffer_size=1M
###########################################################################3
# innodb_buffer_pool_size	设置为 RAM 大小的 50%-70%，不需要大于数据库的大小
# innodb_flush_log_at_trx_commit	1（默认值），0/2 （性能更好，但稳定性更差）
# innodb_log_file_size	128M – 2G (不需要大于 buffer pool)
# innodb_flush_method	O_DIRECT (避免双缓冲技术)
# innodb_purge_threads=1 #使用单独的清除线程定期回收无用数据的操作
# innodb_max_dirty_pages_pct=90 #innodb主线程刷新缓存池中的数据，使脏数据比例小于90%
############################################################
#innodb_buffer_pool_size
调优参考计算方法：
val = Innodb_buffer_pool_pages_data / Innodb_buffer_pool_pages_total * 100%
val > 95% 则考虑增大 innodb_buffer_pool_size， 建议使用物理内存的75%
val < 95% 则考虑减小 innodb_buffer_pool_size， 建议设置为：Innodb_buffer_pool_pages_data * Innodb_page_size * 1.05 / (1024*1024*1024)

#innodb_flush_method
https://blog.csdn.net/smooth00/article/details/72725941
