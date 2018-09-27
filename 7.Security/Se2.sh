账户锁定  chage -l -E
密码锁定 passwd -l -u -S
文件 lsattr chattr +i +a
文件系统 noatime,noexec
内核信息 /etc/issue

su 需要对方密码 su -   su - -c "命令"
sudo 需要管理员先授权，普通用户使用sudo提权
/etc/sudoers 
用户 主机名=(身份) NOPASSWD：命令,命令,!命令
%组  主机名=(身份) 命令,命令,!命令

ssh
禁用root
禁用空密码
白名单(仅允许某那些用户登陆)
密钥(禁用密码)
登陆时间
登陆次数
生成密钥【ssh-keygen】
传递密钥
/root/.ssh/authorized_keys

SElinux
/etc/selinux/config
setenfore 0

##################################################################################
加密/解密
发送方：明文—>密文
   --Tarena => 加密 => 25 31 24 23 46 31
接受方：密文—>明文
   --25 31 24 23 46 31 => 解密 => Tarena
##################################################################################
加密算法
●信息摘要(非对称算法)
  --MD5 SHA256 SHA512
   --用于校验数据是否被改
  --md5sum,sha256sum,sha512sum
●对称加密
  版本：gpg --version
  加密：gpg -c 明文 
  解密：gpg -d 密文 >> 明文
●非队称加密
  制作:gpg --gen-key                      #如果终端不能正常使用，输入reset，复位终端
  查看:gpg --list-keys                    #查看公钥环
  导出:gpg -a --export yoyoyo > yoyo.key  #-a,以ASCII码导出；
  
  导入:gpg --import yoyo.key              #客户端操作
  加密:gpg -e -r yoyoyo a.txt             #需要回传解密，传到有私钥的机器
  
gpg
  -e 加密 【encrypt】
  -d 解密
  -r 指定密钥
  -b 用私钥签名
  --verify 校验
##################################################################################
数字签名验证
  tar -zcf log.tar /var/log
  gpg -b log.tar
  cp log.tar log.tar.sig root@192.168.4.90:/root
  
  gpg --verify log.tar.sig log.tar #客户端做
##################################################################################
AIDE入侵检测
●装包 aide
 rpm -qc aide
 /etc/aide.conf
 /etc/logrotate.d/aide
●可以校验文件的权限，时间，文件属性，可设置
●初始化校验
  aide --init
●后续校验
  aide --check  #校验前需要把/var/lib/aide/aide.db.new.gz中的“new”去掉
##################################################################################
●NMAP扫描
IP扫描：nmap -n-sP 192.168.4.100 
网段扫描：nmap -n-sP 192.168.4.0/24
端口扫描：nmap -n -sT 192.168.4.90
端口扫描：nmap -n -sS 192.168.4.90

-s:全开扫描【scan】  #TCP三次握手做完
-S:半开扫描           #第二次握手就断开。优点:节省时间；缺点:网络有syn攻击检测，在企业，先打招呼,再敲
-P:ping
-U:扫描UDP服务,慢
-A:全面扫描,并且尝试登陆进去,检测出经过多少跳
-T:端口扫描
-n:不进行DNS解析
-p:指定端口范围，21-60

与ping的对比：
1.如果对方防火墙打开了，可以穿越防火墙测试对方是否活的;
2.可以看到mac地址;
3.可以ping一个网段;

补充：
traceroute www.sina.com #检测经过的路由信息
##################################################################################
tcpdump抓包

IP地址欺骗
MAC地址欺骗0
IP不同(域名类似)
www.icbc.coe
伪造一个dhcp，让数据全部发向问题服务器
中间人攻击\抓包

●命令
 tcpdump 
 tcpdump -A  -i eth1
 tcpdump -A -i eth2 -w a.log
 tcpdump -r a.log
 tcpdump -A host 192.168.4.15 and tcp port 21 
 tcpdump -w ftp.log -A host 192.168.4.15 and tcp port 21

 选项：
  -A,转换为 ACSII 码，以方便阅读
  -i,指定监控的网络接口
  -w,把数据包写到文件
  -r,读取抓包的文件
 过滤条件:
   类型：host、net、port、portrange
   方向：src、dst
   协议：tcp、udp、ip、wlan、arp
   条件：and、or、not

●案例：nginx登陆抓包
[root@proxy ~]# tcpdump -A -w nginx.log host 192.168.4.15 and tcp port 80
[root@proxy ~]# tcpdump -A -r nginx.log | grep Authorization
Authorization: Basic bmI6MQ==
[root@proxy ~]# echo "bmI6MQ==" | base64 -d   #base64编码
nb:1
##################################################################################
wireshark






























