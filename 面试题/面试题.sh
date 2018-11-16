1.如何控制容器占用系统资源的份额？  #更详细请看网上知识文件夹下的《docker资源配额》
docker run -tid –cpu-shares 100 centos:latest  #在创建容器时指定容器所使用的CPU份额值，权重值0
docker run -tid –cpu-period 1000000 –cpu-quota 200000 centos #容器进程每1秒使用单个CPU的0.2秒时间

2.如何修改docker默认存储设置
  2.1 修改docker.service文件.
     vim /usr/lib/systemd/system/docker.service
  2.2 在里面的EXECStart的后面增加后如下:
      ExecStart=/usr/bin/dockerd --graph /home/docker  #先创建文件夹
  2.3 查看
     docker info | grep "\/home\/docker"

3.mysql的innodb如何定位锁问题:
  在使用 show engine innodb status检查引擎状态时，发现了死锁问题
  在5.5中，information_schema 库中增加了三个关于锁的表（MEMORY引擎）

  innodb_trx         ## 当前运行的所有事务

  innodb_locks     ## 当前出现的锁

  innodb_lock_waits  ## 锁等待的对应关系

4.主从延迟原因及解决
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

5.Nginx php-fpm 经常出现的错误是 502 和 504，分别出现在什么情况？


6.RedHat6版本与RedHat7版本区别
  6.1 引导程序：RHEL6 使用grub引导程序；RHEL7使用 grub2   
     #grub2更强大，支持MBR、GPT、NTFS、BIOS
  6.2 服务管理：
 
7.网站上线流程



































