VPN NTP PSSH
###################################################################################
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
###################################################################################
PPTP
装包pptpd-1.4.0-2.el7.x86_64
配置
rpm -qc pptpd
vim /etc/pptpd.conf
    localip 201.1.2.5
    remoteip 192.168.3.1-50
vim /etc/ppp/options.pptpd   
    require-mppe-128
    ms-dns 8.8.8.8
vim /etc/ppp/chap-secrets 
    gz * 1 *
    lisi * 1 *
起服务pptpd

●windows添加新的网络
  稍后连接
###################################################################################
L2TP+IPSec 

步骤一：部署IPSec服务
rpm -q libreswan
vim 
 /etc/ipsec.d/myipsec.conf    #添加配置文件模版 
   left=201.1.2.200           #改为自己公司的公网IP
vim
/etc/ipsec.d/myipsec.secrets
   201.1.2.200 %any: PSK "randpass"
systemctl restart ipsec
ss -utanlp | grep pluto

步骤二：部署XL2TP服务
vim
/etc/xl2tpd/xl2tpd.conf
[lns default]
ip range = 192.168.3.128-192.168.3.254 //分配给客户端的IP池
local ip = 201.1.2.200                 //VPN服务器的IP地址
vim 
/etc/ppp/options.xl2tpd               
require-mschap-v2                                    
#crtscts                                             
#lock
vim 
/etc/ppp/chap-secrets                   
jacob   *       123456  *    
###############################################################
NTP时间同步
●服务端：
/etc/chrony.conf
allow 192.168.4.0/24
local stratum 10
●客户端：
crontab -e 
* * * * *  ntpdate 192.168.4.5
●闰秒
●万年历查看
 cal 1750
凯撒时间 1752年9月
###############################################################
pssh            
●pssh提供并发远程连接功能
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
●pscp.pssh #批量当前------>远程
●pslurp    #批量远程------>当前
选项：-L
●pnuke     #批量杀死进程，类似pkill



















