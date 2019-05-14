1.app1.cnf配置远程监控用户为普通用户
2.每台mysql服务器 都把普通用户添加到 mysql组
3.普通用户ssh免密登录
4.master_failover_script修改，加上sudo
 37 my $ssh_start_vip = "/bin/sudo /sbin/ifconfig eth0:$key $vip";
 38 my $ssh_stop_vip = "/bin/sudo /sbin/ifconfig eth0:$key down";
