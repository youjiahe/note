 ##############################################
构建安全加密的Web服务器

基础设施
--公钥[锁]：主要用来加密数据
--私钥[钥匙]：主要用来解密数据（与相应的公钥匹配）
--数字证书：证明拥有者的合法性/权威性
数字证书授权中心（公安局）
网站证书（类似营业执照）
根证书（类似公安局信息）
私钥
[一个网站服务器需要有这三个安全基础设施] （解密，钥匙）

虚拟机server0
1.部署网站证书（营业执照）
#/etc/pki/tls/certs
#下载网站证书
*.crt

2.部署根证书（公安局信息）
#/etc/pki/tls/certs
*.crt

3.部署私钥（解密[与加密完全不一样的算法，非对称加密]）
#/etc/pki/tls/private
*.key

4.装包  mod_ssl
装完包后，配置文件自动生成在调用配置文件目录下 /etc/httpd/conf.d/ssl.conf
修改配置文件[
1.修改网页根目录及域名
59 DocumentRoot "/var/www/www0"
60 ServerName www0.example.com:443

2.指定网站证书位置
100 SSLCertificateFile /etc/pki/tls/certs/server0.crt

3.指定私钥的位置
107 SSLCertificateKeyFile /etc/pki/tls/private/server0.key

4.指定根证书位置
122 SSLCACertificateFile /etc/pki/tls/certs/example-ca.crt]/etc/httpd/conf.d/ssl.conf

5.起服务httpd

6.浏览器验证
 Firefox server0.example.com
 选择我了解风险----->添加例外----->确认安全例外

 ##############################################
基础邮件服务[掌握电子邮件收发过程]
（不需要云计算工程师维护，直接买）

-电子邮件服务其基本功能
-为用户提供电子邮箱存储空间（用户名@邮件域名）

虚拟机server0
1.装包postfix
[root@server0 private]# rpm -q postfix
postfix-2.10.1-6.el7.x86_64

2.修改配置文件
/etc/postfix/main.cf
99 myorigin = server0.example.com #默认补全的域名后缀
116 inet_interfaces = all             #允许所有人使用邮件服务
164 mydestination = server0.example.com  #判断为本域邮件

3.重启服务postfix

4.验证
创建本地用户进行收发邮件

 ############################################
划分分区，parted分区工具
 MBR  
 
 GPT  大容量的划分，2T以上，最多支持128个主分区

parted
mktable gpt #指定分区模式[必须确认该分区是新的分区，再打该命令，初始化分区模式，数据都会全部丢失]

print        #查看分区模式
mkpart 
分区名称？   []
文件系统类型？[]
起始点？
结束点？
unit GB #设置单位。。
Quit

 ##############################################
交换分区：以空闲的分区充当交换分区

一、创建交换空间
1.前提要有空闲的分区
2.格式化交换文件系统
-mkswap /dev/vdb1
3.启用交换分区
-swapon/dev/vdb1      #临时启用交换空间/dev/vdb1
-swapon -s 

4.完成开机自动启用
修改配置文件/etc/fstab
/dev/vdb1 swap  swap defaults 0 0

5.验证开机启用
（1）swapoff
（2）swapon -a[Mount -a不能用于交换分区]
