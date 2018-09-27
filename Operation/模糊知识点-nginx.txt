●模块
--with-http_stub_status_module 

●启用stub_status模块
server {
..
location /status {
     stub_status on;
}
..
}

●脚本没有配eth3 IP
eth3 IP not found

●watch -n 1 ss -s
使用“watch -n 1 ss -s”命令观察服务器连接数
变化(每秒执行一次 ss 命令)

●session
查看/etc/php-fpm.d/www.conf 配置文件,确认 session 会话信息保存位置
到/var/lib/php/session 目录下查看 session 文件

●查看网页nginx版本
[root@room11pc19 sh]# curl -I www.nginx.org
..
Server: nginx/1.13.9
..

[root@room11pc19 sh]# curl -I www.baidu.com
....
Server: bfe/1.0.8.18

[root@room11pc19 sh]# curl -I www.taobao.com
..
Se..rver: Tengine

●隐藏nginx版本号
1、进入nginx配置文件的目录
在http 加上server_tokens off; 如：
http {
....
server_tokens off;
…….省略
}

2.编辑fastcgi.conf配置文件
找到：
fastcgi_param SERVER_SOFTWARE nginx/$nginx_version;
改为：
fastcgi_param SERVER_SOFTWARE nginx;

●优化内核参数
tcp_syn_retries ：INTEGER
默认值是5
对于一个新建连接，内核要发送多少个 SYN 连接请求才决定放弃。不应该大于255，默认值是5，对应于180秒左右时间。(对于大负载而物理通信良好的网络而言,这个值偏高,可修改为2.这个值仅仅是针对对外的连接,对进来的连接,是由tcp_retries1 决定的)

tcp_fin_timeout：
这个参数表示当服务器主动关闭连接时，socket保持在FIN-WAIT-2状态的最大时间。

tcp_syncookies ：BOOLEAN
默认值是0
只有在内核编译时选择了CONFIG_SYNCOOKIES时才会发生作用。当出现syn等候队列出现溢出时象对方发送syncookies。目的是为了防止syn flood攻击。
注意：该选项千万不能用于那些没有收到攻击的高负载服务器，如果在日志中出现synflood消息，但是调查发现没有收到synflood攻击，而是合法用户的连接负载过高的原因，你应该调整其它参数来提高服务器性能。参考:

●命令sysctl
查看
#sysctl -a | grep syn
#sysctl -a  | grep fin
 net.ipv4.tcp_fin_timeout = 60
修改：
#sysctl -w net.ipv4.tcp_syn_retries=5









