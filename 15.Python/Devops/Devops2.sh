运维开发实战
NSD DEVOPS DAY02

使用国内镜像站点
•  为了实现安装加速,可以配置pip安装时采用国内镜像站点
[root@localhost ~]# yum install python34-pip-8.1.2-6.el7.noarch
[root@localhost ~]# mkdir ~/.pip/	
[root@localhost ~]# vim ~/.pip/pip.conf		
[global]	
index-url=http://pypi.douban.com/simple/	
[install]	
trusted-host=pypi.douban.com	

