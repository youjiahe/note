问题点
1.WIN2008中L2TP+IPSec与PPTP都连接上后，Linux不能Ping通192.168.3.128。关闭PPTP的连接VPN连接后就可以ping通，为什么？

回顾

版本控制
    svn,git
    yum -y install subversion
    mkdir /var/svn
    svnadmin create /var/svn/project
    cd 需要目录
    svn import . file:///var/svn/project
    cd /var/svn/project/conf
    svnserve.conf 19 20 27 34
    passwd
    authz
    svnserve -d -r /var/svn/projecj     
    mkdir /svn cd
    svn co svn://192.168.2.100 code
svn
    svn add
    svn mkdir 
    svn rm
    svn cat 
    svn log
    svn info
    svn revert
    svn merge -r8:2 1.sh
    svn update   svn -r 1 update 
git    
    git 
    git clone 
    git add
    git commit -m "xx"
    git push
    git pull
RPM
    yum -y install rpm-build  
    rpmbuild -ba -xx.spec
    cd rpmbuild
    BUILD BUILDROOT SOURCES RPMS SRPMS SPECS
    cp 源码 SOURCES
    vim SPECS/xx.spec
     软件基本信息（填空）
    name:nginx
    version:1.12.2
    source0:nginx-1.12.2.tar.gz
    %post
    useradd -s /sbin/nologin nginx
    %pre
    %setup -q (tar cd)
    ./configure --prefix .. --with
    make
    make install DESTDIR={%buildroot}
    %file
    /usr/local/nginx/*
             
####################################################################################
VPN

借助公网，打通一个隧道，作为私网使用（分公司之间可以实现在一个局域网通信）
目前主流VPN技术（）


GRE
●准备proxy及client两台虚拟机
●启用GRE（Linux与Linux）
步骤1：加载gre模块
lsmod                                 #显示模块列表
/lib/modules/3.10.0-693.el7.x86_64/   #该目录下有的就可以用mod查看
modprobe ip_gre                       #确定是否加载了gre模块
modinfo ip_gre                         

步骤2：建立gre连接
ip tunnel add tun0 mode gre remote 201.1.2.10 local 201.1.2.5
ip tunnel help
ip link show          #查看所有网卡,不显示IP
ip a s
ip link set tun0 up
ip addr add 10.10.10.10/24 peer 10.10.10.5/24 dev tun0 #创建隧道

●两台机都要配

#################################################################################
PPTP

●windows网络改为public2，配Ip
●装包 pptpd-1.4.0-2.el7.x86_64
●查看配置文件
[root@proxy vpn]#rpm -qc pptpd
/etc/ppp/options.pptpd
/etc/pptpd.conf
/etc/sysconfig/pptpd
●修改pptp配置文件

vim /etc/pptpd.conf
localip 201.1.2.5
remoteip 192.168.3.1-50


vim /etc/ppp/options.pptpd   
require-mppe-128
ms-dns 8.8.8.8

vim /etc/ppp/chap-secrets   #建立VPN用户
gz * 1 *
lisi * 1 *

●windows添加新的网络
步骤1：选择稍后连接
步骤2：输入服务器地址
步骤3：输入配置的用户名 密码
步骤4：网络---属性--双击VPN---输入用户名，密码
步骤5：查看VPN连接属性

●查看登陆信息
[root@proxy vpn]# last | grep ppp | grep logged
gz       ppp0         201.1.2.20       Tue Aug 28 11:54   still logged in 
##################################################################################
L2TP+IPSec VPN


步骤一：部署IPSec服务
●确认软件
[root@client ~]# rpm -q libreswan
libreswan-3.20-3.el7.x86_64
●配置文件
vim /etc/ipsec.d/myipsec.conf    #添加配置文件模版    
//新建该文件，参考lnmp_soft/vpn/myipsec.conf
left=201.1.2.200  #改为自己公司的公网IP

●配置预共享密钥
/etc/ipsec.d/*.secrets #密码文件
vim
/etc/ipsec.d/myipsec.secrets
201.1.2.200 %any: PSK "randpass"  #IP地址为VPN服务器地址，"%any:"是固定格式，"PSK"是预共享密钥文件(Pre Share Key)
  
●启动IPSec服务
systemctl restart ipsec
ss -utanlp | grep pluto


步骤二：部署XL2TP服务
●配置文件/etc/xl2tpd/xl2tpd.conf
[lns default]
ip range = 192.168.3.128-192.168.3.254 //分配给客户端的IP池
local ip = 201.1.2.200                 //VPN服务器的IP地址
 
[root@client ~]# vim /etc/ppp/options.xl2tpd                //认证配置
require-mschap-v2                                         //添加一行，强制要求认证
#crtscts                                                //注释或删除该行
#lock                                                //注释或删除该行

root@client ~]# vim /etc/ppp/chap-secrets                    //修改密码文件
jacob   *       123456  *                //账户名称   服务器标记   密码   客户端IP

●windows端设置，看案例
##################################################################################
NTP时间同步
●
●大批量虚拟机管理器：
openstack【NTP】
ceph【NTP】 
docker,openshift,k8s【NTP】 #管理上十亿台虚拟机

大批量管理，前提之一是时间统一

●分层设计
15层

●/etc/chrony.conf

allow 192.168.4.0/24
local stratum 10

●客户端写计划任务：
crontab -e 
* * * * *  ntpdate 192.168.4.5

●闰秒
闰秒前必须要提前关闭时间服务器，因为很多软件不支持闰秒，看新闻公告
59 60 00 

●万年历查看
[root@client vpn]# cal 1750

凯撒时间 1752年9月
##################################################################################
pssh软件
并发

●装包：rpm -ivh pssh-2.3.1-5.el7.noarch.rpm
●查看pssh脚本：vim /usr/bin/pssh
●创建一个主机列表文件
●语法
[root@proxy ~]# man pssh                    //通过man帮助查看工具选项的作用
pssh提供并发远程连接功能
-A                使用密码远程其他主机（默认使用密钥）
-i                将输出显示在屏幕
-H                设置需要连接的主机
-h                设置主机列表文件                #用这个连接上述列表
-p                设置并发数量
-t                设置超时时间
-o dir            设置标准输出信息保存的目录
-e dir            设置错误输出信息保存的目录
-x                传递参数给ssh

●非交互生成密钥
ssh-keygen -N '' -f "/root/.ssh/id_rsa"
ssh-copy-id host1.....

例子：
pssh -iAH "host1 host2 host3" -x "-o StrictHostKeyChecking=no" echo host_hello
pssh -iAH "host1 host2 host3" echo host_hello 
pssh -iAh  host.txt ls /
pssh -ih host.txt echo hello    #需要先给远程主机发送密钥

●pscp.pssh #批量当前------>远程
pscp.pssh -h host.txt xyz.txt /root/   #把本地文件批量拷贝到远程主机/root/下

●pslurp    #批量远程------>当前
选项：-L
pslurp -h host.txt /etc/shadow /sha
pslurp -h host.txt -L /media /etc/shadow /sha 

●pnuke     #批量杀死进程，类似pkill


################################################################################

●nginx 开机自启动
echo "/usr/loacl/nginx/sbin/nginx" >> /etc/rc.local

●Nginx CA证书需要找权威CA中心才可用（收费）
  --CA中心做的证书不需要添加例外

●要学会查看官网  nginx.org
hash $remote_addr consistent;

●调度器 适合高并发量
●Nginx访问虚拟主机
proxy_pass http://back/;
proxy_set_header Host $host;



























