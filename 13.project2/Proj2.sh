###############################################################
如何管理云主机
●jumpserver    #跳板机软件  90%的管理操作
●VPN           #应急用的 ，财务软件
●通过上面两种方式管理 web
●haproxy做web的负载均衡   #简单
架构请看手机图片

###############################################################
项目1：使用云主机做web负载均衡

●创建3台Nginx服务器   #云主机;最好做成rpm包
●购买个弹性公网IP    
●购买弹性负载均衡,绑定公网IP
