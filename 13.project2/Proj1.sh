##################################################################################
1.Xshell
●sftp
[D:\~]$ sftp root@139.159.193.127

华为云使用注意：
1.NTP
  1.1 chrony 只监听ipv4
  [root@youjiahe ~]# cat /etc/sysconfig/chronyd # Command-line options for chronyd
  OPTIONS="-4"
  1.2 华为云NTP地址
  ntp.huaweicloud.com

2.华为云yum
  操作步骤
  以root用户登录弹性云服务器。
  执行以下命令，备份CentOS-Base.repo文件。
  mkdir -p /etc/yum.repos.d/repo_bak/

  mv /etc/yum.repos.d/*.repo /etc/yum.repos.d/repo_bak/

  使用curl命令下载对应版本的CentOS-Base.repo文件，并将其放入/etc/yum.repos.d/目录。
  针对华为云当前支持的CentOS镜像源版本，使用的curl命令分别如下：
  CentOS 6
  curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.myhuaweicloud.com/repo/CentOS-Base-6.repo

  CentOS 7
  curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.myhuaweicloud.com/repo/CentOS-Base-7.repo

  执行以下命令，生成缓存
  yum makecache

3.虚拟私有云
  3.1 服务列表----虚拟私有云 vpc，
  3.2 单击虚拟交换机(vpc*)
  3.3 单击虚拟IP选项卡，单击subnet，申请虚拟IP
  3.4 更多----绑定虚拟IP

