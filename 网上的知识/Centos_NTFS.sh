1.切换到系统yum目录并下载阿里的
[root@localhost ~]# cd /etc/yum.repos.d/
[root@localhost yum.repos.d]# wget http://mirrors.aliyun.com/repo/epel-7.repo
2.
[root@localhost yum.repos.d]# yum -y install ntfs-3g

#安装完成之后，自动识别，自动挂载 NTFS
